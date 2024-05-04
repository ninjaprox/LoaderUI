//
//  KeyFrameAnimation.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/3/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

struct KeyframeAnimation: Shape {
    typealias OnCompleteHandler = (Int) -> Void

    private let keyframe: Int
    private let onComplete: OnCompleteHandler

    init(keyframe: Int, onComplete: @escaping OnCompleteHandler) {
        self.keyframe = keyframe
        self.onComplete = onComplete
        animatableData = Double(keyframe)
    }

    var animatableData: Double {
        didSet {
            complete()
        }
    }

    func complete() {
        guard Int(animatableData) == keyframe else { return }

        DispatchQueue.main.async {
            self.onComplete(keyframe)
        }
    }

    func path(in rect: CGRect) -> Path {
        Path()
    }
}

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
    typealias Element = (Int, Animation?, Bool)

    private let beginTime: Double
    private let duration: Double
    private let timingFunctions: [TimingFunction]
    private let keyTimes: [Double]
    private let durations: [Double]
    private let animations: [Animation?]
    private var keyframe: Int = 0
    private var isRepeating = false

    var keyframeTracker: Animation? {
        let isFirst = keyframe == 1
        let delay = isFirst && !isRepeating ? beginTime : 0
        let duration =  durations[keyframe]

        return delay == 0 ? Animation.linear(duration: duration) : Animation.linear(duration: duration).delay(delay)
    }

    init(beginTime: Double,
         duration: Double,
         timingFunctions: [TimingFunction],
         keyTimes: [Double]
    ) {
        self.beginTime = beginTime
        self.duration = duration
        self.timingFunctions = timingFunctions
        self.keyTimes = keyTimes

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
        let delay = isFirst && !isRepeating ? beginTime : 0
        let nextKeyframe = isLast ? 0 : keyframe + 1
        let animation = delay == 0 ? animations[nextKeyframe] : animations[nextKeyframe]?.delay(delay)
        let element: Element = (nextKeyframe, animation, isLast)

        if isLast {
            isRepeating = true
        }
        keyframe = nextKeyframe

        return element
    }
}

struct KeyframeAnimationController<T: View>: View {
    typealias Content = (Int) -> T

    @State private var keyframe: Int = 0 // -1 used to trigger the animation and start at keyframe 0
    @State private var animation: Animation?
    private let beginTime: Double
    private let duration: Double
    private let timingFunctions: [TimingFunction]
    private let keyTimes: [Double]
    private let keyframeIterator: KeyframeIterator
    private var content: Content

    var body: some View {
        ZStack {
            KeyframeAnimation(keyframe: keyframe, onComplete: handleComplete)
                .animation(keyframeIterator.keyframeTracker, value: keyframe)
            content(max(0, keyframe))
                .animation(animation, value: keyframe)
        }
        .onAppear {
            self.nextKeyframe()
        }
    }

    init(beginTime: Double,
         duration: Double,
         timingFunctions: [TimingFunction],
         keyTimes: [Double],
         content: @escaping Content) {
        self.beginTime = beginTime
        self.duration = duration
        self.timingFunctions = timingFunctions
        self.keyTimes = keyTimes
        self.content = content
        keyframeIterator = KeyframeIterator(beginTime: beginTime,
                                            duration: duration,
                                            timingFunctions: timingFunctions,
                                            keyTimes: keyTimes)

    }

    private func handleComplete(_ keyframe: Int) {
        nextKeyframe()
    }

    private func nextKeyframe() {
        guard let data = self.keyframeIterator.next() else {
            return
        }

        let (keyframe, animation, _) = data

        self.animation = animation
        self.keyframe = keyframe
    }
}
