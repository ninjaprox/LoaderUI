//
//  CubeTransition.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/10/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

public struct CubeTransition: View {
    private let duration = 1.6
    private let timingFunction = TimingFunction.easeInOut
    private let keyTimes = [0, 0.25, 0.5, 0.75, 1]
    private let scaleValues: [CGFloat] = [1, 0.5, 1, 0.5, 1]
    private let rotationValues = [0.0, -.pi / 2, -.pi, -1.5 * .pi, -2 * .pi]
    private let translationDirectionValues: [[UnitPoint]] = [[.zero, .init(x: 1, y: 0), .init(x: 1, y: 1), .init(x: 0, y: 1), .zero],
                                                             [.zero, .init(x: -1, y: 0), .init(x: -1, y: -1), .init(x: 0, y: -1), .zero]]
    
    public var body: some View {
        GeometryReader(content: self.render)
    }

    public init() { }
    
    func render(geometry: GeometryProxy) -> some View {
        let dimension = min(geometry.size.width, geometry.size.height)
        let objectDimension = dimension / 3
        let timingFunctions = Array(repeating: timingFunction, count: keyTimes.count - 1)
        let positions = [CGPoint(x: objectDimension / 2, y: objectDimension / 2),
                         CGPoint(x: dimension - objectDimension / 2, y: dimension - objectDimension / 2)]
        let translationValues = translationDirectionValues.map {
            $0.map {
                UnitPoint(x: $0.x * (dimension - objectDimension), y: $0.y * (dimension - objectDimension))
            }
        }
        
        return
            ZStack {
                ForEach(0..<2, id: \.self) { index in
                    KeyframeAnimationController(beginTime: 0,
                                                duration: self.duration,
                                                timingFunctions: timingFunctions,
                                                keyTimes: self.keyTimes) {
                                                    Rectangle()
                                                        .scaleEffect(self.scaleValues[$0])
                                                        .rotationEffect(Angle(radians: self.rotationValues[$0]))
                                                        .frame(width: objectDimension, height: objectDimension)
                                                        .position(positions[index])
                                                        .offset(x: translationValues[index][$0].x, y: translationValues[index][$0].y)
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
