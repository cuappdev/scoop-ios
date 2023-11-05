//
//  PostRideViewController.swift
//  Scoop
//
//  Created by Richie Sun on 4/3/23.
//

import UIKit

/// Template View Controller class that contains shared functions needed for the Post Ride Flow
class PostRideViewController: OnboardingViewController {
    
    weak var containerDelegate: AnimationDelegate?
    
    override func setupNextButton(action: UIAction) {
        let bottomButtonMultiplier = 0.075
        let screenSize = UIScreen.main.bounds
        
        nextOnboardingButton.setTitle("Next", for: .normal)
        nextOnboardingButton.backgroundColor = UIColor.scooped.secondaryGreen
        nextOnboardingButton.layer.opacity = 0.5
        nextOnboardingButton.layer.cornerRadius = 25
        nextOnboardingButton.setTitleColor(UIColor.scooped.offBlack, for: .normal)
        nextOnboardingButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        nextOnboardingButton.addAction(action, for: .touchUpInside)
        view.addSubview(nextOnboardingButton)
        
        nextOnboardingButton.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(screenSize.height * bottomButtonMultiplier)
            make.height.equalTo(51)
            make.width.equalTo(86)
        }
    }
    
    override func setupBackButton() {
        let bottomButtonMultiplier = 0.075
        let screenSize = UIScreen.main.bounds
        
        backButton.setTitle("Back", for: .normal)
        backButton.layer.borderColor = UIColor.scooped.offBlack.cgColor
        backButton.layer.borderWidth = 1
        backButton.backgroundColor = .white
        backButton.layer.cornerRadius = 25
        backButton.setTitleColor(UIColor.scooped.scoopDarkGreen, for: .normal)
        backButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        backButton.addTarget(self, action: #selector(prevVC), for: .touchUpInside)
        view.addSubview(backButton)
        
        backButton.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(screenSize.height * bottomButtonMultiplier)
            make.height.equalTo(51)
            make.width.equalTo(86)
        }
    }
    
    override func updateBackButton() {
        backButton.setImage(UIImage(named: "BackArrow"), for: .normal)
        backButton.setTitle("", for: .normal)
        backButton.layer.borderWidth = 0
        containerDelegate?.navigationController?.navigationBar.addSubview(backButton)
        
        backButton.snp.removeConstraints()
        backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
        }
    }
    
    @objc override func prevVC() {
        guard let navCtrl = self.navigationController else { return }
        
        containerDelegate?.navigationController?.navigationBar.subviews.forEach({ subview in
            if let backButton = subview as? UIButton {
                backButton.removeFromSuperview()
            }
        })
        self.delegate?.didTapBack(navCtrl, previousViewController: nil)
    }
    
    func removeBackButton() {
        containerDelegate?.navigationController?.navigationBar.subviews.forEach({ subview in
            if let backButton = subview as? UIButton {
                backButton.removeFromSuperview()
            }
        })
    }
    
}

