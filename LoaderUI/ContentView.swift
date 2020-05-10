//
//  ContentView.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 4/19/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

struct ScaleEffect: GeometryEffect {
    var scale: CGFloat

    var animatableData: CGFloat {
        get { scale }
        set {
            scale = newValue
            print("ScaleEffect: \(scale)")
        }
    }

    func effectValue(size: CGSize) -> ProjectionTransform {
        let transform = CGAffineTransform(translationX: -size.width / 2, y: -size.height / 2)
            .concatenating(.init(scaleX: scale, y: scale))
            .concatenating(.init(translationX: size.width / 2, y: size.height / 2))

        return ProjectionTransform(transform)
    }
}

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                BallPulse()
                BallGridPulse()
                BallClipRotate()
                SquareSpin()
            }
            HStack(spacing: 20) {
                BallClipRotatePulse()
                BallClipRotateMultiple()
                BallPulseRise()
                BallRotate()
            }
            HStack(spacing: 20) {
                BallBeat()
                BallGridBeat()
            }
        }
        .padding(20)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
