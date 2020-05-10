//
//  BallZigZag.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/10/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

fileprivate struct MyCircle: View, KeyframeAnimatable {
    @State private var translation: UnitPoint = .zero
    let dimension: CGFloat
    let values: [UnitPoint]
    let nextKeyframe: (KeyframeAnimationController<Self>.Animator?) -> Void

    var body: some View {
        GeometryReader(content: self.render)
    }

    func render(geometry: GeometryProxy) -> some View {
        let geometryDimension = min(geometry.size.width, geometry.size.height)

        return Circle()
            .frame(width: dimension, height: dimension)
            .offset(x: translation.x * (geometryDimension - dimension) / 2,
                    y: translation.y * (geometryDimension - dimension) / 2)
            .onAppear() {
                self.nextKeyframe { keyframe, _ in
                    self.translation = self.values[keyframe]
                }
        }
    }
}

struct BallZigZag: View {
    private let duration = 0.7
    private let timingFunction = TimingFunction.linear
    private let keyTimes = [0, 0.33, 0.66, 1]
    private let values: [[UnitPoint]] = [[.zero, .init(x: -1, y: -1), .init(x: 1, y: -1), .zero],
                                         [.zero, .init(x: 1, y: 1), .init(x: -1, y: 1), .zero]]

    var body: some View {
        GeometryReader(content: self.render)
    }

    func render(geometry: GeometryProxy) -> some View {
        let dimension = min(geometry.size.width, geometry.size.height)
        let circleDimension: CGFloat = dimension / 3
        let timingFunctions = [timingFunction, timingFunction, timingFunction]

        return
            ZStack {
                ForEach(0..<2, id: \.self) { index in
                    KeyframeAnimationController<MyCircle>(beginTime: 0,
                                                          duration: self.duration,
                                                          timingFunctions: timingFunctions,
                                                          keyTimes: self.keyTimes) {
                                                            MyCircle(dimension: circleDimension,
                                                                     values: self.values[index],
                                                                     nextKeyframe: $0)
                    }
                }
            }
            .frame(width: dimension, height: dimension, alignment: .center)
    }
}

struct BallZigZag_Previews: PreviewProvider {
    static var previews: some View {
        BallZigZag()
    }
}
