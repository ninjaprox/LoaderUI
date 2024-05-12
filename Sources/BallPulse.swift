//
//  BallPulse.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/3/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

public struct BallPulse: View {
    private let referenceTime = DispatchTime.now()
    private let beginTimes = [0.12, 0.24, 0.36]
    private let duration = 0.75
    private let timingFunction = TimingFunction.timingCurve(c0x: 0.2, c0y: 0.68, c1x: 0.18, c1y: 1.08)
    private let keyTimes = [0, 0.3, 1]
    private let values: [CGFloat] = [1, 0.3, 1]

    public var body: some View {
        GeometryReader(content: render)
    }

    public init() { }

    func render(geometry: GeometryProxy) -> some View {
        let dimension = min(geometry.size.width, geometry.size.height)
        let spacing = dimension / 32
        let timingFunctions = Array(repeating: timingFunction, count: keyTimes.count - 1)

        return HStack(spacing: spacing) {
            ForEach(0..<3, id: \.self) {
                KeyframeAnimationController(beginTime: beginTimes[$0],
                                            duration: duration,
                                            timingFunctions: timingFunctions,
                                            keyTimes: keyTimes,
                                            referenceTime: referenceTime) {
                    Circle().scaleEffect(values[$0])
                }
            }
        }.frame(width: geometry.size.width, height: geometry.size.height)
    }
}

struct BallPulse_Previews: PreviewProvider {
    static var previews: some View {
        BallPulse()
    }
}
