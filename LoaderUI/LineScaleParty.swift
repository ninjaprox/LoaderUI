//
//  LineScaleParty.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/12/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

fileprivate struct MyLine: View, KeyframeAnimatable {
    @State private var scale: CGFloat = 1
    let values: [Double]
    let nextKeyframe: (KeyframeAnimationController<Self>.Animator?) -> Void

    var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: geometry.size.width / 2)
                .scaleEffect(self.scale)
                .onAppear() {
                    self.nextKeyframe { keyframe, _ in
                        self.scale = CGFloat(self.values[keyframe])
                    }
            }
        }
    }
}

struct LineScaleParty: View {
    private let beginTimes = [0.77, 0.29, 0.28, 0.74]
    private let durations = [1.26, 0.43, 1.01, 0.73]
    private let timingFunction = TimingFunction.timingCurve(c0x: 0.25, c0y: 0.1, c1x: 0.25, c1y: 1)
    private let keyTimes = [0, 0.5, 1]
    private let values = [1, 0.5, 1]

    var body: some View {
        GeometryReader(content: self.render)
    }

    func render(geometry: GeometryProxy) -> some View {
        let dimension = min(geometry.size.width, geometry.size.height)
        let spacing = dimension / 7
        let timingFunctions = [timingFunction, timingFunction]

        return HStack(spacing: spacing) {
            ForEach(0..<4, id: \.self) { index in
                KeyframeAnimationController<MyLine>(beginTime: self.beginTimes[index],
                                                    duration: self.durations[index],
                                                    timingFunctions: timingFunctions,
                                                    keyTimes: self.keyTimes) {
                                                        MyLine(values: self.values,
                                                               nextKeyframe: $0)
                }
            }
        }
        .frame(width: dimension, height: dimension, alignment: .center)
    }
}

struct LineScaleParty_Previews: PreviewProvider {
    static var previews: some View {
        LineScaleParty()
    }
}
