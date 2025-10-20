import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Scrapbook.creationDate, ascending: false)], animation: .default)
    private var scrapbooks: FetchedResults<Scrapbook>
    
    @State private var showingCreateSheet = false
    
    // FIX: Using adaptive layout to achieve perfect centering.
    // It fits as many items as possible (2 in this case) and centers them.
    private let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 150), spacing: 15)
    ]

    var body: some View {
        NavigationView {
            ZStack {
                // Background Layer
                Image("HomePageBackground")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.8)
                
                Color(red: 0.95, green: 0.94, blue: 0.91).opacity(0.7).ignoresSafeArea()
                
                VStack {
                    Text("MY SCRAPBOOKS")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top, 20)
                    
                    // Header/Note Section
                    VStack(spacing: 10) {
                        Text("Crafting Memories, One Page at a Time.")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text("This app is built from a passion for preserving life's fleeting moments. Create, cherish, and share your journey!")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    // Scrollable Scrapbook Grid
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 15) {
                            ForEach(scrapbooks, id: \.self) { scrapbook in
                                NavigationLink(destination: ScrapbookContentView(scrapbook: scrapbook)) {
                                    ScrapbookCoverView(scrapbook: scrapbook)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        // Ensures the grid content takes max width and padding handles symmetry
                        .padding(.horizontal, 16)
                    }
                    
                    // CREATE SCRAPBOOK Button
                    Button("CREATE SCRAPBOOK") {
                        showingCreateSheet = true
                    }
                    .font(.headline)
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1)
                    )
                    .padding()
                }
            }
            .sheet(isPresented: $showingCreateSheet) {
                ScrapbookEditView(isNewScrapbook: true)
                .environment(\.managedObjectContext, viewContext)
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
