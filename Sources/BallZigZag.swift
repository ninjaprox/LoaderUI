//
//  BallZigZag.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/10/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

public struct BallZigZag: View {
    private let duration:Double
    private let defaultDuration = 0.7
    private let timingFunction = TimingFunction.linear
    private var keyTimes = [0, 0.33, 0.66, 1]
    private let directionValues: [[UnitPoint]] = [[.zero, .init(x: -1, y: -1), .init(x: 1, y: -1), .zero],
                                                  [.zero, .init(x: 1, y: 1), .init(x: -1, y: 1), .zero]]
    
    public var body: some View {
        GeometryReader(content: self.render)
    }

    public init(duration: Double) {
        if duration <= defaultDuration {
            self.duration = defaultDuration
        } else {
            self.duration = duration
        }
        if duration > defaultDuration {
            keyTimes = [0, 0.33*duration, 0.66*duration, duration]
        }
    }
    
    func render(geometry: GeometryProxy) -> some View {
        let dimension = min(geometry.size.width, geometry.size.height)
        let objectDimension: CGFloat = dimension / 3
        let timingFunctions = Array(repeating: timingFunction, count: keyTimes.count - 1)
        let values = directionValues.map {
            $0.map {
                UnitPoint(x: $0.x * (dimension - objectDimension) / 2, y: $0.y * (dimension - objectDimension) / 2)
            }
        }
        
        return
            ZStack {
                ForEach(0..<2, id: \.self) { index in
                    KeyframeAnimationController(beginTime: 0,
                                                duration: self.duration,
                                                timingFunctions: timingFunctions,
                                                keyTimes: self.keyTimes) {
                                                    Circle()
                                                        .frame(width: objectDimension, height: objectDimension)
                                                        .offset(x: values[index][$0].x, y: values[index][$0].y)
                    }
                }
            }
            .frame(width: dimension, height: dimension, alignment: .center)
    }
}

struct BallZigZag_Previews: PreviewProvider {
    static var previews: some View {
        BallZigZag(duration: 0.7)
    }
}
