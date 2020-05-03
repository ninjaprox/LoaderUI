//
//  KeyFrameAnimation.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/3/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

struct ProgressEffect: AnimatableModifier {
    typealias OnCompleteHandler = (Int) -> Void

    private let keyFrame: Int
    private var animatableProgress: Double
    private let onComplete: OnCompleteHandler

    init(progress: Double, onComplete: @escaping OnCompleteHandler) {
        self.keyFrame = Int(progress)
        self.animatableProgress = progress
        self.onComplete = onComplete
        print("init \(progress)")
    }

    var animatableData: Double {
        get {
            print("get \(animatableProgress)")

            return animatableProgress
        }
        set {
            print("before set \(animatableProgress) \(newValue)")
            animatableProgress = newValue
            print("set \(animatableProgress)")

            if Int(animatableProgress) == keyFrame {
                onComplete(keyFrame)
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

typealias ProgressUpdater = (Bool) -> Void
typealias AnimationUpdater = (Double) -> Void
typealias Updater = (Bool, @escaping ProgressUpdater, @escaping AnimationUpdater) -> Void


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
        let updater: Updater = { skipBeginTime, progressUpdater, animationUpdater in
            DispatchQueue.main.async {
                let delay = isFirstKeyFrame && !skipBeginTime ? beginTime : 0

                withAnimation(Animation.linear(duration: durations[keyFrameIndex]).delay(delay)) {
                    progressUpdater(isLastKeyFrame)
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
