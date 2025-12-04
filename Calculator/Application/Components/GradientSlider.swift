//
//  GradientSlider.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

import SwiftUI

struct GradientSlider: View {

    @Binding var value: Double
    let range: ClosedRange<Double>
    let gradient: Gradient

    private let trackHeight: CGFloat = 18
    private let thumbSize: CGFloat = 28

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let progress = CGFloat(
                (value - range.lowerBound) /
                (range.upperBound - range.lowerBound)
            )

            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.gray.opacity(0.15))
                    .frame(height: trackHeight)

                Capsule()
                    .fill(
                        LinearGradient(
                            gradient: gradient,
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(
                        width: max(thumbSize, progress * width),
                        height: trackHeight
                    )

                Circle()
                    .fill(
                        LinearGradient(
                            gradient: gradient,
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: thumbSize, height: thumbSize)
                    .shadow(color: .black.opacity(0.2),
                            radius: 4, x: 0, y: 2)
                    .offset(x: progress * (width - thumbSize))
                    .gesture(
                        DragGesture()
                            .onChanged { g in
                                let clampedX = min(
                                    max(0, g.location.x),
                                    width - thumbSize
                                )
                                let ratio = clampedX / (width - thumbSize)
                                let newValue =
                                    range.lowerBound +
                                    Double(ratio) *
                                    (range.upperBound - range.lowerBound)
                                value = newValue
                            }
                    )
            }
        }
    }
}
