import SwiftUI
import UIKit // Required for UIImage
import CoreData

struct ScrapbookCoverView: View {
    var scrapbook: Scrapbook

    var body: some View {
        VStack(spacing: 5) {
            // Display the Cover Image from Binary Data
            if let imageData = scrapbook.coverImageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(radius: 5)
            } else {
                // Fallback style
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
            
            // Display the created date text
            if let date = scrapbook.creationDate {
                Text(date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}
