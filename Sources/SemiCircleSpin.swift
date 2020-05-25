//
//  SemiCircleSpin.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/23/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

fileprivate struct SemiCircle: Shape {
    func path(in rect: CGRect) -> Path {
        let dimension = min(rect.size.width, rect.size.height)
        var path = Path()

        path.addArc(center: CGPoint(x: dimension / 2, y: dimension / 2),
                    radius: dimension / 2,
                    startAngle: Angle(radians: 7 * .pi / 6),
                    endAngle: Angle(radians: 11 * .pi / 6),
                    clockwise: false)

        return path
    }
}

public struct SemiCircleSpin: View {
    private let duration = 0.6
    private let timingFunction = TimingFunction.linear
    private let keyTimes = [0, 1.0]
    private let value = [0, 2 * Double.pi]

    public var body: some View {
        GeometryReader(content: render)
    }

    public init() { }

    func render(geometry: GeometryProxy) -> some View {
        let dimension = min(geometry.size.width, geometry.size.height)
        let timingFunctions = Array(repeating: timingFunction, count: keyTimes.count - 1)

        return KeyframeAnimationController(beginTime: 0,
                                           duration: duration,
                                           timingFunctions: timingFunctions,
                                           keyTimes: keyTimes) {
                                            SemiCircle()
                                                .rotation(Angle(radians: self.value[$0]))
        }
        .frame(width: dimension, height: dimension, alignment: .center)
    }
}

struct SemiCircleSpin_Previews: PreviewProvider {
    static var previews: some View {
        SemiCircleSpin()
    }
}
