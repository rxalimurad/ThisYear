//
//  AdjustableContraints.swift
//  ThisYear
//
//  Created by Ali Murad on 16/01/2024.
//

import UIKit

class AdjustableContraints: NSLayoutConstraint {
    @IBInspectable var adjustContraint: CGFloat = 0  {
        didSet {
            self.constant = floor(getDeviceBasedHeight(height: 180) )
        }
    }
    
     func getDeviceBasedHeight(height: CGFloat) -> CGFloat {
        (height / 812) * UIScreen.main.bounds.size.height
    }
}
