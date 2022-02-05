//
//  BallClipRotate.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/10/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

fileprivate struct BallClip: Shape {
    
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

public struct BallClipRotate: View {
    private let duration: Double
    private let timingFunction = TimingFunction.linear
    private let keyTimes = [0, 0.5, 1]
    private let scaleValues: [CGFloat] = [1, 0.6, 1]
    private let rotationValues = [0.0, .pi, 2 * .pi]
    
    public var body: some View {
        GeometryReader(content: self.render)
    }

    public init(duration: Double) {
        if duration == 0.0 {
            self.duration = 0.75
        }else {
            self.duration = duration
        }
    }
    
    func render(geometry: GeometryProxy) -> some View {
        let dimension = min(geometry.size.width, geometry.size.height)
        let timingFunctions = Array(repeating: timingFunction, count: keyTimes.count - 1)
        
        return KeyframeAnimationController(beginTime: 0,
                                           duration: duration,
                                           timingFunctions: timingFunctions,
                                           keyTimes: keyTimes) {
                                            BallClip()
                                                .scaleEffect(self.scaleValues[$0])
                                                .rotationEffect(Angle(radians: self.rotationValues[$0]))
        }
        .frame(width: dimension, height: dimension, alignment: .center)
    }
    
    struct BallClipRotate_Previews: PreviewProvider {
        static var previews: some View {
            BallClipRotate(duration: 0.75)
        }
    }
}
