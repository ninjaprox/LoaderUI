//
//  BallClipRotatePulse.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/9/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

struct VerticalRing: Shape {
    func path(in rect: CGRect) -> Path {
        let dimension = min(rect.size.width, rect.size.height)
        let lineWidth = dimension / 32
        var topHalf = Path()
        var bottomHalf = Path()
        var path = Path()

        topHalf.addArc(center: CGPoint(x: dimension / 2, y: dimension / 2),
                       radius: dimension / 2,
                       startAngle: Angle(radians: 5 * .pi / 4),
                       endAngle: Angle(radians: 7 * .pi / 4),
                       clockwise: false)
        bottomHalf.addArc(center: CGPoint(x: dimension / 2, y: dimension / 2),
                          radius: dimension / 2,
                          startAngle: Angle(radians: 3 * .pi / 4),
                          endAngle: Angle(radians: .pi / 4),
                          clockwise: true)
        path.addPath(topHalf)
        path.addPath(bottomHalf)

        return path.strokedPath(StrokeStyle(lineWidth: lineWidth, lineCap: .round))
    }
}

struct MyRing: View, KeyframeAnimatable {
    @State private var scale: CGFloat = 1
    @State private var rotation = 0.0
    let scaleValues: [Double]
    let rotationValues: [Double]
    let nextKeyframe: (KeyframeAnimationController<Self>.Animator?) -> Void

    var body: some View {
        VerticalRing()
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

fileprivate struct MyCircle: View, KeyframeAnimatable {
    @State private var scale: CGFloat = 1
    let values: [Double]
    let nextKeyframe: (KeyframeAnimationController<Self>.Animator?) -> Void

    var body: some View {
        Circle()
            .scale(0.5)
            .scaleEffect(scale)
            .onAppear() {
                self.nextKeyframe { keyframe, _ in
                    self.scale = CGFloat(self.values[keyframe])
                }
        }
    }
}

struct BallClipRotatePulse: View {
    var body: some View {
        GeometryReader(content: self.render)
    }

    func render(geometry: GeometryProxy) -> some View {
        let dimension = min(geometry.size.width, geometry.size.height)

        return ZStack {
            renderMyRing()
            renderMyCircle()
        }.frame(width: dimension, height: dimension, alignment: .center)
    }

    func renderMyRing() -> some View {
        let duration = 1.0
        let timingFunction = TimingFunction.timingCurve(c0x: 0.09, c0y: 0.57, c1x: 0.49, c1y: 0.9)
        let timingFunctions = [timingFunction, timingFunction]
        let keyTimes = [0, 0.5, 1]
        let scaleValues = [1, 0.6, 1]
        let rotationValues = [0.0, .pi, 2 * .pi]

        return KeyframeAnimationController<MyRing>(beginTime: 0,
                                                   duration: duration,
                                                   timingFunctions: timingFunctions,
                                                   keyTimes: keyTimes) {
                                                    MyRing(scaleValues: scaleValues,
                                                           rotationValues: rotationValues,
                                                           nextKeyframe: $0)
        }
    }

    func renderMyCircle() -> some View {
        let duration = 1.0
        let timingFunction = TimingFunction.timingCurve(c0x: 0.09, c0y: 0.57, c1x: 0.49, c1y: 0.9)
        let timingFunctions = [timingFunction, timingFunction]
        let keyTimes = [0, 0.3, 1]
        let values = [1, 0.3, 1]

        return KeyframeAnimationController<MyCircle>(beginTime: 0,
                                                     duration: duration,
                                                     timingFunctions: timingFunctions,
                                                     keyTimes: keyTimes) {
                                                        MyCircle(values: values,
                                                                 nextKeyframe: $0)
        }
    }
}

struct BallClipRotatePulse_Previews: PreviewProvider {
    static var previews: some View {
        BallClipRotatePulse()
    }
}
