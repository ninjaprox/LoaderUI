//
//  LineScaleParty.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/12/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

public struct LineScaleParty: View {
    private let referenceTime = DispatchTime.now()
    private let beginTimes = [0.77, 0.29, 0.28, 0.74]
    private let durations = [1.26, 0.43, 1.01, 0.73]
    private let timingFunction = TimingFunction.timingCurve(c0x: 0.25, c0y: 0.1, c1x: 0.25, c1y: 1)
    private let keyTimes = [0, 0.5, 1]
    private let values: [CGFloat] = [1, 0.5, 1]

    public var body: some View {
        GeometryReader(content: render)
    }

    public init() { }

    func render(geometry: GeometryProxy) -> some View {
        let dimension = min(geometry.size.width, geometry.size.height)
        let spacing = dimension / 7
        let timingFunctions = Array(repeating: timingFunction, count: keyTimes.count - 1)

        return HStack(spacing: spacing) {
            ForEach(0..<4, id: \.self) { index in
                KeyframeAnimationController(beginTime: beginTimes[index],
                                            duration: durations[index],
                                            timingFunctions: timingFunctions,
                                            keyTimes: keyTimes,
                                            referenceTime: referenceTime) {
                    RoundedRectangle(cornerRadius: spacing / 2).scaleEffect(values[$0])
                }
            }.frame(height: dimension)
        }.frame(width: geometry.size.width, height: geometry.size.height)
    }
}

struct LineScaleParty_Previews: PreviewProvider {
    static var previews: some View {
        LineScaleParty()
    }
}
