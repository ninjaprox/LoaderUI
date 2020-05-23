//
//  AudioEqualizer.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/23/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

struct AudioEqualizer: View {
    private let beginTimes = [0.1, 0.2, 0.3, 0.4, 0.5]
    private let durations = [1.4, 0.8, 0.6, 1.0] // [4.3, 2.5, 1.7, 3.1]
    private let timingFunction = TimingFunction.linear
    private let keyTimes = [0, 0.5, 1]
//    private let values: [CGFloat] = [0, 0.7, 0.4, 0.05, 0.95, 0.3, 0.9, 0.4, 0.15, 0.18, 0.75, 0.01]
    private let values: [CGFloat] = [0, 0.7, 1.1, 1.15, 2.1, 2.4, 3.3, 3.7, 3.85, 4.03, 4.78, 4.79]

    var body: some View {
        GeometryReader(content: self.render)
    }
    
    func render(geometry: GeometryProxy) -> some View {
        let dimension = min(geometry.size.width, geometry.size.height)
        let spacing = dimension / 7
        let timingFunctions = Array(repeating: timingFunction, count: keyTimes.count - 1)
        
        return HStack(spacing: spacing) {
            ForEach(0..<4, id: \.self) { index in
                KeyframeAnimationController(beginTime: self.beginTimes[index],
                                            duration: self.durations[index],
                                            timingFunctions: timingFunctions,
                                            keyTimes: self.keyTimes) {
                                                Rectangle()
                                                    .offset(x: 0, y: dimension - dimension * self.values[$0])
                                                    .size(width: spacing, height: dimension * self.values[$0])
//                                                    .scaleEffect(x: 1, y: self.values[$0], anchor: .bottom)
                }
            }
        }
        .frame(width: dimension, height: dimension, alignment: .center)
        .border(Color.red)
    }
}

struct AudioEqualizer_Previews: PreviewProvider {
    static var previews: some View {
        AudioEqualizer()
    }
}
