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
        VStack(spacing: 0) {
            HStack(spacing: 20) {
                BallPulse()
                BallGridPulse()
                BallClipRotate()
                SquareSpin()
            }
            HStack(spacing: 20) {
                BallClipRotatePulse()
                BallClipRotateMultiple()
                BallRotate()
                CubeTransition()
            }
            HStack(spacing: 20) {
                BallZigZag()
                BallZigZagDeflect()
                BallTrianglePath()
                BallScale()
            }
            HStack(spacing: 20) {
                LineScale()
                LineScaleParty()
                BallPulseSync()
                BallBeat()
            }
            HStack(spacing: 20) {
                LineScalePulseOut()
                LineScalePulseOutRapid()
                BallScaleRipple()
                BallScaleRippleMultiple()
            }
            HStack(spacing: 20) {
                TriangleSkewSpin()
                BallGridBeat()
                SemiCircleSpin()
                CircleStrokeSpin()
            }
        }.padding(20)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
