//
//  Extension+UIViewController.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/29/22.
//

import Foundation
import UIKit

extension UIViewController {
    
    func presentErrorAlert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alertVC.view.tintColor = .scoopDarkGreen
        alertVC.title
        present(alertVC, animated: true)
    }
    
}

extension UIView {
    
    func addDropShadow(){
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 5
        layer.shadowOffset = .zero
        
        //MARK: Caches shadow. Removing does not affect performance, but will leave commented just in case
//        layer.shouldRasterize = true
//        layer.rasterizationScale = UIScreen.main.scale
    }
    
}
