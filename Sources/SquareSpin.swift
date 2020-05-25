//
//  SquareSpin.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/6/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

fileprivate struct FlipEffect: AnimatableModifier {
    typealias Value = (Double, Double, Double, Double)

    var value:  Value

    init(values: [Value], keyframe: Int) {
        self.value = values[keyframe]
    }

    var animatableData: Value {
        get { value }
        set { value = newValue }
    }

    func body(content: Content) -> some View {
        content.rotation3DEffect(Angle(radians: value.0), axis: (x: CGFloat(value.1), y: CGFloat(value.2), z: CGFloat(value.3)))
    }
}

public struct SquareSpin: View {
    private let duration = 3.0
    private let timingFunction = TimingFunction.timingCurve(c0x: 0.09, c0y: 0.57, c1x: 0.49, c1y: 0.9)
    private let keyTimes = [0, 0.25, 0.5, 0.75, 1]
    private let values = [(0.0, 0.0, 0.0, 0.0), (Double.pi, 1.0, 0.0, 0.0), (Double.pi, 0.0, 0.0, 1.0), (Double.pi, 0.0, 1.0, 0.0), (0.0, 0.0, 0.0, 0.0)] // The last one should rotate to left on y axis

    public var body: some View {
        GeometryReader(content: self.render)
    }

    public init() { }

    func render(geometry: GeometryProxy) -> some View {
        let dimension = min(geometry.size.width, geometry.size.height)
        let timingFunctions = Array(repeating: timingFunction, count: keyTimes.count - 1)

        return KeyframeAnimationController(beginTime: 0,
                                           duration: duration,
                                           timingFunctions: timingFunctions,
                                           keyTimes: keyTimes) {
                                            Rectangle().modifier(FlipEffect(values: self.values, keyframe: $0))
        }
        .frame(width: dimension, height: dimension, alignment: .center)
    }
}

struct SquareSpin_Previews: PreviewProvider {
    static var previews: some View {
        SquareSpin()
    }
}
