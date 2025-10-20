import SwiftUI
import UIKit
import CoreData

struct ScrapbookCoverView: View {
    var scrapbook: Scrapbook

    var body: some View {
        // Explicitly centered VStack
        VStack(alignment: .center, spacing: 5) {
            Group {
                if let imageData = scrapbook.coverImageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    // Fallback rectangle maintains the same shape
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                }
            }
            // Enforced fixed size to standardize the visual ratio (150x200)
            .frame(width: 150, height: 200)
            .clipped()
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(radius: 5)
            
            if let date = scrapbook.creationDate {
                Text(date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        // FIX: The outer .frame(width: 170) is REMOVED to enable centered adaptive layout.
    }
}
