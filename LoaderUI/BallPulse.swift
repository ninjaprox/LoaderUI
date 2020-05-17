//
//  BallPulse.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/3/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

struct BallPulse: View {
    private let beginTimes = [0.12, 0.24, 0.36]
    private let duration = 0.75
    private let timingFunction = TimingFunction.timingCurve(c0x: 0.2, c0y: 0.68, c1x: 0.18, c1y: 1.08)
    private let keyTimes = [0, 0.3, 1]
    private let values: [CGFloat] = [1, 0.3, 1]
    
    var body: some View {
        GeometryReader(content: self.render)
    }
    
    func render(geometry: GeometryProxy) -> some View {
        let dimension = min(geometry.size.width, geometry.size.height)
        let spacing = dimension / 32
        let timingFunctions = [timingFunction, timingFunction]
        
        return HStack(spacing: spacing) {
            ForEach(0..<3, id: \.self) {
                KeyframeAnimationController(beginTime: self.beginTimes[$0],
                                            duration: self.duration,
                                            timingFunctions: timingFunctions,
                                            keyTimes: self.keyTimes) {
                                                Circle().scaleEffect(self.values[$0])
                }
            }
        }
        .frame(width: dimension, height: dimension, alignment: .center)
    }
}

struct BallPulse_Previews: PreviewProvider {
    static var previews: some View {
        BallPulse()
    }
}
