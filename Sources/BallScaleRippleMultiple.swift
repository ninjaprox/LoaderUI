//
//  BallScaleRippleMultiple.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/18/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

public struct BallScaleRippleMultiple: View {
    private let referenceTime = DispatchTime.now()
    private let beginTimes = [0, 0.2, 0.4]
    private let duration = 1.25
    private let timingFunction = TimingFunction.timingCurve(c0x: 0.21, c0y: 0.53, c1x: 0.56, c1y: 0.8)
    private let keyTimes = [0, 0.7, 1]
    private let scaleValues: [CGFloat] = [0.1, 1, 1]
    private let opacityValues = [1, 0.7, 0]

    public var body: some View {
        GeometryReader(content: render)
    }

    public init() { }

    func render(geometry: GeometryProxy) -> some View {
        let dimension = min(geometry.size.width, geometry.size.height)
        let timingFunctions = Array(repeating: timingFunction, count: keyTimes.count - 1)

        return ZStack {
            ForEach(0..<3, id: \.self) { index in
                KeyframeAnimationController(beginTime: beginTimes[index],
                                            duration: duration,
                                            timingFunctions: timingFunctions,
                                            keyTimes: keyTimes,
                                            closedLoop: false,
                                            referenceTime: referenceTime) {
                    Ring()
                        .scaleEffect(scaleValues[$0])
                        .opacity(opacityValues[$0])
                }
            }.frame(width: dimension, height: dimension)
        }.frame(width: geometry.size.width, height: geometry.size.height)
    }
}

struct BallScaleRippleMultiple_Previews: PreviewProvider {
    static var previews: some View {
        BallScaleRippleMultiple()
    }
}
