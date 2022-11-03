//
//  PreferredContactViewController.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/16/22.
//

import UIKit

class PreferredContactViewController: OnboardingViewController {
    
    private let stackView = UIStackView()
    private let emailButton = UIButton()
    private let phoneButton = UIButton()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        backButton.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTitle(name: "About you")
        setupTitleLines()
        setupStackView()
        
        nextAction = UIAction { _ in
            guard let navCtrl = self.navigationController else {
                return
            }
            
            guard self.phoneButton.isSelected else {
                self.delegate?.didTapNext(navCtrl, nextViewController: nil)
                return
            }
            let phoneVC = PhoneNumberViewController()
            phoneVC.delegate = self.delegate
            self.backButton.isHidden = true
            self.navigationController?.pushViewController(phoneVC, animated: true)
        }
        
        backButton.isHidden = false
        setupNextButton(action: nextAction ?? UIAction(handler: { _ in
            return
        }))
    }

    private func setupStackView() {
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.alignment = .leading
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.center.equalToSuperview()
        }
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "Rambla-Regular", size: 16)
        titleLabel.text = "PREFERRED CONTACT METHOD"
        titleLabel.accessibilityLabel = "preferred contact method"
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .black
        stackView.addArrangedSubview(titleLabel)
        
        emailButton.isSelected = true
        emailButton.setTitle("Cornell Email", for: .normal)
        emailButton.setTitleColor(.black, for: .normal)
        emailButton.titleLabel?.font = UIFont(name: "SFPro", size: 16)
        emailButton.titleLabel?.adjustsFontSizeToFitWidth = true
        emailButton.setImage(UIImage(systemName: "circle"), for: .normal)
        emailButton.setImage(UIImage(systemName: "circle.inset.filled"), for: .selected)
        emailButton.tintColor = .black
        emailButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        emailButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        stackView.addArrangedSubview(emailButton)
        
        phoneButton.setTitle("Phone Number", for: .normal)
        phoneButton.setTitleColor(.black, for: .normal)
        phoneButton.titleLabel?.font = UIFont(name: "SFPro", size: 16)
        phoneButton.titleLabel?.adjustsFontSizeToFitWidth = true
        phoneButton.setImage(UIImage(systemName: "circle"), for: .normal)
        phoneButton.setImage(UIImage(systemName: "circle.inset.filled"), for: .selected)
        phoneButton.tintColor = .black
        phoneButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        phoneButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        stackView.addArrangedSubview(phoneButton)
        
        let selectContactAction = UIAction { _ in
            self.emailButton.isSelected.toggle()
            self.phoneButton.isSelected.toggle()
        }
        
        emailButton.addAction(selectContactAction, for: .touchUpInside)
        phoneButton.addAction(selectContactAction, for: .touchUpInside)
    }
}
