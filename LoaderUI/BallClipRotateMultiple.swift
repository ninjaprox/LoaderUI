//
//  BallClipRotateMultiple.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/10/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

struct HorizontalRing: Shape {
    func path(in rect: CGRect) -> Path {
        let dimension = min(rect.size.width, rect.size.height)
        let lineWidth = dimension / 16
        var leftHalf = Path()
        var rightHalf = Path()
        var path = Path()

        leftHalf.addArc(center: CGPoint(x: dimension / 2, y: dimension / 2),
                        radius: dimension / 2,
                        startAngle: Angle(radians: 3 * .pi / 4),
                        endAngle: Angle(radians: 5 * .pi / 4),
                        clockwise: false)
        rightHalf.addArc(center: CGPoint(x: dimension / 2, y: dimension / 2),
                         radius: dimension / 2,
                         startAngle: Angle(radians: .pi / 4),
                         endAngle: Angle(radians: 7 * .pi / 4),
                         clockwise: true)
        path.addPath(leftHalf)
        path.addPath(rightHalf)

        return path.strokedPath(StrokeStyle(lineWidth: lineWidth, lineCap: .round))
    }
}

fileprivate struct MyBigRing: View, KeyframeAnimatable {
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

fileprivate struct MySmallRing: View, KeyframeAnimatable {
    @State private var scale: CGFloat = 1
    @State private var rotation = 0.0
    let scaleValues: [Double]
    let rotationValues: [Double]
    let nextKeyframe: (KeyframeAnimationController<Self>.Animator?) -> Void

    var body: some View {
        HorizontalRing()
            .scale(0.5)
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

struct BallClipRotateMultiple: View {
    var body: some View {
        GeometryReader(content: self.render)
    }

    func render(geometry: GeometryProxy) -> some View {
        let dimension = min(geometry.size.width, geometry.size.height)

        return ZStack {
            renderMyBigRing()
            renderMySmallRing()
        }.frame(width: dimension, height: dimension, alignment: .center)
    }

    func renderMyBigRing() -> some View {
        let duration = 1.0
        let timingFunction = TimingFunction.easeInOut
        let timingFunctions = [timingFunction, timingFunction]
        let keyTimes = [0, 0.5, 1]
        let scaleValues = [1, 0.6, 1]
        let rotationValues = [0.0, .pi, 2 * .pi]

        return KeyframeAnimationController<MyBigRing>(beginTime: 0,
                                                      duration: duration,
                                                      timingFunctions: timingFunctions,
                                                      keyTimes: keyTimes) {
                                                        MyBigRing(scaleValues: scaleValues,
                                                                  rotationValues: rotationValues,
                                                                  nextKeyframe: $0)
        }
    }

    func renderMySmallRing() -> some View {
        let duration = 1.0
        let timingFunction = TimingFunction.easeInOut
        let timingFunctions = [timingFunction, timingFunction]
        let keyTimes = [0, 0.5, 1]
        let scaleValues = [1, 0.6, 1]
        let rotationValues = [0.0, -.pi, -2 * .pi]

        return KeyframeAnimationController<MySmallRing>(beginTime: 0,
                                                        duration: duration,
                                                        timingFunctions: timingFunctions,
                                                        keyTimes: keyTimes) {
                                                            MySmallRing(scaleValues: scaleValues,
                                                                        rotationValues: rotationValues,
                                                                        nextKeyframe: $0)
        }
    }
}

struct BallClipRotateMultiple_Previews: PreviewProvider {
    static var previews: some View {
        BallClipRotateMultiple()
    }
}
