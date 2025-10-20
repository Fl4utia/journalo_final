import SwiftUI
import CoreData

struct ScrapbookContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var scrapbook: Scrapbook
    
    @State private var pages: [ScrapbookPage] = []
    @State private var currentPageIndex: Int = 0

    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var showingTextSheet = false
    @State private var newText: String = ""

    var body: some View {
        ZStack {
            // 1. Dynamic Background Layer
            PageBackgroundView(style: scrapbook.pageStyle ?? "Plain")
                .ignoresSafeArea()
            
            // 2. Content Layer (Elements and Buttons)
            VStack {
                // Main ZStack for Movable Elements
                ZStack {
                    if pages.indices.contains(currentPageIndex) {
                        ForEach($pages[currentPageIndex].elements) { $element in
                            MovableElementView(element: $element)
                                .zIndex(element.zIndex)
                                .onTapGesture {
                                    element.zIndex = Date().timeIntervalSince1970
                                }
                        }
                    } else {
                        Text("Tap '+' to add your first page.").foregroundColor(.gray)
                    }
                }
                .frame(maxHeight: .infinity) // Ensures ZStack takes up most of the space
                
                
                // 3. Control Bar (Integrated Toolbar)
                HStack(spacing: 20) {
                    // Page Navigation Controls
                    pageNavigationControls
                    
                    Spacer()
                    
                    // Add Element Controls
                    addElementControls
                    
                    Spacer()
                    
                    // Page Action Controls
                    pageActionControls
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color.white.opacity(0.9))
                .cornerRadius(10)
                .padding(.horizontal)
                .shadow(radius: 3)
            }
        }
        .navigationTitle(scrapbook.title ?? "Scrapbook Page \(currentPageIndex + 1)")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: loadPages)
        .onDisappear(perform: savePages)
        
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: $inputImage)
        }
        .sheet(isPresented: $showingTextSheet, onDismiss: addTextElement) {
            TextEntrySheet(text: $newText)
        }
    }
    
    // MARK: - Toolbar View Builders (Properties remain in this file)
    
    private var pageNavigationControls: some View {
        Group {
            Button { if currentPageIndex > 0 { currentPageIndex -= 1 } } label: { Image(systemName: "arrow.backward.circle").imageScale(.large) } .disabled(currentPageIndex == 0)
            
            Text("\(currentPageIndex + 1) / \(pages.count)").font(.caption)
            
            Button { if currentPageIndex < pages.count - 1 { currentPageIndex += 1 } } label: { Image(systemName: "arrow.forward.circle").imageScale(.large) } .disabled(currentPageIndex == pages.count - 1)
        }
    }
    
    private var addElementControls: some View {
        Group {
            Button { showingImagePicker = true } label: { Image(systemName: "photo.on.rectangle.angled").imageScale(.large) }.disabled(pages.isEmpty)
            Button { showingTextSheet = true } label: { Image(systemName: "t.square").imageScale(.large) }.disabled(pages.isEmpty)
        }
    }
    
    private var pageActionControls: some View {
        Group {
            Button { addPage() } label: { Image(systemName: "plus.circle.fill").imageScale(.large).foregroundColor(.blue) }
            Button(role: .destructive) { deletePage() } label: { Image(systemName: "trash.fill").imageScale(.large).foregroundColor(.red) } .disabled(pages.count <= 1)
        }
    }
    
    // MARK: - Actions (Page/Element Management)
    
    private func addPage() {
        let newPage = ScrapbookPage()
        pages.append(newPage)
        currentPageIndex = pages.count - 1
        savePages()
    }
    
    private func deletePage() {
        guard pages.count > 1 else { return } // Prevent deleting the last page
        
        pages.remove(at: currentPageIndex)
        
        if currentPageIndex >= pages.count {
            currentPageIndex -= 1
        }
        savePages()
    }
    
    private func loadImage() {
        guard let inputImage = inputImage, pages.indices.contains(currentPageIndex) else { return }
        let imageData = inputImage.jpegData(compressionQuality: 0.8)
        let newElement = PageElement(imageData: imageData, text: nil)
        pages[currentPageIndex].elements.append(newElement)
        self.inputImage = nil
        savePages()
    }
    
    private func addTextElement() {
        guard !newText.isEmpty, pages.indices.contains(currentPageIndex) else { return }
        let newElement = PageElement(imageData: nil, text: newText)
        pages[currentPageIndex].elements.append(newElement)
        self.newText = ""
        savePages()
    }
    
    // MARK: - Core Data Load/Save
    
    private func loadPages() {
        guard let data = scrapbook.bodyContent else {
            pages = [ScrapbookPage()] // Initialize with one page if empty
            return
        }
        
        do {
            let decoder = JSONDecoder()
            pages = try decoder.decode([ScrapbookPage].self, from: data)
            if pages.isEmpty { pages = [ScrapbookPage()] }
            currentPageIndex = min(currentPageIndex, pages.count - 1)
        } catch {
            print("Failed to decode scrapbook pages: \(error.localizedDescription)")
            pages = [ScrapbookPage()]
        }
    }
    
    private func savePages() {
        do {
            let encoder = JSONEncoder()
            scrapbook.bodyContent = try encoder.encode(pages)
            try viewContext.save()
        } catch {
            print("Failed to encode and save scrapbook pages: \(error.localizedDescription)")
        }
    }
}
