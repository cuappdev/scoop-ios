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
    
    func setupNextButton(action: UIAction) {
        let trailingButtonMultiplier = 0.14
        let bottomButtonMultiplier = 0.12
        
        let button = UIButton()
        button.setImage(UIImage(named: "nextbutton"), for: .normal)
        button.clipsToBounds = true
        button.addAction(action, for: .touchUpInside)
        view.addSubview(button)
        
        button.snp.makeConstraints { make in

            let screenSize = UIScreen.main.bounds
            print(screenSize.width)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(screenSize.width * trailingButtonMultiplier)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(screenSize.height * bottomButtonMultiplier)
        }
    }
}
