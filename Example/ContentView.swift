//
//  ContentView.swift
//  Example
//
//  Created by Vinh Nguyen on 5/23/20.
//

import SwiftUI
import LoaderUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                BallPulse(duration: 0.0)
                BallGridPulse(duration: 0.0)
                BallClipRotate(duration: 0.0)
                SquareSpin(duration: 0.0)
            }
            HStack(spacing: 20) {
                BallClipRotatePulse(duration: 0.0)
                BallClipRotateMultiple(duration: 0.0)
                BallRotate(duration: 0.0)
                CubeTransition(duration: 0.0)
            }
            HStack(spacing: 20) {
                BallZigZag(duration: 0.0)
                BallZigZagDeflect(duration: 0.0)
                BallTrianglePath(duration: 0.0)
                BallScale(duration: 0.0)
            }
            HStack(spacing: 20) {
                LineScale(duration: 0.0)
                LineScaleParty(duration: 0.0)
                BallPulseSync(duration: 0.0)
                BallBeat(duration: 0.0)
            }
            HStack(spacing: 20) {
                LineScalePulseOut(duration: 0.0)
                LineScalePulseOutRapid(duration: 0.0)
                BallScaleRipple(duration: 0.0)
                BallScaleRippleMultiple(duration: 0.0)
            }
            HStack(spacing: 20) {
                BallScaleRippleMultiple(duration: 0.0)
                TriangleSkewSpin(duration: 0.0)
                BallGridBeat(duration: 0.0)
                SemiCircleSpin(duration: 0.0)
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
