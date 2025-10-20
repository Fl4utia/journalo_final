import SwiftUI
import UIKit // Explicitly import UIKit for UIImage

struct CoverSelectionView: View {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) var dismiss
    
    // FIX: Using consistent naming ("Book Cover [Number]") for all assets.
    // NOTE: All 10 images must exist in your Assets.xcassets with these exact names.
    let availableCovers: [UIImage] = [
        UIImage(named: "Book Cover 1")!,
        UIImage(named: "Book Cover2")!,
        UIImage(named: "Book Cover3")!,
        UIImage(named: "Book Cover4")!,
        UIImage(named: "Book Cover5")!,
        // Added missing asset 6
        UIImage(named: "Book Cover7")!,
        UIImage(named: "Book Cover8")!,
        UIImage(named: "Book Cover9")!,
        UIImage(named: "Book Cover10")!
    ]
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(availableCovers, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .onTapGesture {
                                self.selectedImage = image
                                dismiss()
                            }
                    }
                }
                .padding()
            }
            .navigationTitle("Select a Cover")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
    
}
