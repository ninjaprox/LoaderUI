//
//  BallRotate.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/10/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

fileprivate struct MyCircles: View, KeyframeAnimatable {
    @State private var scale: CGFloat = 1
    @State private var rotation = 0.0
    let scaleValues: [Double]
    let rotationValues: [Double]
    let nextKeyframe: (KeyframeAnimationController<Self>.Animator?) -> Void

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
        .scaleEffect(scale)
        .rotationEffect(Angle(radians: rotation))
        .onAppear() {
            self.nextKeyframe { keyframe, _ in
                self.scale = CGFloat(self.scaleValues[keyframe])
                self.rotation = self.rotationValues[keyframe]
            }
        }
    }
}


struct BallRotate: View {
    private let duration = 1.0
    private let timingFunction = TimingFunction.timingCurve(c0x: 0.7, c0y: -0.13, c1x: 0.22, c1y: 0.86)
    private let keyTimes = [0, 0.5, 1]
    private let scaleValues = [1, 0.6, 1]
    private let rotationValues = [0.0, .pi, 2 * .pi]

    var body: some View {
        GeometryReader(content: self.render)
    }

    func render(geometry: GeometryProxy) -> some View {
        let dimension = min(geometry.size.width, geometry.size.height)
        let timingFunctions = [timingFunction, timingFunction]

        return KeyframeAnimationController<MyCircles>(beginTime: 0,
                                                      duration: duration,
                                                      timingFunctions: timingFunctions,
                                                      keyTimes: keyTimes) {
                                                        MyCircles(scaleValues: self.scaleValues,
                                                                  rotationValues: self.rotationValues,
                                                                  nextKeyframe: $0)
        }
        .frame(width: dimension, height: dimension, alignment: .center)
    }
}

struct BallRotate_Previews: PreviewProvider {
    static var previews: some View {
        BallRotate()
    }
}
