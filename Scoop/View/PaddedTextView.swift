//
//  PaddedTextView.swift
//  Scoop
//
//  Created by Richie Sun on 10/18/23.
//

import UIKit

class PaddedTextView: UITextView {

    // MARK: - Constants

    let padding = UIEdgeInsets(top: 18.5, left: 16, bottom: 18.5, right: 16)
    weak var associatedView: UIView?

    // MARK: - Initializers

    init(associatedView: UIView? = nil) {
        self.associatedView = associatedView
        super.init(frame: CGRect(), textContainer: nil)
        self.contentInset = padding
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
