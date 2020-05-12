//
//  BallScale.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/12/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

fileprivate struct MyCircle: View, KeyframeAnimatable {
    @State private var scale: CGFloat = 1
    @State private var opacity = 1.0
    let scaleValues: [Double]
    let opacityValues: [Double]
    let nextKeyframe: (KeyframeAnimationController<Self>.Animator?) -> Void
    
    var body: some View {
        Circle()
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear() {
                self.nextKeyframe { keyframe, _ in
                    self.scale = CGFloat(self.scaleValues[keyframe])
                    self.opacity = self.opacityValues[keyframe]
                }
        }
    }
}

struct BallScale: View {
    private let duration = 1.0
    private let timingFunction = TimingFunction.easeInOut
    private let keyTimes = [0.0, 1.0]
    private let scaleValues = [0.0, 1.0]
    private let opacityValues = [1.0, 0.0]
    
    var body: some View {
        GeometryReader(content: self.render)
    }
    
    func render(geometry: GeometryProxy) -> some View {
        let dimension = min(geometry.size.width, geometry.size.height)
        let timingFunctions = [timingFunction]
        
        return KeyframeAnimationController<MyCircle>(beginTime: 0,
                                                     duration: self.duration,
                                                     timingFunctions: timingFunctions,
                                                     keyTimes: self.keyTimes) {
                                                        MyCircle(scaleValues: self.scaleValues,
                                                                 opacityValues: self.opacityValues,
                                                                 nextKeyframe: $0)
        }
        .frame(width: dimension, height: dimension, alignment: .center)
    }
}

struct BallScale_Previews: PreviewProvider {
    static var previews: some View {
        BallScale()
    }
}
