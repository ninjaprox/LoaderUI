//
//  BallBeat.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/6/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

public struct BallBeat: View {
    private let referenceTime = DispatchTime.now()
    private let beginTimes = [0.35, 0, 0.35]
    private let duration = 0.7
    private let timingFunction = TimingFunction.linear
    private let keyTimes = [0, 0.5, 1]
    private let scaleValues: [CGFloat] = [1, 0.75, 1]
    private let opacityValues = [1, 0.2, 1]

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
                    Circle()
                        .scaleEffect(scaleValues[$0])
                        .opacity(opacityValues[$0])
                }
            }
        }.frame(width: geometry.size.width, height: geometry.size.height)
    }
}

struct BallBeat_Previews: PreviewProvider {
    static var previews: some View {
        BallBeat()
    }
}
