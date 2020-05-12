//
//  LineScale.swift
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
                .scaleEffect(x: 1, y: self.scale, anchor: .center)
                .onAppear() {
                    self.nextKeyframe { keyframe, _ in
                        self.scale = CGFloat(self.values[keyframe])
                    }
            }
        }
    }
}

struct LineScale: View {
    private let beginTimes = [0.1, 0.2, 0.3, 0.4, 0.5]
    private let duration = 1.0
    private let timingFunction = TimingFunction.timingCurve(c0x: 0.2, c0y: 0.68, c1x: 0.18, c1y: 1.08)
    private let keyTimes = [0, 0.5, 1]
    private let values = [1, 0.4, 1]
    
    var body: some View {
        GeometryReader(content: self.render)
    }
    
    func render(geometry: GeometryProxy) -> some View {
        let dimension = min(geometry.size.width, geometry.size.height)
        let spacing = dimension / 9
        let timingFunctions = [timingFunction, timingFunction]
        
        return HStack(spacing: spacing) {
            ForEach(0..<5, id: \.self) { index in
                KeyframeAnimationController<MyLine>(beginTime: self.beginTimes[index],
                                                    duration: self.duration,
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

struct LineScale_Previews: PreviewProvider {
    static var previews: some View {
        LineScale()
    }
}
