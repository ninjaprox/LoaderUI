//
//  BallPulseRise.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/10/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

fileprivate struct MyCircle: View {
    @State private var scale: CGFloat = 1
    @State private var translation: CGFloat = 0
    let scaleValues: [Double]
    let translationValues: [Double]
    let scaleNextKeyframe: ((KeyframeAnimationController<Self>.Animator?) -> Void)?
    let translationNextKeyframe: (KeyframeAnimationController<Self>.Animator?) -> Void

    var body: some View {
        Circle()
            .scaleEffect(scale)
            .offset(x: 0, y: translation)
            .onAppear() {
                self.scaleNextKeyframe? { keyframe, _ in
                    print("scale", keyframe, self.scaleValues[keyframe])
                    self.scale = CGFloat(self.scaleValues[keyframe])
                }
                self.translationNextKeyframe { keyframe, _ in
                    print("translation", keyframe, self.translationValues[keyframe])
                    self.translation = CGFloat(self.translationValues[keyframe])
                }
        }
    }
}

struct BallPulseRise: View {
    @State private var scaleNextKeyframe: KeyframeAnimationController<EmptyView>.NextKeyframe?
    @State private var translationNextKeyframe: KeyframeAnimationController.NextKeyframe = { _ in }
    private let duration = 1.0
    private let timingFunction = TimingFunction.timingCurve(c0x: 0.15, c0y: 0.46, c1x: 0.9, c1y: 0.6)
    private let scaleKeyTimes = [0, 0.5, 1]
    private let translationKeyTimes = [0, 0.25, 0.75, 1]
    private let scaleValues = [0.4, 1.1, 0.75]
    private let translationValues = [0.0, 5.0, -5.0, 0.0]

    var body: some View {
        GeometryReader(content: self.render)
    }

    func render(geometry: GeometryProxy) -> some View {
        let dimension = min(geometry.size.width, geometry.size.height)
        let scaleTimingFunctions = [timingFunction, timingFunction]
        let translationTimingFunctions = [timingFunction, timingFunction, timingFunction]

        return ZStack {
            KeyframeAnimationController<EmptyView>(beginTime: 0,
                                                   duration: duration,
                                                   timingFunctions: translationTimingFunctions,
                                                   keyTimes: translationKeyTimes) {
                                                    self.translationNextKeyframe = $0

                                                    return EmptyView()
            }
            KeyframeAnimationController<EmptyView>(beginTime: 0,
                                                   duration: duration,
                                                   timingFunctions: scaleTimingFunctions,
                                                   keyTimes: scaleKeyTimes) {
                                                    if self.scaleNextKeyframe == nil {
                                                        self.scaleNextKeyframe = $0
                                                    }

                                                    return EmptyView()
            }
            
            MyCircle(scaleValues: scaleValues,
                     translationValues: translationKeyTimes,
                     scaleNextKeyframe: scaleNextKeyframe,
                     translationNextKeyframe: translationNextKeyframe)
        }

            //        return KeyframeAnimationController<MyCircle>(beginTime: 0,
            //                                                     duration: duration,
            //                                                     timingFunctions: translationTimingFunctions,
            //                                                     keyTimes: translationKeyTimes) { translationNextKeyframe in
            //                                                        MyCircle(scaleValues: self.scaleValues,
            //                                                                 translationValues: self.translationValues,
            //                                                                 scaleNextKeyframe: { _ in },
            //                                                                 translationNextKeyframe: translationNextKeyframe)
            //        }

            //        return KeyframeAnimationController<MyCircle>(beginTime: 0,
            //                                                     duration: self.duration,
            //                                                     timingFunctions: scaleTimingFunctions,
            //                                                     keyTimes: self.scaleKeyTimes) { scaleNextKeyframe in
            //                                                        MyCircle(scaleValues: self.scaleValues,
            //                                                                 translationValues: self.translationValues,
            //                                                                 scaleNextKeyframe: scaleNextKeyframe,
            //                                                                 translationNextKeyframe: { _ in })
            //        }

            //        return KeyframeAnimationController<KeyframeAnimationController<MyCircle>>(beginTime: 0,
            //                                                                                  duration: duration,
            //                                                                                  timingFunctions: translationTimingFunctions,
            //                                                                                  keyTimes: translationKeyTimes) { translationNextKeyframe in
            //                                                                                    KeyframeAnimationController<MyCircle>(beginTime: 0,
            //                                                                                                                          duration: self.duration,
            //                                                                                                                          timingFunctions: scaleTimingFunctions,
            //                                                                                                                          keyTimes: self.scaleKeyTimes) { scaleNextKeyframe in
            //                                                                                                                            MyCircle(scaleValues: self.scaleValues,
            //                                                                                                                                     translationValues: self.translationValues,
            //                                                                                                                                     scaleNextKeyframe: scaleNextKeyframe,
            //                                                                                                                                     translationNextKeyframe: translationNextKeyframe)
            //                                                                                    }
            //
            //
            //        }
            .frame(width: dimension, height: dimension, alignment: .center)
    }
}

struct BallPulseRise_Previews: PreviewProvider {
    static var previews: some View {
        BallPulseRise()
    }
}
