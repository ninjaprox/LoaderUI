//
//  BallGridPulse.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/3/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

fileprivate struct MyCircle: View {
    @State private var scale: CGFloat = 1
    @State private var opacity: Double = 1
    let scaleValues: [Double]
    let opacityValues: [Double]
    let nextKeyFrame: (KeyframeAnimationController<Self>.Animator?) -> Void
    
    var body: some View {
        Circle()
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear() {
                self.nextKeyFrame { keyframe, _ in
                    self.scale = CGFloat(self.scaleValues[keyframe])
                    self.opacity = self.opacityValues[keyframe]
                }
        }
    }
}

struct BallGridPulse: View {
    private let beginTimes = [0.11, 0.42, 0.0, 0.65, 0.48, 0.2, 0.63, 0.95, 0.62] // Normalized from [-0.06, 0.25, -0.17, 0.48, 0.31, 0.03, 0.46, 0.78, 0.45]
    private let durations = [0.72, 1.02, 1.28, 1.42, 1.45, 1.18, 0.87, 1.45, 1.06]
    private let timingFunction = TimingFunction.timingCurve(c0x: 0.25, c0y: 0.1, c1x: 0.25, c1y: 1)
    private let keyTimes = [0, 0.5, 1]
    private let scaleValues = [1, 0.5, 1]
    private let opacityValues = [1, 0.7, 1]
    
    var body: some View {
        GeometryReader(content: self.render)
    }
    
    func render(geometry: GeometryProxy) -> some View {
        let width = geometry.size.width
        let spacing = width / 32
        let timingFunctions = [timingFunction, timingFunction]
        
        return VStack(spacing: spacing) {
            ForEach(0..<3, id: \.self) { row in
                HStack(spacing: spacing) {
                    ForEach(0..<3, id: \.self) { col in
                        KeyframeAnimationController<MyCircle>(beginTime: self.beginTimes[3 * row + col],
                                                              duration: self.durations[3 * row + col],
                                                              timingFunctions: timingFunctions,
                                                              keyTimes: self.keyTimes) {
                                                                MyCircle(scaleValues: self.scaleValues,
                                                                         opacityValues: self.opacityValues,
                                                                         nextKeyFrame: $0)
                        }
                    }
                }
            }
        }
    }
}

struct BallGridPulse_Previews: PreviewProvider {
    static var previews: some View {
        BallGridPulse()
    }
}
