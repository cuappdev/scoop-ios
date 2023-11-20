//
//  Extension+UIFont.swift
//  Scoop
//
//  Created by Caitlyn Jin on 10/5/23.
//

import Foundation
import UIKit

extension UIFont {

    static let scooped = Scooped()

    struct Scooped {
        let bodyBold = UIFont.systemFont(ofSize: 16, weight: .bold)
        let bodyMedium = UIFont(name: "Roboto-Regular", size: 14)
        let bodyNormal = UIFont.systemFont(ofSize: 16)
        let bodySemibold = UIFont.systemFont(ofSize: 16, weight: .semibold)
        let buttonSemibold = UIFont.systemFont(ofSize: 12, weight: .semibold)
        let flowHeader = UIFont(name: "Sen-Regular", size: 24)
        let subheader = UIFont(name: "Rambla-Regular", size: 16)
    }

}
