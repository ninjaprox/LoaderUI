//
//  BallGridPulse.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/3/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

public struct BallGridPulse: View {
    private let beginTimes = [0.11, 0.42, 0.0, 0.65, 0.48, 0.2, 0.63, 0.95, 0.62] // Normalized from [-0.06, 0.25, -0.17, 0.48, 0.31, 0.03, 0.46, 0.78, 0.45]
    private let durations = [0.72, 1.02, 1.28, 1.42, 1.45, 1.18, 0.87, 1.45, 1.06]
    private let timingFunction = TimingFunction.timingCurve(c0x: 0.25, c0y: 0.1, c1x: 0.25, c1y: 1)
    private let keyTimes = [0, 0.5, 1]
    private let scaleValues: [CGFloat] = [1, 0.5, 1]
    private let opacityValues = [1, 0.7, 1]
    
    public var body: some View {
        GeometryReader(content: self.render)
    }

    public init() { }
    
    func render(geometry: GeometryProxy) -> some View {
        let dimension = min(geometry.size.width, geometry.size.height)
        let spacing = dimension / 32
        let timingFunctions = Array(repeating: timingFunction, count: keyTimes.count - 1)
        
        return VStack(spacing: spacing) {
            ForEach(0..<3, id: \.self) { row in
                HStack(spacing: spacing) {
                    ForEach(0..<3, id: \.self) { col in
                        KeyframeAnimationController(beginTime: self.beginTimes[3 * row + col],
                                                    duration: self.durations[3 * row + col],
                                                    timingFunctions: timingFunctions,
                                                    keyTimes: self.keyTimes) {
                                                        Circle()
                                                            .scaleEffect(self.scaleValues[$0])
                                                            .opacity(self.opacityValues[$0])
                        }
                    }
                }
            }
        }
        .frame(width: dimension, height: dimension, alignment: .center)
    }
}

struct BallGridPulse_Previews: PreviewProvider {
    static var previews: some View {
        BallGridPulse()
    }
}
