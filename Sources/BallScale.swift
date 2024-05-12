//
//  BallScale.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/12/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

public struct BallScale: View {
    private let duration = 1.0
    private let timingFunction = TimingFunction.easeInOut
    private let keyTimes = [0.0, 1.0]
    private let scaleValues: [CGFloat] = [0.0, 1.0]
    private let opacityValues = [1.0, 0.0]

    public var body: some View {
        GeometryReader(content: render)
    }

    public init() { }

    func render(geometry: GeometryProxy) -> some View {
        let timingFunctions = Array(repeating: timingFunction, count: keyTimes.count - 1)

        return KeyframeAnimationController(beginTime: 0,
                                           duration: duration,
                                           timingFunctions: timingFunctions,
                                           keyTimes: keyTimes,
                                           closedLoop: false) {
            Circle()
                .scaleEffect(scaleValues[$0])
                .opacity(opacityValues[$0])
        }.frame(width: geometry.size.width, height: geometry.size.height)
    }
}

struct BallScale_Previews: PreviewProvider {
    static var previews: some View {
        BallScale()
    }
}
