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
    @State private var progress: Double = 0
    @State private var isRepeating = false
    let beginTime: Double
    let duration: Double
    let timingFunctions: [TimingFunction]
    let keyTimes: [Double]
    let values: [Double]
    let updaters: [Updater]

    init(
        beginTime: Double,
        duration: Double,
        timingFunctions: [TimingFunction],
        keyTimes: [Double],
        values: [Double]) {
        self.beginTime = beginTime
        self.duration = duration
        self.timingFunctions = timingFunctions
        self.keyTimes = keyTimes
        self.values = values

        updaters = withChainedAnimation(beginTime: beginTime,
                                        duration: duration,
                                        timingFunctions: timingFunctions,
                                        keyTimes: keyTimes,
                                        values: values)

        print("Init MyCircle")
    }

    var body: some View {
        let progressUpdater: ProgressUpdater = { isLastKeyFrame in
            self.progress = isLastKeyFrame ? 0 : self.progress + 1
            if isLastKeyFrame {
                self.isRepeating = true
            }
        }
        let animationUpdater: AnimationUpdater = { value in
            self.scale = CGFloat(value)
        }


        return Circle()
            .modifier(ProgressEffect(progress: progress) { keyFrame in
                print("onComplete")
                let updater = self.updaters[Int(self.progress)]

                updater(self.isRepeating, progressUpdater, animationUpdater)
            })
            .scaleEffect(scale)
            //            .modifier(progressEffect)
            .onAppear {
                let updater = self.updaters[Int(self.progress)]

                updater(self.isRepeating, progressUpdater, animationUpdater)
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
            MyCircle(beginTime: beginTimes[0], duration: duration, timingFunctions: timingFunctions, keyTimes: keyTimes, values: values)
            MyCircle(beginTime: beginTimes[1], duration: duration, timingFunctions: timingFunctions, keyTimes: keyTimes, values: values)
            MyCircle(beginTime: beginTimes[2], duration: duration, timingFunctions: timingFunctions, keyTimes: keyTimes, values: values)
        }
    }
}

struct BallPulse_Previews: PreviewProvider {
    static var previews: some View {
        BallPulse()
    }
}
