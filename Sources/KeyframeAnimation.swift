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
    typealias Element = (Int, Animation?, UInt)

    private let beginTime: Double
    private let duration: Double
    private let timingFunctions: [TimingFunction]
    private let keyTimes: [Double]
    private let closedLoop: Bool
    private let durations: [Double]
    private let referenceTime: DispatchTime
    private let animations: [Animation?]
    private var keyframe: Int = 0
    private var isRepeating = false
    private var repeatCount: UInt = 0

    var currentDeadline: DispatchTime {
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
        print("init KeyframeIterator")

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

        print("durations: \(durations)")

        self.durations = [0] + durations
        animations = [nil] + zip(durations, timingFunctions).map { duration, timingFunction in
            timingFunction.animation(duration: duration)
        }
    }

    func next() -> Element? {
        let isFirst = keyframe == 1
        let isLast = keyframe == (keyTimes.count - 1)
        let delay = isFirst && !isRepeating ? beginTime : 0
        let nextKeyframe = isLast ? (closedLoop ? 1 : 0) : keyframe + 1
        let animation = delay == 0 ? animations[nextKeyframe] : animations[nextKeyframe]?.delay(delay)

        if isLast {
            isRepeating = true
            repeatCount += 1
        }
        keyframe = nextKeyframe

        return (nextKeyframe, animation, repeatCount)
    }
}

struct KeyframeAnimationController<T: View>: View {
    typealias Content = (Int) -> T

    @State private var keyframe: Int = 0
    @State private var animation: Animation?
    private let referenceTime: DispatchTime
    private let beginTime: Double
    private let duration: Double
    private let timingFunctions: [TimingFunction]
    private let keyTimes: [Double]
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
        print("init KeyframeAnimationController")
        self.beginTime = beginTime
        self.duration = duration
        self.timingFunctions = timingFunctions
        self.keyTimes = keyTimes
        self.content = content
        self.referenceTime = referenceTime
        keyframeIterator = KeyframeIterator(beginTime: beginTime,
                                            duration: duration,
                                            timingFunctions: timingFunctions,
                                            keyTimes: keyTimes,
                                            closedLoop: closedLoop,
                                            referenceTime: referenceTime)

    }

    private func nextKeyframe() {
        let workItem = DispatchWorkItem {
            let currentDeadline = keyframeIterator.currentDeadline

            guard let data = self.keyframeIterator.next() else {
                return
            }

            let (keyframe, animation, _) = data

            print("[\(Date().timeIntervalSinceReferenceDate)] - late \(currentDeadline.distance(to: .now())) next keyframe: \(keyframe)")
            self.animation = animation
            self.keyframe = keyframe
//            DispatchQueue.main.async {
                self.nextKeyframe()
//            }
        }
        print("[\(Date().timeIntervalSinceReferenceDate)] dispatch \(keyframeIterator.currentDeadline), diff \(referenceTime.distance(to: keyframeIterator.currentDeadline))")
        DispatchQueue.main.asyncAfter(deadline: keyframeIterator.currentDeadline,
                                      execute: workItem)
    }
}
