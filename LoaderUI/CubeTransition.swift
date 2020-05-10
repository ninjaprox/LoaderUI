//
//  CubeTransition.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/10/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

fileprivate struct MyRectangle: View, KeyframeAnimatable {
    @State private var scale: CGFloat = 1
    @State private var rotation = 0.0
    @State private var translation: UnitPoint = .zero
    let scaleValues: [Double]
    let rotationValues: [Double]
    let translationValues: [UnitPoint]
    let nextKeyframe: (KeyframeAnimationController<Self>.Animator?) -> Void

    var body: some View {
        GeometryReader(content: self.render)
    }

    func render(geometry: GeometryProxy) -> some View {
        let geometryDimension = min(geometry.size.width, geometry.size.height)
        let dimension = geometryDimension / 3

        return Rectangle()
            .scaleEffect(scale)
            .rotationEffect(Angle(radians: rotation))
            .frame(width: dimension, height: dimension)
            .position(CGPoint(x: dimension / 2, y: dimension / 2))
            .offset(x: translation.x * (geometryDimension - dimension),
                    y: translation.y * (geometryDimension - dimension))
            .onAppear() {
                self.nextKeyframe { keyframe, _ in
                    self.scale = CGFloat(self.scaleValues[keyframe])
                    self.rotation = self.rotationValues[keyframe]
                    self.translation = self.translationValues[keyframe]
                }
        }

    }
}

struct CubeTransition: View {
    private let beginTimes = [0.8, 0.0]
    private let duration = 1.6
    private let timingFunction = TimingFunction.easeInOut
    private let keyTimes = [0, 0.25, 0.5, 0.75, 1]
    private let scaleValues = [1, 0.5, 1, 0.5, 1]
    private let rotationValues = [0.0, -.pi / 2, -.pi, -1.5 * .pi, -2 * .pi]
    private let translationValues: [UnitPoint] = [.zero, .init(x: 1, y: 0), .init(x: 1, y: 1), .init(x: 0, y: 1), .zero]

    var body: some View {
        GeometryReader(content: self.render)
    }

    func render(geometry: GeometryProxy) -> some View {
        let dimension = min(geometry.size.width, geometry.size.height)
        let timingFunctions = [timingFunction, timingFunction, timingFunction, timingFunction]

        return
            ZStack {
                ForEach(0..<2, id: \.self) { i in
                    KeyframeAnimationController<MyRectangle>(beginTime: self.beginTimes[i],
                                                             duration: self.duration,
                                                             timingFunctions: timingFunctions,
                                                             keyTimes: self.keyTimes) {
                                                                MyRectangle(scaleValues: self.scaleValues,
                                                                            rotationValues: self.rotationValues,
                                                                            translationValues: self.translationValues,
                                                                            nextKeyframe: $0)
                    }
                }
            }
            .frame(width: dimension, height: dimension, alignment: .center)
    }
}

struct CubeTransition_Previews: PreviewProvider {
    static var previews: some View {
        CubeTransition()
    }
}
