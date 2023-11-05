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
    
    // MARK: - Views
    
    var nextAction: UIAction?
    let backButton = UIButton()
    let nextOnboardingButton = UIButton()
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackButton()
        view.backgroundColor = .white
    }
    
    // MARK: - Setup View Functions
    
    func setupNextButton(action: UIAction) {
        var bottomButtonMultiplier = 0.1
        let screenSize = UIScreen.main.bounds
        
        if screenSize.height < 2000 {
            bottomButtonMultiplier = 0
        }
        
        nextOnboardingButton.setTitle("Next", for: .normal)
        nextOnboardingButton.backgroundColor = UIColor.scooped.secondaryGreen
        nextOnboardingButton.layer.cornerRadius = 25
        nextOnboardingButton.layer.opacity = 0.5
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
    
    func setNextButtonColor(disabled: Bool) {
        nextOnboardingButton.layer.opacity = disabled ? 0.5 : 1
    }
    
    func textFieldsComplete(texts: [String]) -> Bool {
        var complete = true
        texts.forEach { text in
            if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                complete = false
            }
        }
        
        return complete
    }
    
    func setupBackButton() {
        var bottomButtonMultiplier = 0.1
        let screenSize = UIScreen.main.bounds
        
        if screenSize.height < 2000 {
            bottomButtonMultiplier = 0
        }
        
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
    
    // MARK: - Helper Functions
    
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
                
                print("Updated: \(prompt.questionName) to \(answer)")
            case .failure(let error):
                print("Error in OnboardingViewController: \(error.localizedDescription)")
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
