//
//  Extension+UIImage.swift
//  Scoop
//
//  Created by Caitlyn Jin on 10/4/23.
//

import Foundation
import UIKit

extension UIImage {

    static let scooped = Scooped()

    struct Scooped {
        let blockCallIcon = UIImage(named: "blockCallIcon")
        let cancelIcon = UIImage(named: "cancelIcon")
        let dottedLine = UIImage(named: "dottedline")
        let emptyImage = UIImage(named: "emptyimage")
        let notifIcon = UIImage(named: "notifIcon")
        let profileButton = UIImage(named: "profilebutton")
        let setttingsIcon = UIImage(named: "settingsIcon")
        let sliderThumb = UIImage(named: "SliderThumb")
        let sliderTicks = UIImage(named: "SliderTicks")
    }
    
    func imageToB64(compression: CGFloat) -> String {
        let base64 = self.jpegData(compressionQuality: compression)?.base64EncodedString() ?? ""
        return "data:image/png;base64," + base64
    }
    
}
