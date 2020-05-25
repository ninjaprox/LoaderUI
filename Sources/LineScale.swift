//
//  LineScale.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/12/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

public struct LineScale: View {
    private let beginTimes = [0.1, 0.2, 0.3, 0.4, 0.5]
    private let duration = 1.0
    private let timingFunction = TimingFunction.timingCurve(c0x: 0.2, c0y: 0.68, c1x: 0.18, c1y: 1.08)
    private let keyTimes = [0, 0.5, 1]
    private let values: [CGFloat] = [1, 0.4, 1]
    
    public var body: some View {
        GeometryReader(content: self.render)
    }

    public init() { }
    
    func render(geometry: GeometryProxy) -> some View {
        let dimension = min(geometry.size.width, geometry.size.height)
        let spacing = dimension / 9
        let timingFunctions = Array(repeating: timingFunction, count: keyTimes.count - 1)
        
        return HStack(spacing: spacing) {
            ForEach(0..<5, id: \.self) { index in
                KeyframeAnimationController(beginTime: self.beginTimes[index],
                                            duration: self.duration,
                                            timingFunctions: timingFunctions,
                                            keyTimes: self.keyTimes) {
                                                RoundedRectangle(cornerRadius: spacing / 2)
                                                    .scaleEffect(x: 1, y: self.values[$0])
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
