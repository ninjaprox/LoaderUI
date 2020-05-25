//
//  TriangleSkewSpin.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/18/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

fileprivate struct Triangle: Shape {
    
    func path(in rect: CGRect) -> Path {
        let dimension = min(rect.size.width, rect.size.height)
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: 3 * dimension / 4))
        path.addLine(to: CGPoint(x: dimension / 2, y: dimension / 4))
        path.addLine(to: CGPoint(x: dimension, y: 3 * dimension / 4))
        path.closeSubpath()
        
        return path
    }
}

public struct TriangleSkewSpin: View {
    private let duration = 3.0
    private let timingFunction = TimingFunction.timingCurve(c0x: 0.09, c0y: 0.57, c1x: 0.49, c1y: 0.9)
    private let keyTimes = [0, 0.25, 0.5, 0.75, 1]
    private let values = [(0.0, 0.0, 0.0, 0.0), (Double.pi, 1.0, 0.0, 0.0), (Double.pi, 0.0, 0.0, 1.0), (Double.pi, 0.0, 1.0, 0.0), (0.0, 0.0, 0.0, 0.0)] // The last one should rotate to left on y axis
    
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
                                            Triangle().rotation3DEffect(Angle(radians: self.values[$0].0),
                                                                        axis: (x: CGFloat(self.values[$0].1),
                                                                               y: CGFloat(self.values[$0].2),
                                                                               z: CGFloat(self.values[$0].3)))
        }
        .frame(width: dimension, height: dimension, alignment: .center)
    }
}

struct TriangleSkewSpin_Previews: PreviewProvider {
    static var previews: some View {
        TriangleSkewSpin()
    }
}
