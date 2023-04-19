//
//  CIImage+Extensions.swift
//  demoapp
//
//  Created by Amy While on 10/04/2023.
//

import CoreImage

extension CIImage {
    func oriented(_ orientation: CGImagePropertyOrientation) -> CIImage {
        return self.oriented(forExifOrientation: Int32(orientation.rawValue))
    }
}
