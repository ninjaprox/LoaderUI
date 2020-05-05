//
//  KeyFrameAnimation.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/3/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

struct KeyframeAnimation: AnimatableModifier {
    typealias OnCompleteHandler = (Int) -> Void

    private let keyframe: Int
    private var progressiveKeyframe: Double
    private let onComplete: OnCompleteHandler

    init(keyframe: Double, onComplete: @escaping OnCompleteHandler) {
        self.keyframe = Int(keyframe)
        self.progressiveKeyframe = keyframe
        self.onComplete = onComplete
        print("init \(keyframe)")
    }

    var animatableData: Double {
        get {
            print("get \(progressiveKeyframe)")

            return progressiveKeyframe
        }
        set {
            print("before set \(progressiveKeyframe) \(newValue)")
            progressiveKeyframe = newValue
            print("set \(progressiveKeyframe)")

            if Int(progressiveKeyframe) == keyframe {
                onComplete(keyframe)
            }
        }
    }

    func body(content: Content) -> some View {
        content
    }
}

enum TimingFunction {
    case timingCurve(c0x: Double, c0y: Double, c1x: Double, c1y: Double)

    func animation(duration: Double) -> Animation {
        switch self {
        case let .timingCurve(c0x, c0y, c1x, c1y):
            return .timingCurve(c0x, c0y, c1x, c1y, duration: duration)
        }
    }
}

typealias KeyframeUpdater = (Bool) -> Void
typealias AnimationUpdater = (Double) -> Void
typealias Updater = (Bool, @escaping KeyframeUpdater, @escaping AnimationUpdater) -> Void


func withChainedAnimation(beginTime: Double,
                          duration: Double,
                          timingFunctions: [TimingFunction],
                          keyTimes: [Double],
                          values: [Double]) -> [Updater] {

    assert(keyTimes.count - timingFunctions.count == 1)

    let keyPercents = zip(keyTimes[0..<keyTimes.count - 1], keyTimes[1...])
        .map { $1 - $0 }
    let durations = keyPercents.map { duration * $0 } + [0]
    let animations = timingFunctions.enumerated().map { index, timingFunction in
        timingFunction.animation(duration: durations[index])
    }

    return (0..<keyTimes.count).map { keyFrameIndex in
        let isFirstKeyFrame = keyFrameIndex == 0
        let isLastKeyFrame = keyFrameIndex == keyTimes.count - 1
        let updater: Updater = { skipBeginTime, keyframeUpdater, animationUpdater in
            DispatchQueue.main.async {
                let delay = isFirstKeyFrame && !skipBeginTime ? beginTime : 0

                withAnimation(Animation.linear(duration: durations[keyFrameIndex]).delay(delay)) {
                    keyframeUpdater(isLastKeyFrame)
                }

                let value = isLastKeyFrame ? values[0] : values[keyFrameIndex + 1]

                if isLastKeyFrame {
                    animationUpdater(value)
                } else {
                    withAnimation(animations[keyFrameIndex].delay(delay)) {
                        animationUpdater(value)
                    }
                }
            }
        }

        return updater
    }
}

class KeyframeIterator: IteratorProtocol {
    typealias Element = (Int, Animation, Animation?, Bool)

    private let beginTime: Double
    private let duration: Double
    private let timingFunctions: [TimingFunction]
    private let keyTimes: [Double]
    private let durations: [Double]
    private let animations: [Animation]
    private var keyframe: Int = 0
    private var skipBeginTime = false

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
        let durations = keyPercents.map { duration * $0 } + [0]

        self.durations = durations
        animations = zip(durations, timingFunctions).map { duration, timingFunction in
            timingFunction.animation(duration: duration)
        }
    }

    func next() -> Element? {
        let isFirst = keyframe == 0
        let isLast = keyframe == keyTimes.count - 1
        let delay = isFirst && !skipBeginTime ? beginTime : 0
        let keyframeTracker = Animation.linear(duration: durations[keyframe]).delay(delay)
        let animation = isLast ? nil : animations[keyframe].delay(delay)
        let element: Element = (keyframe + 1, keyframeTracker, animation, isLast)

        if isLast {
            skipBeginTime = true
        }
        keyframe = keyframe + 1

        return element
    }
}

struct KeyframeAnimationController<T: View>: View {
    typealias Animator = (Int, Bool) -> Void

    @State private var keyframe: Double = 0
    private let beginTime: Double
    private let duration: Double
    private let timingFunctions: [TimingFunction]
    private let keyTimes: [Double]
    private let animator: Animator?
    private let keyframeIterator: KeyframeIterator
    private var content: () -> T

    var body: some View {
        content().modifier(KeyframeAnimation(keyframe: self.keyframe, onComplete: handleComplete))
    }

    init(beginTime: Double,
         duration: Double,
         timingFunctions: [TimingFunction],
         keyTimes: [Double],
         animator: Animator?,
         @ViewBuilder _ content: @escaping () -> T) {
        self.beginTime = beginTime
        self.duration = duration
        self.timingFunctions = timingFunctions
        self.keyTimes = keyTimes
        self.animator = animator
        keyframeIterator = KeyframeIterator(beginTime: beginTime,
                                            duration: duration,
                                            timingFunctions: timingFunctions,
                                            keyTimes: keyTimes)
        self.content = content

        print("Init KeyframeAnimationController")
//        self.content = content().modifier(KeyframeAnimation(keyframe: self.keyframe, onComplete: handleComplete))
    }

    func onAppear(perform action: (() -> Void)? = nil) -> some View {
        print("onAppear")

        nextKeyframe()
        action?()

        return self
    }

    private func handleComplete(_ keyframe: Int) {
        print("handleComplete \(keyframe)")
        nextKeyframe()
    }

    private func nextKeyframe() {
        DispatchQueue.main.async {
            guard let data = self.keyframeIterator.next() else {
                return
            }

            let (keyframe, keyframeTracker, animation, isLast) = data

            print("keyFrame: \(keyframe)")

            withAnimation(keyframeTracker) { }
            withAnimation(animation) {
                self.animator?(keyframe, isLast)
            }
        }
    }
}

protocol KeyframeAnimatable {

}

//extension KeyframeAnimatable where Self: View {
extension View {

    func keyframeAnimation(beginTime: Double,
                           duration: Double,
                           timingFunctions: [TimingFunction],
                           keyTimes: [Double],
                           animator: KeyframeAnimationController<Self>.Animator?) -> KeyframeAnimationController<Self> {
        KeyframeAnimationController(beginTime: beginTime,
                                    duration: duration,
                                    timingFunctions: timingFunctions,
                                    keyTimes: keyTimes,
                                    animator: animator) {
                                        self
        }
    }
}

//extension View: KeyframeAnimatable {
//
//}
