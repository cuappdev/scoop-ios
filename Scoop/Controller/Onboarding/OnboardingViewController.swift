//
//  ViewController.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/18/22.
//

import UIKit

protocol OnboardingDelegate: AnyObject {
    func didTapNext(_ viewController: UIViewController, nextViewController: UIViewController?)
    func didTapBack(_ viewController: UIViewController, previousViewController: UIViewController?)
}

class OnboardingViewController: UIViewController {
    
    internal weak var delegate: OnboardingDelegate?
    internal var nextAction: UIAction?
    let backButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        view.backgroundColor = .white
    }
    
    func setupNextButton(action: UIAction) {
        let bottomButtonMultiplier = 0.1
        
        let button = UIButton()
        button.setImage(UIImage(named: "nextbutton"), for: .normal)
        button.clipsToBounds = true
        button.addAction(action, for: .touchUpInside)
        view.addSubview(button)
        
        button.snp.makeConstraints { make in
            let screenSize = UIScreen.main.bounds
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(screenSize.height * bottomButtonMultiplier)
        }
    }
    
    func setupBackButton() {
        backButton.setImage(UIImage(named: "BackArrow"), for: .normal)
        backButton.addTarget(self, action: #selector(prevVC), for: .touchUpInside)
        self.navigationController?.navigationBar.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(25)
            make.top.centerY.equalToSuperview()
        }
    }

    func setBackButtonVisibility(isHidden: Bool) {
        backButton.isHidden = isHidden
        backButton.isEnabled = !isHidden
    }
    
    
    func setupTitle(name: String) {
        self.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont(name: "Sen-Regular", size: 24)]
        self.navigationItem.title = name
    }
    
    func setupTitleLines() {
        let dottedLineMultiplier = 0.52
        let solidLineVerticalInset = -12.75
        let solidLineMultiplier = 0.32
        let screenSize = UIScreen.main.bounds
        let dottedline = UIImageView(image: UIImage(named: "dottedline"))
        
        dottedline.contentMode = .scaleAspectFit
        view.addSubview(dottedline)
        dottedline.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(screenSize.width*dottedLineMultiplier)
            make.trailing.equalToSuperview().inset(10)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        let solidline = UILabel()
        solidline.backgroundColor = .black
        view.addSubview(solidline)
        solidline.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(screenSize.width*solidLineMultiplier)
            make.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(solidLineVerticalInset)
        }

    }
    
    @objc func prevVC() {
        guard let navCtrl = self.navigationController else {
            return
        }
        self.delegate?.didTapBack(navCtrl, previousViewController: nil)

    }
}

class OnboardingTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
