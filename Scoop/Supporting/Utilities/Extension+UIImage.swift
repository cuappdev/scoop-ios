//
//  Extension+UIImage.swift
//  Scoop
//
//  Created by Caitlyn Jin on 10/4/23.
//

import Foundation
import UIKit

extension UIImage {

    static let blockCallIcon = UIImage(named: "blockCallIcon")
    static let cancelIcon = UIImage(named: "cancelIcon")
    static let dottedLine = UIImage(named: "dottedline")
    static let emptyImage = UIImage(named: "emptyimage")
    static let profileButton = UIImage(named: "profilebutton")
    static let setttingsIcon = UIImage(named: "settingsIcon")
    static let sliderThumb = UIImage(named: "SliderThumb")
    static let sliderTicks = UIImage(named: "SliderTicks")
    
    func imageToB64(compression: CGFloat) -> String {
        let base64 = self.jpegData(compressionQuality: compression)?.base64EncodedString() ?? ""
        return "data:image/png;base64," + base64
    }
    
}
