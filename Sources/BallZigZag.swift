//
//  BallZigZag.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/10/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

public struct BallZigZag: View {
    private let duration = 0.7
    private let timingFunction = TimingFunction.linear
    private let keyTimes = [0, 0.33, 0.66, 1]
    private let directionValues: [[UnitPoint]] = [[.zero, .init(x: -1, y: -1), .init(x: 1, y: -1), .zero],
                                                  [.zero, .init(x: 1, y: 1), .init(x: -1, y: 1), .zero]]

    public var body: some View {
        GeometryReader(content: render)
    }

    public init() { }

    func render(geometry: GeometryProxy) -> some View {
        let dimension = min(geometry.size.width, geometry.size.height)
        let objectDimension: CGFloat = dimension / 3
        let timingFunctions = Array(repeating: timingFunction, count: keyTimes.count - 1)
        let values = directionValues.map {
            $0.map {
                UnitPoint(x: $0.x * (dimension - objectDimension) / 2, y: $0.y * (dimension - objectDimension) / 2)
            }
        }

        return ZStack {
            ForEach(0..<2, id: \.self) { index in
                KeyframeAnimationController(beginTime: 0,
                                            duration: duration,
                                            timingFunctions: timingFunctions,
                                            keyTimes: keyTimes) {
                    Circle()
                        .frame(width: objectDimension, height: objectDimension)
                        .offset(x: values[index][$0].x, y: values[index][$0].y)
                }
            }
        }.frame(width: geometry.size.width, height: geometry.size.height)
    }
}

struct BallZigZag_Previews: PreviewProvider {
    static var previews: some View {
        BallZigZag()
    }
}
