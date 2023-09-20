//
//  ShiftedRightTextField.swift
//  Scoop
//
//  Created by Richie Sun on 9/15/23.
//

import UIKit

class ShiftedRightTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 12, left: 38, bottom: 12, right: 60)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
}
