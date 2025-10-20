import SwiftUI
import CoreData
import UIKit

struct ScrapbookEditView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss

    var isNewScrapbook: Bool
    @State private var scrapbookToEdit: Scrapbook?

    @State private var scrapbookTitle: String
    @State private var coverImage: UIImage?
    @State private var showingCoverSelection = false
    @State private var selectedPageStyle: String // State for the page style selector
    
    let availableStyles = ["Plain", "Lined", "Grid", "Dotted"]

    init(isNewScrapbook: Bool, scrapbookToEdit: Scrapbook? = nil) {
        self.isNewScrapbook = isNewScrapbook
        self._scrapbookToEdit = State(initialValue: scrapbookToEdit)
        
        // Initialize state variables based on whether we are editing or creating
        if let existingScrapbook = scrapbookToEdit {
            self._scrapbookTitle = State(initialValue: existingScrapbook.title ?? "Untitled")
            self._selectedPageStyle = State(initialValue: existingScrapbook.pageStyle ?? "Plain")
            if let imageData = existingScrapbook.coverImageData {
                self._coverImage = State(initialValue: UIImage(data: imageData))
            }
        } else {
            self._scrapbookTitle = State(initialValue: "New Scrapbook")
            self._selectedPageStyle = State(initialValue: "Plain")
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                // Display selected cover image
                if let image = coverImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
                
                Button("Choose a Cover") {
                    showingCoverSelection = true
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                
                // Title input field
                TextField("Enter Scrapbook Title", text: $scrapbookTitle)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                
                // Page Style Selector
                Picker("Page Style", selection: $selectedPageStyle) {
                    ForEach(availableStyles, id: \.self) { style in
                        Text(style)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationTitle(isNewScrapbook ? "New Scrapbook" : "Edit Setup")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveScrapbook()
                    }
                    // Validation: Save button disabled if no cover or no title
                    .disabled(coverImage == nil || scrapbookTitle.isEmpty)
                }
            }
            .sheet(isPresented: $showingCoverSelection) {
                CoverSelectionView(selectedImage: $coverImage)
                    .environment(\.managedObjectContext, viewContext)
            }
        }
    }

    private func saveScrapbook() {
        let scrapbook: Scrapbook
        if let existingScrapbook = scrapbookToEdit {
            scrapbook = existingScrapbook
        } else {
            // New scrapbook creation
            scrapbook = Scrapbook(context: viewContext)
            scrapbook.creationDate = Date()
        }
        
        // Save properties
        scrapbook.title = scrapbookTitle
        scrapbook.pageStyle = selectedPageStyle
        
        if let image = coverImage {
            // Convert UIImage to Data for Core Data storage
            scrapbook.coverImageData = image.jpegData(compressionQuality: 0.8)
        }
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Error saving scrapbook setup: \(error.localizedDescription)")
        }
    }
}

#Preview {
    // Provide the Core Data environment for previewing
    ScrapbookEditView(isNewScrapbook: true)
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
