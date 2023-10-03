//
//  OnboardingTextField.swift
//  Scoop
//
//  Created by Richie Sun on 9/13/23.
//

import UIKit

class OnboardingTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 18.5, left: 16, bottom: 18.5, right: 16)
    
    weak var associatedView: UIView?

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

