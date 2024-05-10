//
//  KeyFrameAnimation.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/3/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

enum TimingFunction {
    case timingCurve(c0x: Double, c0y: Double, c1x: Double, c1y: Double)
    case linear
    case easeInOut

    func animation(duration: Double) -> Animation {
        switch self {
        case let .timingCurve(c0x, c0y, c1x, c1y):
            return .timingCurve(c0x, c0y, c1x, c1y, duration: duration)
        case .linear:
            return .linear(duration: duration)
        case .easeInOut:
            return .easeInOut(duration: duration)
        }
    }
}

class KeyframeIterator: IteratorProtocol {
    typealias Element = (Int, Animation?)

    private let beginTime: Double
    private let duration: Double
    private let timingFunctions: [TimingFunction]
    private let keyTimes: [Double]
    private let closedLoop: Bool
    private let durations: [Double]
    private let referenceTime: DispatchTime
    private let animations: [Animation?]
    private var keyframe: Int = 0
    private var repeatCount: UInt = 0

    var nextKeyframeDeadline: DispatchTime {
        var deadline = referenceTime
            .advanced(by: .milliseconds(Int(beginTime * Double(MSEC_PER_SEC))))
            .advanced(by: .milliseconds(Int(duration * Double(MSEC_PER_SEC)) * Int(repeatCount)))

        for i in 0...keyframe {
            deadline = deadline.advanced(by: .milliseconds(Int(durations[i] * Double(MSEC_PER_SEC))))
        }

        return deadline
    }

    init(beginTime: Double,
         duration: Double,
         timingFunctions: [TimingFunction],
         keyTimes: [Double],
         closedLoop: Bool,
         referenceTime: DispatchTime
    ) {
        self.beginTime = beginTime
        self.duration = duration
        self.timingFunctions = timingFunctions
        self.keyTimes = keyTimes
        self.closedLoop = closedLoop
        self.referenceTime = referenceTime

        assert(keyTimes.count - timingFunctions.count == 1)

        let keyPercents = zip(keyTimes[0..<keyTimes.count - 1], keyTimes[1...])
            .map { $1 - $0 }
        let durations = keyPercents.map { duration * $0 }

        self.durations = [0] + durations
        animations = [nil] + zip(durations, timingFunctions).map { duration, timingFunction in
            timingFunction.animation(duration: duration)
        }
    }

    func next() -> Element? {
        let isFirst = keyframe == 1
        let isLast = keyframe == (keyTimes.count - 1)
        let delay = (isFirst && repeatCount == 0) ? beginTime : 0
        let nextKeyframe = isLast ? (closedLoop ? 1 : 0) : keyframe + 1
        let animation = delay == 0 ? animations[nextKeyframe] : animations[nextKeyframe]?.delay(delay)

        if isLast {
            repeatCount += 1
        }
        keyframe = nextKeyframe

        return (nextKeyframe, animation)
    }
}

struct KeyframeAnimationController<T: View>: View {
    typealias Content = (Int) -> T

    @State private var keyframe: Int = 0
    @State private var animation: Animation?
    private let keyframeIterator: KeyframeIterator
    private let content: Content

    var body: some View {
        content(keyframe)
            .animation(animation, value: keyframe)
            .onAppear {
                self.nextKeyframe()
            }
    }

    init(beginTime: Double,
         duration: Double,
         timingFunctions: [TimingFunction],
         keyTimes: [Double],
         closedLoop: Bool = true,
         referenceTime: DispatchTime = DispatchTime.now(),
         content: @escaping Content) {
        self.content = content
        keyframeIterator = KeyframeIterator(beginTime: beginTime,
                                            duration: duration,
                                            timingFunctions: timingFunctions,
                                            keyTimes: keyTimes,
                                            closedLoop: closedLoop,
                                            referenceTime: referenceTime)

    }

    private func nextKeyframe() {
        let nextKeyframeWorkItem = DispatchWorkItem {
            guard let (keyframe, animation) = self.keyframeIterator.next() else {
                return
            }

            self.animation = animation
            self.keyframe = keyframe
            self.nextKeyframe()
        }

        DispatchQueue.main.asyncAfter(deadline: keyframeIterator.nextKeyframeDeadline,
                                      execute: nextKeyframeWorkItem)
    }
}
