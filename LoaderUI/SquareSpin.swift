//
//  SquareSpin.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/6/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

fileprivate struct MySquare: View, KeyframeAnimatable {
    @State private var value: (Double, Double, Double, Double) = (0, 0, 0, 0)
    let values: [(Double, Double, Double, Double)]
    let nextKeyframe: (KeyframeAnimationController<Self>.Animator?) -> Void

    var body: some View {
        Rectangle()
            .rotation3DEffect(Angle(radians: value.0), axis: (x: CGFloat(value.1), y: CGFloat(value.2), z: CGFloat(value.3)))
            .onAppear() {
                self.nextKeyframe { keyframe, _ in
                    self.value = self.values[keyframe]
                }

        }
    }
}

struct SquareSpin: View {
    private let duration = 3.0
    private let timingFunction = TimingFunction.timingCurve(c0x: 0.09, c0y: 0.57, c1x: 0.49, c1y: 0.9)
    private let keyTimes = [0, 0.25, 0.5, 0.75, 1]
    private let values = [(0.0, 0.0, 0.0, 0.0), (Double.pi, 1.0, 0.0, 0.0), (Double.pi, 0.0, 0.0, 1.0), (Double.pi, 0.0, 1.0, 0.0), (0.0, 0.0, 0.0, 0.0)] // The last one should rotate to left on y axis

    var body: some View {
        GeometryReader(content: self.render)
    }

    func render(geometry: GeometryProxy) -> some View {
        let dimension = min(geometry.size.width, geometry.size.height)
        let timingFunctions = [timingFunction, timingFunction, timingFunction, timingFunction]

        return KeyframeAnimationController<MySquare>(beginTime: 0,
                                                     duration: self.duration,
                                                     timingFunctions: timingFunctions,
                                                     keyTimes: self.keyTimes) {
                                                        MySquare(values: self.values,
                                                                 nextKeyframe: $0)
        }
        .frame(width: dimension, height: dimension, alignment: .center)
    }
}

struct SquareSpin_Previews: PreviewProvider {
    static var previews: some View {
        SquareSpin()
    }
}
