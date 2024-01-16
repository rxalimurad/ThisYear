//
//  UIView.swift
//  ThisYear
//
//  Created by Ali Murad on 16/01/2024.
//

import UIKit

extension UIView {
    func updateHeightConstraint(to constant: CGFloat) {
        for constraint in constraints {
            if constraint.firstAttribute == .height {
                constraint.constant = constant
                return
            }
        }
        let newHeightConstraint = NSLayoutConstraint(
            item: self,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1.0,
            constant: constant
        )
        addConstraint(newHeightConstraint)
    }
}

