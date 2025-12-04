//
//  DiscreteSlider.swift
//  Calculator
//
//  Created by DAS  on 4/12/25.
//

import SwiftUI

struct DiscreteSlider: View {

    @Binding var index: Int
    let values: [Int]
    let gradient: Gradient

    private let trackHeight: CGFloat = 18
    private let thumbSize: CGFloat = 30

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let steps = max(values.count - 1, 1)
            let stepWidth = width / CGFloat(steps)

            let centerX = CGFloat(index) * stepWidth

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
                        width: max(thumbSize / 2, centerX + thumbSize / 2),
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

                    .offset(x: min(max(0, centerX - thumbSize / 2),
                                   width - thumbSize))
                    .gesture(
                        DragGesture()
                            .onChanged { g in

                                let clampedCenter = min(
                                    max(0, g.location.x),
                                    width
                                )
                                let newIndex = Int(
                                    round(clampedCenter / stepWidth)
                                )
                                index = min(max(0, newIndex),
                                            values.count - 1)
                            }
                    )
            }
        }
    }
}
