//
//  LineScalePulseOutRapid.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/18/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

public struct LineScalePulseOutRapid: View {
    private let beginTimes = [0.5, 0.25, 0, 0.25, 0.5]
    private let duration = 0.9
    private let timingFunction = TimingFunction.timingCurve(c0x: 0.11, c0y: 0.49, c1x: 0.38, c1y: 0.78)
    private let keyTimes = [0, 0.8, 0.9]
    private let values: [CGFloat] = [1, 0.3, 1]

    public var body: some View {
        GeometryReader(content: self.render)
    }

    public init() { }

    func render(geometry: GeometryProxy) -> some View {
        let dimension = min(geometry.size.width, geometry.size.height)
        let spacing = dimension / 9
        let timingFunctions = Array(repeating: timingFunction, count: keyTimes.count - 1)

        return HStack(spacing: spacing) {
            ForEach(0..<5, id: \.self) { index in
                KeyframeAnimationController(beginTime: self.beginTimes[index],
                                            duration: self.duration,
                                            timingFunctions: timingFunctions,
                                            keyTimes: self.keyTimes) {
                                                RoundedRectangle(cornerRadius: spacing / 2)
                                                    .scaleEffect(x: 1, y: self.values[$0])
                }
            }
        }
        .frame(width: dimension, height: dimension, alignment: .center)
    }
}

struct LineScalePulseOutRapid_Previews: PreviewProvider {
    static var previews: some View {
        LineScalePulseOutRapid()
    }
}
