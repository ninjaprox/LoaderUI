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

public struct BallClipRotatePulse: View {
    private var duration: Double
    private var defaultDuration = 1.0
    private var ringKeyTimes: Array<Double> = []
    private var ringScaleValues: Array<CGFloat> = [1, 0.95, 0.90, 0.85, 0.80, 0.75, 0.70, 0.65, 0.60, 0.65, 0.70, 0.75, 0.80, 0.85, 0.90, 0.95, 1]
    private var ringRotationValues: Array<Double> = []
    private var ballKeyTimes: Array<Double> = []
    private var ballScaleValues: Array<CGFloat> = [1, 0.95, 0.90, 0.85, 0.80, 0.75, 0.70, 0.65, 0.60, 0.55, 0.50, 0.45, 0.40, 0.35, 0.30, 0.35, 0.40, 0.45, 0.50, 0.55, 0.60, 0.65, 0.70, 0.75, 0.80, 0.85, 0.90, 0.95, 1]
    public var body: some View {
        GeometryReader(content: self.render)
    }

    public init(duration: Double) {
        ringRotationValues.append(-2 * -.pi)
        if duration <= defaultDuration {
            self.duration = defaultDuration
            ringRotationValues.append(-.pi)
            ringKeyTimes.append(contentsOf: [1, 0.5])
            ballKeyTimes.append(contentsOf: [1, 0.5])
        } else {
            self.duration = duration
        }
        if duration > defaultDuration {
//            ringKeyTimes = [0, 0.5*duration, duration]
//            ballKeyTimes = [0, 0.3*duration, duration]
            let topNum = Int(duration.rounded() + 1)
            for num in 1...topNum {
                print("BallClipRotatePulse.num = \(num)")
                ballKeyTimes.append(0.3 * Double(num))
                ringKeyTimes.append(0.5 * Double(num))
            }
            for num in 1...topNum-1 {
                let finalValue = 1/Double(num)
                ringRotationValues.append(.pi * -finalValue)
            }
        }
        ringRotationValues.append(0)
        ringRotationValues.reverse()
//        print("BallClipRotatePulse.ringRotationValues = \(ringRotationValues)")
        ringKeyTimes.reverse()
        ringKeyTimes.append(0)
        ringKeyTimes.reverse()
//        print("BallClipRotatePulse.ringKeyTimes = \(ringKeyTimes)")
        ballKeyTimes.reverse()
        ballKeyTimes.append(0)
        ballKeyTimes.reverse()
//        print("BallClipRotatePulse.ballKeyTimes = \(ballKeyTimes)")
    }
    
    func render(geometry: GeometryProxy) -> some View {
        let dimension = min(geometry.size.width, geometry.size.height)
        
        return ZStack {
            renderMyRing()
            renderBall()
        }.frame(width: dimension, height: dimension, alignment: .center)
    }
    
    func renderMyRing() -> some View {
        let duration = duration
        let timingFunction = TimingFunction.timingCurve(c0x: 0.09, c0y: 0.57, c1x: 0.49, c1y: 0.9)
        let keyTimes = ringKeyTimes
        let scaleValues: [CGFloat] = ringScaleValues
        let rotationValues = ringRotationValues
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
    
    func renderBall() -> some View {
        let duration = duration
        let timingFunction = TimingFunction.timingCurve(c0x: 0.09, c0y: 0.57, c1x: 0.49, c1y: 0.9)
        let keyTimes = ballKeyTimes
        let values: [CGFloat] = ballScaleValues
        let timingFunctions = Array(repeating: timingFunction, count: keyTimes.count - 1)
        
        return KeyframeAnimationController(beginTime: 0,
                                           duration: duration,
                                           timingFunctions: timingFunctions,
                                           keyTimes: keyTimes) {
                                            Circle()
                                                .scale(0.5)
                                                .scaleEffect(values[$0])
        }
    }
}

struct BallClipRotatePulse_Previews: PreviewProvider {
    static var previews: some View {
        BallClipRotatePulse(duration: 1.0)
    }
}
