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

fileprivate struct MyRing: View, KeyframeAnimatable {
    enum Position {
        case top
        case right
        case left
    }
    
    @State private var translation: UnitPoint = .zero
    let dimension: CGFloat
    let position: Position
    let values: [UnitPoint]
    let nextKeyframe: (KeyframeAnimationController<Self>.Animator?) -> Void
    
    var body: some View {
        GeometryReader(content: self.render)
    }
    
    func render(geometry: GeometryProxy) -> some View {
        let geometryDimension = min(geometry.size.width, geometry.size.height)
        let position: CGPoint
        
        switch self.position {
        case .top:
            position = CGPoint(x: geometryDimension / 2, y: dimension / 2)
        case .right:
            position = CGPoint(x: geometryDimension - dimension / 2, y: geometryDimension - dimension / 2)
        case .left:
            position = CGPoint(x: dimension / 2, y: geometryDimension - dimension / 2)
        }
        
        return Ring()
            .frame(width: dimension, height: dimension)
            .position(position)
            .offset(x: translation.x * (geometryDimension - dimension),
                    y: translation.y * (geometryDimension - dimension))
            .onAppear() {
                self.nextKeyframe { keyframe, _ in
                    self.translation = self.values[keyframe]
                }
        }
    }
}

struct BallTrianglePath: View {
    private let duration = 2.0
    private let timingFunction = TimingFunction.easeInOut
    private let keyTimes = [0, 0.33, 0.66, 1]
    private let values: [[UnitPoint]] = [[.zero, .init(x: 0.5, y: 1), .init(x: -0.5, y: 1), .zero],
                                         [.zero, .init(x: -1, y: 0), .init(x: -0.5, y: -1), .zero],
                                         [.zero, .init(x: 0.5, y: -1), .init(x: 1, y: 0), .zero]]
    private let positions: [MyRing.Position] = [.top, .right, .left]
    
    var body: some View {
        GeometryReader(content: self.render)
    }
    
    func render(geometry: GeometryProxy) -> some View {
        let dimension = min(geometry.size.width, geometry.size.height)
        let ringDimension = dimension / 3
        let timingFunctions = [timingFunction, timingFunction, timingFunction]
        
        return
            ZStack {
                ForEach(0..<3, id: \.self) { index in
                    KeyframeAnimationController<MyRing>(beginTime: 0,
                                                        duration: self.duration,
                                                        timingFunctions: timingFunctions,
                                                        keyTimes: self.keyTimes) {
                                                            MyRing(dimension: ringDimension,
                                                                   position: self.positions[index],
                                                                   values: self.values[index],
                                                                   nextKeyframe: $0)
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
