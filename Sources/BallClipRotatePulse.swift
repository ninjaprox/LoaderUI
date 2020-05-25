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
    public var body: some View {
        GeometryReader(content: self.render)
    }

    public init() { }
    
    func render(geometry: GeometryProxy) -> some View {
        let dimension = min(geometry.size.width, geometry.size.height)
        
        return ZStack {
            renderMyRing()
            renderBall()
        }.frame(width: dimension, height: dimension, alignment: .center)
    }
    
    func renderMyRing() -> some View {
        let duration = 1.0
        let timingFunction = TimingFunction.timingCurve(c0x: 0.09, c0y: 0.57, c1x: 0.49, c1y: 0.9)
        let keyTimes = [0, 0.5, 1]
        let scaleValues: [CGFloat] = [1, 0.6, 1]
        let rotationValues = [0.0, .pi, 2 * .pi]
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
        let duration = 1.0
        let timingFunction = TimingFunction.timingCurve(c0x: 0.09, c0y: 0.57, c1x: 0.49, c1y: 0.9)
        let keyTimes = [0, 0.3, 1]
        let values: [CGFloat] = [1, 0.3, 1]
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
        BallClipRotatePulse()
    }
}
