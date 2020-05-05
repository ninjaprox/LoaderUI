//
//  BallPulse.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/3/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

fileprivate struct MyCircle: View {
    @State private var scale: CGFloat = 1
    private let values: [Double]
    private let nextKeyFrame: (KeyframeAnimationController<Self>.Animator?) -> Void

    init(values: [Double],
         nextKeyframe: @escaping (KeyframeAnimationController<Self>.Animator?) -> Void) {
        self.values = values
        self.nextKeyFrame = nextKeyframe

        print("Init MyCircle")
    }

    var body: some View {
        Circle()
            .scaleEffect(scale)
            .onAppear() {
                self.nextKeyFrame { keyframe, _ in
                    self.scale = CGFloat(self.values[keyframe])
                }
        }
    }
}

struct BallPulse: View {
    private let beginTimes = [0.12, 0.24, 0.36]
    private let duration = 0.75
    private let timingFunction = TimingFunction.timingCurve(c0x: 0.2, c0y: 0.68, c1x: 0.18, c1y: 1.08)
    private let keyTimes = [0, 0.3, 1]
    private let values = [1, 0.3, 1]

    var body: some View {
        GeometryReader(content: self.render)
    }

    func render(geometry: GeometryProxy) -> some View {
        let width = geometry.size.width
        let spacing = width / 32
        let timingFunctions = [timingFunction, timingFunction]

        return HStack(spacing: spacing) {
            ForEach(0..<3, id: \.self) {
                KeyframeAnimationController<MyCircle>(beginTime: self.beginTimes[$0],
                                                      duration: self.duration,
                                                      timingFunctions: timingFunctions,
                                                      keyTimes: self.keyTimes) { nextKeyframe in
                                                        MyCircle(values: self.values,
                                                                 nextKeyframe: nextKeyframe)
                }
            }
        }
    }
}

struct BallPulse_Previews: PreviewProvider {
    static var previews: some View {
        BallPulse()
    }
}
