//
//  ContentView.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 4/19/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

struct OrbitEffect: GeometryEffect {
    let initialAngle = CGFloat.random(in: 0 ..< 2 * .pi)
    
    var percent: CGFloat = 0
    let radius: CGFloat
    
    var animatableData: CGFloat {
        get { return percent }
        set { percent = newValue }
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        let angle = 2 * .pi * percent + initialAngle
        let pt = CGPoint(
            x: cos(angle) * radius,
            y: sin(angle) * radius)
        return ProjectionTransform(CGAffineTransform(translationX: pt.x, y: pt.y))
    }
}

struct ScaleEffect: GeometryEffect {
    var scale: CGFloat

    var animatableData: CGFloat {
        get { scale }
        set {
            scale = newValue
            print("ScaleEffect: \(scale)")
        }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        let transform = CGAffineTransform(translationX: -size.width / 2, y: -size.height / 2)
            .concatenating(.init(scaleX: scale, y: scale))
            .concatenating(.init(translationX: size.width / 2, y: size.height / 2))

        return ProjectionTransform(transform)
    }
}

func makeOrbitEffect(diameter: CGFloat) -> some GeometryEffect {
    return OrbitEffect(
        percent: 1,
        radius: diameter / 2.0)
}

struct RectangleModifier: ViewModifier {
    typealias Body = Rectangle

    func body(content: _ViewModifier_Content<RectangleModifier>) -> Rectangle {
        return Rectangle()
    }
}



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
typealias Updater = (@escaping ProgressUpdater, @escaping AnimationUpdater) -> Void


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
        let updater: Updater = { progressUpdater, animationUpdater in
            DispatchQueue.main.async {
                withAnimation(Animation.linear(duration: durations[keyFrameIndex]).delay(isFirstKeyFrame ? beginTime : 0)) {
                    progressUpdater(isLastKeyFrame)
                }

                let value = isLastKeyFrame ? values[0] : values[keyFrameIndex + 1]

                if isLastKeyFrame {
                    animationUpdater(value)
                } else {
                    withAnimation(animations[keyFrameIndex].delay(isFirstKeyFrame ? beginTime : 0)) {
                        animationUpdater(value)
                    }
                }
            }
        }

        return updater
    }
}


struct MyCircle: View {
    @State private var scale: CGFloat = 1
    @State private var progress: Double = 0
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
        return Circle()
            .modifier(ProgressEffect(progress: progress) { keyFrame in
                print("onComplete")
                let updater = self.updaters[Int(self.progress)]

                updater({ isLastKeyFrame in
                    self.progress = isLastKeyFrame ? 0 : self.progress + 1
                }) { value in
                    print("value: \(value)")
                    self.scale = CGFloat(value)
                }
            })
            .scaleEffect(scale)
            //            .modifier(progressEffect)
            .onAppear {
                let updater = self.updaters[Int(self.progress)]

                updater({ _ in
                    self.progress += 1
                }) { value in
                    print("value: \(value)")
                    self.scale = CGFloat(value)
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
            MyCircle(beginTime: beginTimes[0], duration: duration, timingFunctions: timingFunctions, keyTimes: keyTimes, values: values)
            MyCircle(beginTime: beginTimes[1], duration: duration, timingFunctions: timingFunctions, keyTimes: keyTimes, values: values)
            MyCircle(beginTime: beginTimes[2], duration: duration, timingFunctions: timingFunctions, keyTimes: keyTimes, values: values)
        }
    }
}

struct SimpleRectangle: View {
    @State private var scaleFactor: CGFloat = 1

    var body: some View {
        Rectangle()
            .fill(Color.red)
            .scaleEffect(scaleFactor)
            .onAppear {
                self.scaleFactor = 2
        }
        .animation(Animation.easeInOut(duration: 1).delay(1))
        .frame(width: 100, height: 100, alignment: .center)
    }
}


struct ContentView: View {
    var body: some View {
        BallPulse().frame(width: 100, height: 100, alignment: .center)
        //        SimpleRectangle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
