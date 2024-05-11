//
//  LineScalePulseOut.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/18/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

public struct LineScalePulseOut: View {
    private let referenceTime = DispatchTime.now()
    private let beginTimes = [0.4, 0.2, 0, 0.2, 0.4]
    private let duration = 1.0
    private let timingFunction = TimingFunction.timingCurve(c0x: 0.85, c0y: 0.25, c1x: 0.37, c1y: 0.85)
    private let keyTimes = [0, 0.5, 1]
    private let values: [CGFloat] = [1, 0.4, 1]

    public var body: some View {
        GeometryReader(content: render)
    }

    public init() { }

    func render(geometry: GeometryProxy) -> some View {
        let dimension = min(geometry.size.width, geometry.size.height)
        let spacing = dimension / 9
        let timingFunctions = Array(repeating: timingFunction, count: keyTimes.count - 1)

        return HStack(spacing: spacing) {
            ForEach(0..<5, id: \.self) { index in
                KeyframeAnimationController(beginTime: beginTimes[index],
                                            duration: duration,
                                            timingFunctions: timingFunctions,
                                            keyTimes: keyTimes,
                                            referenceTime: referenceTime) {
                    RoundedRectangle(cornerRadius: spacing / 2)
                        .scaleEffect(x: 1, y: self.values[$0])
                }
            }.frame(height: dimension)
        }.frame(width: geometry.size.width, height: geometry.size.height)
    }
}

struct LineScalePulseOut_Previews: PreviewProvider {
    static var previews: some View {
        LineScalePulseOut()
    }
}
