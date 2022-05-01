//
//  ViewController.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/18/22.
//

import UIKit

protocol OnboardingDelegate: AnyObject {
    func didTapNext(_ viewController: UIViewController, nextViewController: UIViewController?)
}

class OnboardingViewController: UIViewController {
    
    internal weak var delegate: OnboardingDelegate?
    internal var nextAction: UIAction?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }

}
