//
//  CircleStrokeSpin.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 11/5/24.
//

import SwiftUI

fileprivate struct CircleStroke: Shape {
    typealias AnimatableData = AnimatablePair<Angle.AnimatableData, AnimatablePair<Angle.AnimatableData, Angle.AnimatableData>>

    var data: AnimatableData

    var animatableData: AnimatableData {
        get { data }
        set { data = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let dimension = min(rect.size.width, rect.size.height)
        let radius = dimension / 2
        let lineWidth = dimension / 32
        let startAngle = data.second.first
        let endAngle = data.second.second
        var path = Path()

        path.addArc(center: CGPoint(x: rect.width / 2, y: rect.height / 2),
                    radius: radius,
                    startAngle: Angle(radians: startAngle),
                    endAngle: Angle(radians: endAngle),
                    clockwise: false)

        return path.strokedPath(StrokeStyle(lineWidth: lineWidth, lineCap: .round))
    }
}

public struct CircleStrokeSpin: View {
    @State var value = AnimatablePair(0, AnimatablePair(0, 0))
    @State var repeatCount: UInt = 0
    private let duration = 0.75
    private let timingFunction = TimingFunction.timingCurve(c0x: 0.4, c0y: 0, c1x: 0.2, c1y: 1)

    public init() { }

    public var body: some View {
        GeometryReader(content: render)
    }

    func render(geometry: GeometryProxy) -> some View {
        return CircleStroke(data: value)
            .animation(timingFunction.animation(duration: 1.2), value: value.second.first)
            .animation(timingFunction.animation(duration: 0.7), value: value.second.second)
            .rotationEffect(Angle(radians: value.first))
            .animation(.linear(duration: 1.7), value: value.first)
            .onAppear(perform: {
                start()
            })
            .frame(width: geometry.size.width, height: geometry.size.height)
    }

    private func start() {
        value = AnimatablePair(Double(repeatCount + 1) * 2 * .pi, AnimatablePair(Double(repeatCount) * 2 * .pi, Double(repeatCount + 1) * 2 * .pi))
        DispatchQueue.main.asyncAfter(deadline: .now().advanced(by: .milliseconds(500)), execute: DispatchWorkItem(block: {
            value = AnimatablePair(Double(repeatCount + 1) * 2 * .pi, AnimatablePair(Double(repeatCount + 1) * 2 * .pi, Double(repeatCount + 1) * 2 * .pi))
        }))

        DispatchQueue.main.asyncAfter(deadline: .now().advanced(by: .milliseconds(1700)), execute: DispatchWorkItem(block: {
            repeatCount += 1
            start()
        }))
    }
}

struct CircleStrokeSpin_Previews: PreviewProvider {
    static var previews: some View {
        CircleStrokeSpin()
    }
}
