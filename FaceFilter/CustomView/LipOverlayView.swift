//
//  LipOverlayView.swift
//  FaceFilter
//
//  Created by Dung Tan Nguyen on 9/7/25.
//

import SwiftUI

struct LipOverlay: View {
    let outer: [CGPoint]
    let inner: [CGPoint]
    let imageSize: CGSize
    let containerSize: CGSize
    let color: Color

    var body: some View {
        let imageAspect = imageSize.width / imageSize.height
        let containerAspect = containerSize.width / containerSize.height

        let (displayedSize, xOffset, yOffset): (CGSize, CGFloat, CGFloat) = {
            if imageAspect > containerAspect {
                let width = containerSize.width
                let height = width / imageAspect
                return (CGSize(width: width, height: height), 0, (containerSize.height - height) / 2)
            } else {
                let height = containerSize.height
                let width = height * imageAspect
                return (CGSize(width: width, height: height), (containerSize.width - width) / 2, 0)
            }
        }()

        func scaled(_ points: [CGPoint]) -> [CGPoint] {
            points.map {
                CGPoint(
                    x: $0.x * (displayedSize.width / imageSize.width) + xOffset,
                    y: $0.y * (displayedSize.height / imageSize.height) + yOffset
                )
            }
        }

        return Path { path in
            guard !outer.isEmpty else { return }

            let outerScaled = scaled(outer)
            let innerScaled = scaled(inner)

            path.addLines(outerScaled)
            path.closeSubpath()

            if !innerScaled.isEmpty {
                path.addLines(innerScaled)
                path.closeSubpath()
            }
        }
        .fill(color.opacity(0.5), style: FillStyle(eoFill: true)) // even-odd fill
        .blendMode(.multiply)
    }
}
