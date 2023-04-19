//
//  UIImage+Extensions.swift
//  demoapp
//
//  Created by Amy While on 17/04/2023.
//

import UIKit

extension UIFont {
    
    class func systemFont(ofSize size: CGFloat, weight: UIFont.Weight, design: UIFontDescriptor.SystemDesign) -> UIFont {
        let systemFont = UIFont.systemFont(ofSize: size, weight: weight)
        let font: UIFont
        
        if let descriptor = systemFont.fontDescriptor.withDesign(.rounded) {
            font = UIFont(descriptor: descriptor, size: size)
        } else {
            font = systemFont
        }
        return font
    }
    
}

