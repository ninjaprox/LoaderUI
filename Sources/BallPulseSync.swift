//
//  BallPulseSync.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/17/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

public struct BallPulseSync: View {
    private let referenceTime = DispatchTime.now()
    private let beginTimes = [0.07, 0.14, 0.21]
    private let duration = 0.6
    private let timingFunction = TimingFunction.easeInOut
    private let keyTimes = [0, 0.33, 0.66, 1]
    private let directionValues: [CGFloat] = [0, 1, -1, 0]

    public var body: some View {
        GeometryReader(content: render)
    }

    public init() { }

    func render(geometry: GeometryProxy) -> some View {
        let dimension = min(geometry.size.width, geometry.size.height)
        let objectDimension = 10 * dimension / 32
        let spacing = dimension / 32
        let timingFunctions = Array(repeating: timingFunction, count: keyTimes.count - 1)
        let values = directionValues.map {
            $0 * (objectDimension - spacing) / 2
        }

        return HStack(spacing: spacing) {
            ForEach(0..<3, id: \.self) {
                KeyframeAnimationController(beginTime: beginTimes[$0],
                                            duration: duration,
                                            timingFunctions: timingFunctions,
                                            keyTimes: keyTimes,
                                            referenceTime: referenceTime) {
                    Circle()
                        .frame(width: objectDimension, height: objectDimension)
                        .offset(x: 0, y: values[$0])
                }
            }
        }.frame(width: geometry.size.width, height: geometry.size.height)
    }
}

struct BallPulseSync_Previews: PreviewProvider {
    static var previews: some View {
        BallPulseSync()
    }
}
