//
//  CubeTransition.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/10/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

fileprivate struct MyRectangle: View, KeyframeAnimatable {
    enum Position {
        case topLeft
        case bottomRight
    }
    
    @State private var scale: CGFloat = 1
    @State private var rotation = 0.0
    @State private var translation: UnitPoint = .zero
    let position: Position
    let scaleValues: [Double]
    let rotationValues: [Double]
    let translationValues: [UnitPoint]
    let nextKeyframe: (KeyframeAnimationController<Self>.Animator?) -> Void
    
    var body: some View {
        GeometryReader(content: self.render)
    }
    
    func render(geometry: GeometryProxy) -> some View {
        let geometryDimension = min(geometry.size.width, geometry.size.height)
        let dimension = geometryDimension / 3
        let position = self.position == .topLeft ?
            CGPoint(x: dimension / 2, y: dimension / 2) :
            CGPoint(x: geometryDimension - dimension / 2, y: geometryDimension - dimension / 2)
        
        return Rectangle()
            .scaleEffect(scale)
            .rotationEffect(Angle(radians: rotation))
            .frame(width: dimension, height: dimension)
            .position(position)
            .offset(x: translation.x * (geometryDimension - dimension),
                    y: translation.y * (geometryDimension - dimension))
            .onAppear() {
                self.nextKeyframe { keyframe, _ in
                    self.scale = CGFloat(self.scaleValues[keyframe])
                    self.rotation = self.rotationValues[keyframe]
                    self.translation = self.translationValues[keyframe]
                }
        }
        
    }
}

struct CubeTransition: View {
    private let duration = 1.6
    private let timingFunction = TimingFunction.easeInOut
    private let keyTimes = [0, 0.25, 0.5, 0.75, 1]
    private let scaleValues = [1, 0.5, 1, 0.5, 1]
    private let rotationValues = [0.0, -.pi / 2, -.pi, -1.5 * .pi, -2 * .pi]
    private let translationValues: [[UnitPoint]] = [[.zero, .init(x: 1, y: 0), .init(x: 1, y: 1), .init(x: 0, y: 1), .zero],
                                                    [.zero, .init(x: -1, y: 0), .init(x: -1, y: -1), .init(x: 0, y: -1), .zero]]
    private let positions: [MyRectangle.Position] = [.topLeft, .bottomRight]
    
    var body: some View {
        GeometryReader(content: self.render)
    }
    
    func render(geometry: GeometryProxy) -> some View {
        let dimension = min(geometry.size.width, geometry.size.height)
        let timingFunctions = [timingFunction, timingFunction, timingFunction, timingFunction]
        
        return
            ZStack {
                ForEach(0..<2, id: \.self) { index in
                    KeyframeAnimationController<MyRectangle>(beginTime: 0,
                                                             duration: self.duration,
                                                             timingFunctions: timingFunctions,
                                                             keyTimes: self.keyTimes) {
                                                                MyRectangle(position: self.positions[index],
                                                                            scaleValues: self.scaleValues,
                                                                            rotationValues: self.rotationValues,
                                                                            translationValues: self.translationValues[index],
                                                                            nextKeyframe: $0)
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
