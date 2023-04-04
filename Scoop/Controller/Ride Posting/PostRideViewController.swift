//
//  PostRideViewController.swift
//  Scoop
//
//  Created by Richie Sun on 4/3/23.
//

import UIKit

class PostRideViewController: OnboardingViewController {
    
    weak var containerDelegate: AnimationDelegate?
    
    override func setupNextButton(action: UIAction) {
        let bottomButtonMultiplier = 0.075
        let screenSize = UIScreen.main.bounds
        
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.backgroundColor = .secondaryGreen
        button.layer.cornerRadius = 25
        button.setTitleColor(.offBlack, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.addAction(action, for: .touchUpInside)
        view.addSubview(button)
        
        button.snp.makeConstraints { make in
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
        backButton.layer.borderColor = UIColor.offBlack.cgColor
        backButton.layer.borderWidth = 1
        backButton.backgroundColor = .white
        backButton.layer.cornerRadius = 25
        backButton.setTitleColor(.scoopDarkGreen, for: .normal)
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
        guard let navCtrl = self.navigationController else {
            return
        }
        containerDelegate?.navigationController?.navigationBar.subviews.forEach({ subview in
            if let backButton = subview as? UIButton {
                backButton.removeFromSuperview()
            }
        })
        self.delegate?.didTapBack(navCtrl, previousViewController: nil)

    }
    
}

