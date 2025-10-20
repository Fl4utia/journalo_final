//
//  MovableElementView.swift
//  scrapeapp
//
//  Created by sreedhar rongala on 17/10/25.
//

import Foundation
import SwiftUI

struct MovableElementView: View {
    @Binding var element: PageElement
    
    // Gestures State
    @GestureState private var startPosition: CGPoint? = nil // Tracks starting point for drag
    @GestureState private var startScale: CGFloat? = nil    // Tracks starting size for pinch

    // Gesture for Moving the Element
    var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                let startPos = startPosition ?? element.position
                element.position = CGPoint(
                    x: startPos.x + value.translation.width,
                    y: startPos.y + value.translation.height
                )
            }
            .updating($startPosition) { (value, state, transaction) in
                state = state ?? element.position
            }
    }
    
    // Gesture for Scaling/Resizing the Element
    var pinchGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                let startScl = startScale ?? element.scale
                // Ensure scale doesn't go too small or too large
                element.scale = min(max(startScl * value, 0.5), 3.0)
            }
            .updating($startScale) { (value, state, transaction) in
                state = state ?? element.scale
            }
    }
    
    var body: some View {
        Group {
            if let image = element.uiImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150 * element.scale) // Base size, scaled
                    .rotationEffect(.degrees(element.rotation))
                    .border(Color.blue.opacity(0.5), width: 1 / element.scale)
                    
            } else if let text = element.text {
                Text(text)
                    .font(.custom("Helvetica", size: 18 * element.scale))
                    .padding(8)
                    .background(Color.yellow.opacity(0.8))
                    .cornerRadius(5 / element.scale)
            }
        }
        // Apply transformations
        .scaleEffect(1.0) // Scale handled internally by frame width
        .position(element.position)
        // Combine Drag and Pinch gestures to work simultaneously
        .gesture(dragGesture.simultaneously(with: pinchGesture))
    }
}
