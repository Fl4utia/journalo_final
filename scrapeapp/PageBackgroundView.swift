import SwiftUI

struct PageBackgroundView: View {
    var style: String
    
    var body: some View {
        Color.white
            .overlay(
                Group {
                    if style == "Lined" {
                        LinedPattern()
                    } else if style == "Grid" {
                        GridPattern()
                    } else if style == "Dotted" {
                        DottedPattern()
                    } else {
                        Color.clear // Plain
                    }
                }
            )
    }
}

// Drawing helper for Lined paper
struct LinedPattern: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                for i in 0..<Int(geometry.size.height / 30) {
                    let y = CGFloat(i) * 30 + 30
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                }
            }
            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
        }
    }
}

// Drawing helper for Grid paper
struct GridPattern: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let spacing: CGFloat = 20
                for i in 0..<Int(geometry.size.height / spacing) {
                    let y = CGFloat(i) * spacing + spacing
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                }
                for i in 0..<Int(geometry.size.width / spacing) {
                    let x = CGFloat(i) * spacing + spacing
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                }
            }
            .stroke(Color.green.opacity(0.3), lineWidth: 0.5)
        }
    }
}

// Drawing helper for Dotted paper
struct DottedPattern: View {
    var body: some View {
        Color.clear
            .overlay(
                Rectangle()
                    .strokeBorder(style: StrokeStyle(lineWidth: 0.5, dash: [1, 15]))
                    .foregroundColor(Color.gray.opacity(0.4))
            )
    }
}
