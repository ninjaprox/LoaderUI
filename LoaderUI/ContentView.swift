//
//  ContentView.swift
//  LoaderUI
//
//  Created by Vinh Nguyen on 4/19/20.
//  Copyright © 2020 Vinh Nguyen. All rights reserved.
//

import SwiftUI

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
//                BallPulseRise()
                EmptyView()
                BallRotate()
            }
            HStack(spacing: 20) {
                EmptyView()
                //                CubeTransition()
                //                BallZigZag()
                //                BallZigZagDeflect()
                //                BallTrianglePath()
            }
            HStack(spacing: 20) {
                EmptyView()
                //                BallScale()
                //                LineScale()
                //                LineScaleParty()
                //                BallBeat()
            }
            HStack(spacing: 20) {
                EmptyView()
                //                BallGridBeat()
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
