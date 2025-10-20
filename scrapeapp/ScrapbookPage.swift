import Foundation
import CoreGraphics
import UIKit

// Represents a single image or text element on a page
struct PageElement: Identifiable, Codable {
    let id: UUID
    
    var imageData: Data?
    var text: String?
    
    var position: CGPoint
    var scale: CGFloat
    var rotation: Double
    var zIndex: Double
    
    // Custom initializer to provide defaults when creating a NEW element
    init(id: UUID = UUID(),
         imageData: Data? = nil,
         text: String? = nil,
         position: CGPoint = CGPoint(x: 200, y: 300),
         scale: CGFloat = 1.0,
         rotation: Double = 0.0,
         zIndex: Double = Date().timeIntervalSince1970) {
        self.id = id
        self.imageData = imageData
        self.text = text
        self.position = position
        self.scale = scale
        self.rotation = rotation
        self.zIndex = zIndex
    }
    
    // Convenience property to convert saved Data back to UIImage
    var uiImage: UIImage? {
        if let data = imageData {
            return UIImage(data: data)
        }
        return nil
    }
}

// Represents a single page containing multiple elements
struct ScrapbookPage: Identifiable, Codable {
    let id: UUID
    var elements: [PageElement] = []
    
    init(id: UUID = UUID(), elements: [PageElement] = []) {
        self.id = id
        self.elements = elements
    }
}
