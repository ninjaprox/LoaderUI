//
//  BallGridPulse.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/3/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

fileprivate struct MyCircle: View {
    @State private var keyframe: Double = 0
    @State private var isRepeating = false
    @State private var scale: CGFloat = 1
    @State private var opacity: Double = 1
    let beginTime: Double
    let duration: Double
    let timingFunctions: [TimingFunction]
    let keyTimes: [Double]
    let scaleValues: [Double]
    let opacityValues: [Double]
    let scaleUpdaters: [Updater]
    let opacityUpdaters: [Updater]

    init(
        beginTime: Double,
        duration: Double,
        timingFunctions: [TimingFunction],
        keyTimes: [Double],
        scaleValues: [Double],
        opacityValues: [Double]) {
        self.beginTime = beginTime
        self.duration = duration
        self.timingFunctions = timingFunctions
        self.keyTimes = keyTimes
        self.scaleValues = scaleValues
        self.opacityValues = opacityValues

        scaleUpdaters = withChainedAnimation(beginTime: beginTime,
                                             duration: duration,
                                             timingFunctions: timingFunctions,
                                             keyTimes: keyTimes,
                                             values: scaleValues)
        opacityUpdaters = withChainedAnimation(beginTime: beginTime,
                                               duration: duration,
                                               timingFunctions: timingFunctions,
                                               keyTimes: keyTimes,
                                               values: opacityValues)
    }

    var body: some View {
        let keyframeUpdater: KeyframeUpdater = { isLastKeyFrame in
            self.keyframe = isLastKeyFrame ? 0 : self.keyframe + 1
            if isLastKeyFrame {
                self.isRepeating = true
            }
        }
        let emptyKeyframeUpdater: KeyframeUpdater = { _ in
            // Does nothing
        }
        let scaleAnimationUpdater: AnimationUpdater = { value in
            self.scale = CGFloat(value)
        }
        let opacityAnimationUpdater: AnimationUpdater = { value in
            self.opacity = value
        }

        return Circle()
            .modifier(KeyframeAnimation(keyframe: keyframe) { keyFrame in
                print("onComplete")
                let updater = self.scaleUpdaters[Int(self.keyframe)]

                updater(self.isRepeating, keyframeUpdater, scaleAnimationUpdater)
            })
            .modifier(KeyframeAnimation(keyframe: keyframe) { keyFrame in
                print("onComplete")
                let updater = self.scaleUpdaters[Int(self.keyframe)]

                updater(self.isRepeating, emptyKeyframeUpdater, opacityAnimationUpdater)
            })
            .scaleEffect(scale)
            .opacity(opacity)
            //            .modifier(progressEffect)
            .onAppear {
                let scaleUpdater = self.scaleUpdaters[Int(self.keyframe)]
                let opacityUpdater = self.opacityUpdaters[Int(self.keyframe)]

                scaleUpdater(self.isRepeating, keyframeUpdater, scaleAnimationUpdater)
                opacityUpdater(self.isRepeating, emptyKeyframeUpdater, opacityAnimationUpdater)
        }
    }
}

struct BallGridPulse: View {
    private let beginTimes = [0.11, 0.42, 0.0, 0.65, 0.48, 0.2, 0.63, 0.95, 0.62] // Normalized from [-0.06, 0.25, -0.17, 0.48, 0.31, 0.03, 0.46, 0.78, 0.45]
    private let durations = [0.72, 1.02, 1.28, 1.42, 1.45, 1.18, 0.87, 1.45, 1.06]
    private let timingFunction = TimingFunction.timingCurve(c0x: 0.25, c0y: 0.1, c1x: 0.25, c1y: 1)
    private let keyTimes = [0, 0.5, 1]
    private let scaleValues = [1, 0.5, 1]
    private let opacityValues = [1, 0.7, 1]

    var body: some View {
        GeometryReader(content: self.render)
    }

    func render(geometry: GeometryProxy) -> some View {
        let width = geometry.size.width
        let spacing = width / 32
        let timingFunctions = [timingFunction, timingFunction]

        return VStack(spacing: spacing) {
            ForEach(0..<3, id: \.self) { row in
                HStack(spacing: spacing) {
                    ForEach(0..<3, id: \.self) { col in
                        MyCircle(beginTime: self.beginTimes[3 * row + col],
                                 duration: self.durations[3 * row + col],
                                 timingFunctions: timingFunctions,
                                 keyTimes: self.keyTimes,
                                 scaleValues: self.scaleValues,
                                 opacityValues: self.opacityValues)
                    }
                }
            }
        }
    }
}

struct BallGridPulse_Previews: PreviewProvider {
    static var previews: some View {
        BallGridPulse()
    }
}
