//
//  BallClipRotateMultiple.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 5/10/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

struct HorizontalRing: Shape {
    func path(in rect: CGRect) -> Path {
        let dimension = min(rect.size.width, rect.size.height)
        let radius = dimension / 2
        let lineWidth = dimension / 16
        var path = Path()

        path.addArc(center: .zero,
                    radius: radius,
                    startAngle: Angle(radians: .pi / -4),
                    endAngle: Angle(radians: .pi / 4),
                    clockwise: false)
        path.move(to: CGPoint(x: -radius * cos(.pi / 4), y: radius * sin(.pi / 4)))
        path.addArc(center: .zero,
                    radius: radius,
                    startAngle: Angle(radians: 3 * .pi / 4),
                    endAngle: Angle(radians: 5 * .pi / 4),
                    clockwise: false)

        return path.offsetBy(dx: rect.size.width / 2, dy: rect.size.height / 2)
            .strokedPath(StrokeStyle(lineWidth: lineWidth, lineCap: .round))
    }
}

public struct BallClipRotateMultiple: View {
    public var body: some View {
        GeometryReader(content: render)
    }

    public init() { }

    func render(geometry: GeometryProxy) -> some View {
        ZStack {
            renderMyBigRing()
            renderMySmallRing()
        }.frame(width: geometry.size.width, height: geometry.size.height)
    }

    func renderMyBigRing() -> some View {
        let duration = 1.0
        let timingFunction = TimingFunction.easeInOut
        let keyTimes = [0, 0.5, 1]
        let scaleValues: [CGFloat] = [1, 0.6, 1]
        let rotationValues = [0.0, .pi, 2 * .pi]
        let timingFunctions = Array(repeating: timingFunction, count: keyTimes.count - 1)

        return KeyframeAnimationController(beginTime: 0,
                                           duration: duration,
                                           timingFunctions: timingFunctions,
                                           keyTimes: keyTimes,
                                           closedLoop: false) {
            VerticalRing()
                .scaleEffect(scaleValues[$0])
                .rotationEffect(Angle(radians: rotationValues[$0]))
        }
    }

    func renderMySmallRing() -> some View {
        let duration = 1.0
        let timingFunction = TimingFunction.easeInOut
        let keyTimes = [0, 0.5, 1]
        let scaleValues: [CGFloat] = [1, 0.6, 1]
        let rotationValues = [0.0, -.pi, -2 * .pi]
        let timingFunctions = Array(repeating: timingFunction, count: keyTimes.count - 1)

        return KeyframeAnimationController(beginTime: 0,
                                           duration: duration,
                                           timingFunctions: timingFunctions,
                                           keyTimes: keyTimes,
                                           closedLoop: false) {
            HorizontalRing()
                .scale(0.5)
                .scaleEffect(scaleValues[$0])
                .rotationEffect(Angle(radians: rotationValues[$0]))
        }
    }
}

struct BallClipRotateMultiple_Previews: PreviewProvider {
    static var previews: some View {
        BallClipRotateMultiple()
    }
}
