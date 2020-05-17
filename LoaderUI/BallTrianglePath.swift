//
//  BallTrianglePath.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/12/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

fileprivate struct Ring: Shape {
    func path(in rect: CGRect) -> Path {
        let dimension = min(rect.size.width, rect.size.height)
        let lineWidth = dimension / 32 * 3
        let path = Path(ellipseIn: rect)
        
        return path.strokedPath(StrokeStyle(lineWidth: lineWidth))
    }
}

struct BallTrianglePath: View {
    private let duration = 2.0
    private let timingFunction = TimingFunction.easeInOut
    private let keyTimes = [0, 0.33, 0.66, 1]
    private let directionValues: [[UnitPoint]] = [[.zero, .init(x: 0.5, y: 1), .init(x: -0.5, y: 1), .zero],
                                                  [.zero, .init(x: -1, y: 0), .init(x: -0.5, y: -1), .zero],
                                                  [.zero, .init(x: 0.5, y: -1), .init(x: 1, y: 0), .zero]]
    
    var body: some View {
        GeometryReader(content: self.render)
    }
    
    func render(geometry: GeometryProxy) -> some View {
        let dimension = min(geometry.size.width, geometry.size.height)
        let ringDimension = dimension / 3
        let timingFunctions = [timingFunction, timingFunction, timingFunction]
        let positions = [CGPoint(x: dimension / 2, y: ringDimension / 2),
                         CGPoint(x: dimension - ringDimension / 2, y: dimension - ringDimension / 2),
                         CGPoint(x: ringDimension / 2, y: dimension - ringDimension / 2)]
        let values = directionValues.map {
            $0.map {
                UnitPoint(x: $0.x * (dimension - ringDimension), y: $0.y * (dimension - ringDimension))
            }
        }
        
        return
            ZStack {
                ForEach(0..<3, id: \.self) { index in
                    KeyframeAnimationController(beginTime: 0,
                                                duration: self.duration,
                                                timingFunctions: timingFunctions,
                                                keyTimes: self.keyTimes) {
                                                    Ring()
                                                        .frame(width: ringDimension, height: ringDimension)
                                                        .position(x: positions[index].x, y: positions[index].y)
                                                        .offset(x: values[index][$0].x, y: values[index][$0].y)
                    }
                }
            }
            .frame(width: dimension, height: dimension, alignment: .center)
    }
}

struct BallTrianglePath_Previews: PreviewProvider {
    static var previews: some View {
        BallTrianglePath()
    }
}
