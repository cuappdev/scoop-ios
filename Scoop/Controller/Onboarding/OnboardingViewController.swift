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
    
    weak var delegate: OnboardingDelegate?
    var nextAction: UIAction?
    let backButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        view.backgroundColor = .white
    }
    
    func setupNextButton(action: UIAction) {
        var bottomButtonMultiplier = 0.1
        let screenSize = UIScreen.main.bounds
        
        if screenSize.height < 2000 {
            bottomButtonMultiplier = 0
        }
        
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
    
    func setupBackButton() {
        var bottomButtonMultiplier = 0.1
        let screenSize = UIScreen.main.bounds
        
        if screenSize.height < 2000 {
            bottomButtonMultiplier = 0
        }
        
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
    
    func updateBackButton() {
        backButton.setImage(UIImage(named: "BackArrow"), for: .normal)
        backButton.setTitle("", for: .normal)
        backButton.layer.borderWidth = 0
        navigationController?.navigationBar.addSubview(backButton)
        
        backButton.snp.removeConstraints()
        backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
        }
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
        
        let solidline = UIView()
        solidline.backgroundColor = .black
        view.addSubview(solidline)
        solidline.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(screenSize.width*solidLineMultiplier)
            make.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(solidLineVerticalInset)
        }

    }
    
    func addPrompt(name: String, placeholder: String, answer: String) {
        NetworkManager.shared.postPrompt(name: name, placeholder: placeholder) { result in
            switch result {
            case .success(var prompt):
                var shouldAppend = true
                let userAnswer = UserAnswer(id: prompt.id, answer: answer)
                NetworkManager.shared.userPromptAnswers.forEach { userPrompt in
                    if userPrompt.id == userAnswer.id {
                        userPrompt.answer = userAnswer.answer
                        shouldAppend = false
                    }
                }
                
                if shouldAppend {
                    NetworkManager.shared.userPromptAnswers.append(userAnswer)
                }
                NetworkManager.shared.userPromptAnswers.append(userAnswer)
                print("Updated: \(prompt.questionName) to \(answer)")
            case .failure(let error):
                print(error.localizedDescription)
            }
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
    
    let padding = UIEdgeInsets(top: 18.5, left: 16, bottom: 18.5, right: 16)

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
