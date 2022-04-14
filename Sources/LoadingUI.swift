//
//  File.swift
//  
//
//  Created by Morris Richman on 2/6/22.
//

import Foundation
import SwiftUI

struct LoadingUI: View {
    @State var selectedType: types
    @State var duration: Double
    enum types {
        case ballPulse
        case ballGridPulse
        case ballClipRotate
        case squareSpin
        case ballClipRotatePulse
        case ballClipRotateMultiple
        case ballRotate
        case cubeTransition
        case ballZigZag
        case ballZigZagDeflect
        case ballTrianglePath
        case ballScale
        case lineScale
        case lineScaleParty
        case ballPulseSync
        case ballBeat
        case lineScalePulseOut
        case lineScalePulseOutRapid
        case ballScaleRipple
        case ballScaleRippleMultiple
        case triangleSkewSpin
        case ballGridBeat
        case semiCircleSpin
    }
    var body: some View {
        Group {
            switch selectedType {
            case .ballPulse:
                BallPulse(duration: duration)
            case .ballGridPulse:
                BallGridPulse()
            case .ballClipRotate:
                BallClipRotate(duration: duration)
            case .squareSpin:
                SquareSpin(duration: duration)
            case .ballClipRotatePulse:
                BallClipRotatePulse(duration: duration)
            case .ballClipRotateMultiple:
                BallClipRotateMultiple(duration: duration)
            case .ballRotate:
                BallRotate(duration: duration)
            case .cubeTransition:
                CubeTransition(duration: duration)
            case .ballZigZag:
                BallZigZag(duration: duration)
            case .ballZigZagDeflect:
                BallZigZagDeflect(duration: duration)
            case .ballTrianglePath:
                BallTrianglePath(duration: duration)
            case .ballScale:
                BallScale(duration: duration)
            case .lineScale:
                LineScale(duration: duration)
            case .lineScaleParty:
                LineScaleParty()
            case .ballPulseSync:
                BallPulseSync(duration: duration)
            case .ballBeat:
                BallBeat(duration: duration)
            case .lineScalePulseOut:
                LineScalePulseOut(duration: duration)
            case .lineScalePulseOutRapid:
                LineScalePulseOutRapid(duration: duration)
            case .ballScaleRipple:
                BallScaleRipple(duration: duration)
            case .ballScaleRippleMultiple:
                BallScaleRippleMultiple(duration: duration)
            case .triangleSkewSpin:
                TriangleSkewSpin(duration: duration)
            case .ballGridBeat:
                BallGridBeat()
            case .semiCircleSpin:
                SemiCircleSpin(duration: duration)
            }
        }
//        .frame(width: 20, height: 20)
    }
}

struct LoadingUI_Previews: PreviewProvider {
    static var previews: some View {
        LoadingUI(selectedType: .ballBeat, duration: 0.0)
    }
}

