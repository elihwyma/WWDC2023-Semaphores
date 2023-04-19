//
//  AVCaptureVideoOrientation.swift
//  demoapp
//
//  Created by Amy While on 10/04/2023.
//

import UIKit
import AVFoundation

extension AVCaptureVideoOrientation {
    
    init?(deviceOrientation: UIDeviceOrientation) {
        switch deviceOrientation {
        case .portrait: self = .portrait
        case .portraitUpsideDown: self = .portraitUpsideDown
        case .landscapeLeft: self = .landscapeRight
        case .landscapeRight: self = .landscapeLeft
        default: return nil
        }
    }
    
    init?(interfaceOrientation: UIInterfaceOrientation) {
        switch interfaceOrientation {
        case .portrait: self = .portrait
        case .portraitUpsideDown: self = .portraitUpsideDown
        case .landscapeLeft: self = .landscapeLeft
        case .landscapeRight: self = .landscapeRight
        default: return nil
        }
    }
    
    var cgOrientation: CGImagePropertyOrientation {
        switch self {
        case .portrait:
            return .up
        case .portraitUpsideDown:
            return .down
        case .landscapeRight:
            return .rightMirrored
        case .landscapeLeft:
            return .leftMirrored
        @unknown default:
            return .up
        }
    }
    
}
