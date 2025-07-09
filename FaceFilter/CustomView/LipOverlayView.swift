//
//  LipOverlayView.swift
//  FaceFilter
//
//  Created by Dung Tan Nguyen on 9/7/25.
//

import SwiftUI

struct LipOverlayView: View {
    let points: [CGPoint]
    let imageSize: CGSize
    let containerSize: CGSize
    let color: Color

    var body: some View {
        let imageAspect = imageSize.width / imageSize.height
        let containerAspect = containerSize.width / containerSize.height
        let displayedSize: CGSize
        let xOffset: CGFloat
        let yOffset: CGFloat

        if imageAspect > containerAspect {
            let width = containerSize.width
            let height = width / imageAspect
            displayedSize = CGSize(width: width, height: height)
            xOffset = 0
            yOffset = (containerSize.height - height) / 2
        } else {
            let height = containerSize.height
            let width = height * imageAspect
            displayedSize = CGSize(width: width, height: height)
            xOffset = (containerSize.width - width) / 2
            yOffset = 0
        }

        return Path { path in
            guard !points.isEmpty else { return }

            let scaleX = displayedSize.width / imageSize.width
            let scaleY = displayedSize.height / imageSize.height

            let transformedPoints = points.map { point in
                CGPoint(
                    x: point.x * scaleX + xOffset,
                    y: point.y * scaleY + yOffset
                )
            }

            path.move(to: transformedPoints.first!)
            for point in transformedPoints.dropFirst() {
                path.addLine(to: point)
            }
            path.closeSubpath()
        }
        .fill(color.opacity(0.5))
        .blendMode(.multiply)
    }
}
