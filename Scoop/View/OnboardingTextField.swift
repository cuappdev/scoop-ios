//
//  OnboardingTextField.swift
//  Scoop
//
//  Created by Richie Sun on 9/13/23.
//

import UIKit

class OnboardingTextField: UITextField {

    // MARK: - Data

    var padding = UIEdgeInsets(top: 18.5, left: 16, bottom: 18.5, right: 16)
    
    weak var associatedView: UIView?

    // MARK: - Initializers

    init(isShifted: Bool = false) {
        if isShifted {
            padding = UIEdgeInsets(top: 12, left: 38, bottom: 12, right: 60)
        }

        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - TextField Bounds
    
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

