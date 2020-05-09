//
//  BallClipRotate.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/10/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

struct OpenRing: Shape {
    
    func path(in rect: CGRect) -> Path {
        let dimension = min(rect.size.width, rect.size.height)
        let lineWidth = dimension / 32
        var path = Path()

        path.addArc(center: CGPoint(x: dimension / 2, y: dimension / 2),
                    radius: dimension / 2,
                    startAngle: Angle(radians: 5 * .pi / 4),
                    endAngle: Angle(radians: 7 * .pi / 4),
                    clockwise: true)

        return path.strokedPath(StrokeStyle(lineWidth: lineWidth, lineCap: .round))
    }
}

fileprivate struct MyRing: View, KeyframeAnimatable {
    @State private var scale: CGFloat = 1
    @State private var rotation = 0.0
    let scaleValues: [Double]
    let rotationValues: [Double]
    let nextKeyframe: (KeyframeAnimationController<Self>.Animator?) -> Void

    var body: some View {
        OpenRing()
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

struct BallClipRotate: View {
    private let duration = 0.75
    private let timingFunction = TimingFunction.linear
    private let keyTimes = [0, 0.5, 1]
    private let scaleValues = [1, 0.6, 1]
    private let rotationValues = [0.0, .pi, 2 * .pi]

    var body: some View {
        GeometryReader(content: self.render)
    }

    func render(geometry: GeometryProxy) -> some View {
        let dimension = min(geometry.size.width, geometry.size.height)
        let timingFunctions = [timingFunction, timingFunction]

        return KeyframeAnimationController<MyRing>(beginTime: 0,
                                                   duration: self.duration,
                                                   timingFunctions: timingFunctions,
                                                   keyTimes: self.keyTimes) {
                                                    MyRing(scaleValues: self.scaleValues,
                                                           rotationValues: self.rotationValues,
                                                           nextKeyframe: $0)
        }
        .frame(width: dimension, height: dimension, alignment: .center)
    }

    struct BallClipRotate_Previews: PreviewProvider {
        static var previews: some View {
            BallClipRotate()
        }
    }
}
