//
//  BallRotate.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/10/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

fileprivate struct MyCircles: View {
    var body: some View {
        GeometryReader(content: self.render)
    }

    func render(geometry: GeometryProxy) -> some View {
        let dimension = min(geometry.size.width, geometry.size.height)
        let spacing = dimension / 8

        return HStack(spacing: spacing) {
            Circle().opacity(0.8)
            Circle()
            Circle().opacity(0.8)
        }
    }
}


public struct BallRotate: View {
    private let duration = 1.0
    private let timingFunction = TimingFunction.timingCurve(c0x: 0.7, c0y: -0.13, c1x: 0.22, c1y: 0.86)
    private let keyTimes = [0, 0.5, 1]
    private let scaleValues: [CGFloat] = [1, 0.6, 1]
    private let rotationValues = [0.0, .pi, 2 * .pi]

    public var body: some View {
        GeometryReader(content: self.render)
    }

    public init() { }

    func render(geometry: GeometryProxy) -> some View {
        let dimension = min(geometry.size.width, geometry.size.height)
        let timingFunctions = Array(repeating: timingFunction, count: keyTimes.count - 1)

        return KeyframeAnimationController(beginTime: 0,
                                           duration: duration,
                                           timingFunctions: timingFunctions,
                                           keyTimes: keyTimes) {
                                            MyCircles()
                                                .scaleEffect(self.scaleValues[$0])
                                                .rotationEffect(Angle(radians: self.rotationValues[$0]))
        }
        .frame(width: dimension, height: dimension, alignment: .center)
    }
}

struct BallRotate_Previews: PreviewProvider {
    static var previews: some View {
        BallRotate()
    }
}
