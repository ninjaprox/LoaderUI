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

public struct BallClipRotateMultiple: View {
    private var duration: Double
    private var defaultDuration = 1.0
    private var keyTimes: Array<Double> = []
    private var rotationValues: Array<Double> = []
    private var scaleValues: Array<CGFloat> = [1, 0.95, 0.90, 0.85, 0.80, 0.75, 0.70, 0.65, 0.60, 0.65, 0.70, 0.75, 0.80, 0.85, 0.90, 0.95, 1]
    public var body: some View {
        GeometryReader(content: self.render)
    }

    public init(duration: Double) {
        rotationValues.append(-2 * -.pi)
        if duration <= defaultDuration {
            self.duration = defaultDuration
            rotationValues.append(-.pi)
            keyTimes.append(contentsOf: [1, 0.5])
            
        }else {
            self.duration = duration
        }
        if duration > defaultDuration {
            let topNum = Int(duration.rounded() + 1)
            for num in 1...topNum {
//                print("ballClipRotateMultiple.num = \(num)")
                let finalValue = 1/Double(num)
                keyTimes.append(finalValue)
            }
            for num in 1...topNum-1 {
                let finalValue = 1/Double(num)
                rotationValues.append(.pi * -finalValue)
            }
        }
//        print("ballClipRotateMultiple.scaleValues = \(scaleValues)")
        rotationValues.append(0)
        rotationValues.reverse()
//        print("ballClipRotateMultiple.rotationValues = \(rotationValues)")
        keyTimes.append(0)
        keyTimes.reverse()
//        print("ballClipRotateMultiple.keyTimes = \(keyTimes)")
    }

    func render(geometry: GeometryProxy) -> some View {
        let dimension = min(geometry.size.width, geometry.size.height)

        return ZStack {
            renderMyBigRing()
            renderMySmallRing()
        }.frame(width: dimension, height: dimension, alignment: .center)
    }

    func renderMyBigRing() -> some View {
        let duration = duration
        let timingFunction = TimingFunction.easeInOut
        let keyTimes = keyTimes
        let scaleValues: [CGFloat] = scaleValues
        let rotationValues = rotationValues
        let timingFunctions = Array(repeating: timingFunction, count: keyTimes.count - 1)

        return KeyframeAnimationController(beginTime: 0,
                                           duration: duration,
                                           timingFunctions: timingFunctions,
                                           keyTimes: keyTimes) {
                                            VerticalRing()
                                                .scaleEffect(scaleValues[$0])
                                                .rotationEffect(Angle(radians: rotationValues[$0]))
        }
    }

    func renderMySmallRing() -> some View {
        let duration = duration
        let timingFunction = TimingFunction.easeInOut
        let keyTimes = keyTimes
        let scaleValues: [CGFloat] = scaleValues
        let rotationValues = rotationValues
        let timingFunctions = Array(repeating: timingFunction, count: keyTimes.count - 1)

        return KeyframeAnimationController(beginTime: 0,
                                           duration: duration,
                                           timingFunctions: timingFunctions,
                                           keyTimes: keyTimes) {
                                            HorizontalRing()
                                                .scale(0.5)
                                                .scaleEffect(scaleValues[$0])
                                                .rotationEffect(Angle(radians: rotationValues[$0]))
        }
    }
}

struct BallClipRotateMultiple_Previews: PreviewProvider {
    static var previews: some View {
        BallClipRotateMultiple(duration: 1.0)
    }
}
