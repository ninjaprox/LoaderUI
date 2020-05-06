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
                BallPulse().frame(width: 100, height: 100, alignment: .center)
                BallGridPulse().frame(width: 100, height: 100, alignment: .center)
                BallBeat().frame(width: 100, height: 100, alignment: .center)
            }
            HStack(spacing: 20) {
                BallGridBeat().frame(width: 100, height: 100, alignment: .center)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
