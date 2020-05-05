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

struct KeyframeAnimationController<T: View>: View {
    @State private var keyframe: Int = 0
    private var content: T
    private var beginTime: Double
    private var duration: Double
    private var timingFunctions: [TimingFunction]
    private var keyTimes: [Double]
    
    var body: some View {
        content
    }
    
    init(beginTime: Double,
         duration: Double,
         timingFunctions: [TimingFunction],
         keyTimes: [Double],
         @ViewBuilder _ content: () -> T) {
        self.beginTime = beginTime
        self.duration = duration
        self.timingFunctions = timingFunctions
        self.keyTimes = keyTimes
        self.content = content()
        self.content = self.content.modifier(KeyframeAnimation(keyframe: 0, onComplete: handleComplete)) as! T // A trick to be able to use `handleComplete`
    }
    
    private func handleComplete(_ keyframe: Int) {
        print("handleComplete \(keyframe)")
    }
}

protocol KeyframeAnimatable {
    
}

extension KeyframeAnimatable where Self: View {
    
    func keyframeAnimation(beginTime: Double,
                           duration: Double,
                           timingFunctions: [TimingFunction],
                           keyTimes: [Double]) -> KeyframeAnimationController<Self> {
        KeyframeAnimationController(beginTime: beginTime,
                                    duration: duration,
                                    timingFunctions: timingFunctions,
                                    keyTimes: keyTimes) {
                                        self
        }
    }
}

extension Circle: KeyframeAnimatable {
    
}
