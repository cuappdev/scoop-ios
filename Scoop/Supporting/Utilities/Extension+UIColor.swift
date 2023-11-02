//
//  Extension+UIColor.swift
//  Scoop
//
//  Created by Reade Plunkett on 4/21/22.
//

import Foundation
import UIKit

extension UIColor {

    static let scooped = Scooped()

    struct Scooped {
        let borderColor = UIColor(red: 148/255, green: 148/255, blue: 148/255, alpha: 1)
        let darkerGreen = UIColor(red: 0, green: 0.42, blue: 0.33, alpha: 1)
        let disabledGreen = UIColor(red: 219/255, green: 229/255, blue: 223/255, alpha: 1)
        let disabledGrey = UIColor(red: 136/255, green: 153/255, blue: 155/255, alpha: 1)
        let labelGray = UIColor(red: 112/255, green: 112/255, blue: 112/255, alpha: 1)
        let linearGradient = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        let mutedGrey = UIColor(red: 106/255, green: 115/255, blue: 125/255, alpha: 1)
        let notification = UIColor(red: 0.85, green: 0.33, blue: 0.33, alpha: 1)
        let offBlack = UIColor(red: 0, green: 30/255, blue: 45/255, alpha: 1)
        let primaryGrey = UIColor(red: 54/255, green: 69/255, blue: 79/255, alpha: 1)
        let scoopGreen = UIColor(red: 96/255, green: 191/255, blue: 160/255, alpha: 1)
        let scoopDarkGreen = UIColor(red: 58/255, green: 146/255, blue: 117/255, alpha: 1)
        let secondaryGreen = UIColor(red: 206/255, green: 233/255, blue: 220/255, alpha: 1)
        let skipButtonColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        let textFieldBorderColor = UIColor(red: 106/255, green: 115/255, blue: 125/255, alpha: 1)

        let whiteGradientColors = [
            UIColor.white.withAlphaComponent(0).cgColor,
            UIColor.white.withAlphaComponent(0.3).cgColor,
            UIColor.white.withAlphaComponent(0.6).cgColor,
            UIColor.white.withAlphaComponent(0.9).cgColor,
            UIColor.white.cgColor,
            UIColor.white.cgColor,
            UIColor.white.cgColor,
            UIColor.white.cgColor,
            UIColor.white.cgColor,
            UIColor.white.cgColor,
            UIColor.white.cgColor,
            UIColor.white.cgColor
        ]
    }

}
