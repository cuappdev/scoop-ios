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
    
    func setupNextButton(view: UIView, action: UIAction, button: UIButton) {
        button.setImage(UIImage(named: "nextbutton"), for: .normal)
        button.clipsToBounds = true
        button.addAction(action, for: .touchUpInside) //EDIT LATER
        view.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(282)
            make.top.equalToSuperview().offset(601)
        }
    }
}
