//
//  BallBeat.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/6/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

fileprivate struct MyCircle: View, KeyframeAnimatable {
    @State private var scale: CGFloat = 1
    @State private var opacity: Double = 1
    let scaleValues: [Double]
    let opacityValues: [Double]
    let nextKeyframe: (KeyframeAnimationController<Self>.Animator?) -> Void

    var body: some View {
        Circle()
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear() {
                self.nextKeyframe { keyframe, _ in
                    self.scale = CGFloat(self.scaleValues[keyframe])
                    self.opacity = self.opacityValues[keyframe]
                }
        }
    }
}

struct BallBeat: View {
    private let beginTimes = [0.35, 0, 0.35]
    private let duration = 0.7
    private let timingFunction = TimingFunction.linear
    private let keyTimes = [0, 0.5, 1]
    private let scaleValues = [1, 0.75, 1]
    private let opacityValues = [1, 0.2, 1]

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
                                                      keyTimes: self.keyTimes) {
                                                        MyCircle(scaleValues: self.scaleValues,
                                                                 opacityValues: self.opacityValues,
                                                                 nextKeyframe: $0)
                }
            }
        }
    }
}

struct BallBeat_Previews: PreviewProvider {
    static var previews: some View {
        BallBeat()
    }
}
