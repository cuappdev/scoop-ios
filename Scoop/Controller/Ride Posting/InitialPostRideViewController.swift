//
//  InitialPostRideViewController.swift
//  Scoop
//
//  Created by Tiffany Pan on 3/18/23.
//

import GooglePlaces
import UIKit

/// Conformed to OnboardingViewController because a lot of functionality and page design is carried over/very smiliar. 
class InitialPostRideViewController: PostRideViewController {
    
    // MARK: - Views

    private let arrivalTextField = LabeledTextField(isShifted: true)
    private let departureTextField = LabeledTextField(isShifted: true)
    private let nextButton = UIButton()
    private let prevButton = UIButton()
    private let studentDriverButton = UIButton()
    private let taxiButton = UIButton()
    private let titleLabel = UILabel()
    
    // MARK: - Data
    
    private var departureLocationID: String?
    private var arrivalLocationID: String?
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont(name: "Sen-Regular", size: 24)!]
        
        // MARK: Using OnboardingViewController's views
        
        nextAction = UIAction { [self] _ in
            guard let navCtrl = self.navigationController else {
                return
            }

            [departureTextField, arrivalTextField].forEach { textField in
                if (textField.textField.text ?? "").isEmpty {
                    textField.displayError()
                }
            }
            
            guard let arrival = arrivalTextField.textField.text, !arrival.isEmpty,
                  let departure = departureTextField.textField.text, !departure.isEmpty,
                  studentDriverButton.isSelected || taxiButton.isSelected
            else { return }
            
            NetworkManager.shared.currentRide.type = studentDriverButton.isSelected ? "Student Driver" : "Shared Taxi"
            if let arrival = arrivalTextField.textField.text,
               let departure = departureTextField.textField.text,
               let arrivalID = arrivalLocationID,
               let departureID = departureLocationID {
                NetworkManager.shared.currentRide.path.endLocationPlaceId = arrivalID
                NetworkManager.shared.currentRide.path.endLocationName = arrival
                NetworkManager.shared.currentRide.path.startLocationName = departure
                NetworkManager.shared.currentRide.path.startLocationPlaceId = departureID
            }
            
            setupBackButton()
            delegate?.didTapNext(navCtrl, nextViewController: nil)
        }
        
        setupNextButton(action: nextAction ?? UIAction(handler: { _ in
            return
        }))
        
        setupTitleLabel()
        setupStudentDriverButton()
        setupTaxiButton()
        setupDepartureTextField()
        setupArrivalTextField()
        setupBackButton()
        backButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
    }
    
    // MARK: - Setup View Functions
    
    private func setupTitleLabel () {
        titleLabel.font = UIFont(name: "Rambla-Regular", size: 16)
        titleLabel.text = "TRANSPORTATION METHOD"
        titleLabel.accessibilityLabel = "preferred contact method"
        titleLabel.textColor = .black
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(32)
            make.top.equalToSuperview().inset(237)
            make.height.equalTo(20)
            make.trailing.equalToSuperview()
        }
    }
    
    private func setupStudentDriverButton() {
        studentDriverButton.isSelected = true
        studentDriverButton.setTitle("Student driver", for: .normal)
        studentDriverButton.setTitleColor(.black, for: .normal)
        studentDriverButton.titleLabel?.font = UIFont(name: "SFPro", size: 16)
        studentDriverButton.titleLabel?.adjustsFontSizeToFitWidth = true
        studentDriverButton.setImage(UIImage(systemName: "circle"), for: .normal)
        studentDriverButton.setImage(UIImage(systemName: "circle.inset.filled"), for: .selected)
        studentDriverButton.tintColor = .black
        studentDriverButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        studentDriverButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        studentDriverButton.addTarget(self, action: #selector(studentDriverButtonToggle), for: .touchUpInside)
        view.addSubview(studentDriverButton)
        
        studentDriverButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalTo(titleLabel.snp.leading)
            make.width.equalTo(156)
        }
    }
    
    private func setupTaxiButton() {
        taxiButton.isSelected = false
        taxiButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        taxiButton.setTitle("Shared Taxi", for: .normal)
        taxiButton.setTitleColor(.black, for: .normal)
        taxiButton.titleLabel?.font = UIFont(name: "SFPro", size: 16)
        taxiButton.titleLabel?.adjustsFontSizeToFitWidth = true
        taxiButton.setImage(UIImage(systemName: "circle"), for: .normal)
        taxiButton.setImage(UIImage(systemName: "circle.inset.filled"), for: .selected)
        taxiButton.tintColor = .black
        taxiButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        taxiButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        taxiButton.addTarget(self, action: #selector(taxiButtonToggle), for: .touchUpInside)
        view.addSubview(taxiButton)
        
        taxiButton.snp.makeConstraints { make in
            make.top.equalTo(studentDriverButton.snp.bottom).offset(20)
            make.leading.equalTo(studentDriverButton)
            make.width.equalTo(136)
        }
    }
    
    private func setupDepartureTextField() {
        let labelFont = UIFont(name: "Rambla-Regular", size: 16)
        let textFieldHeight = 56
        
        let departureLabel = UILabel()
        departureLabel.text = "Departure"
        departureLabel.font = labelFont
        departureLabel.accessibilityLabel = "name"
        departureLabel.textColor = UIColor.scooped.offBlack

        departureTextField.delegate = self
        departureTextField.setup(title: "Departure location")
        departureTextField.textField.addTarget(self, action: #selector(presentDepartureSearch), for: .touchDown)
        
        // Sets up the icon inside the text field.
        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 15))
        let departureIcon = UIImageView(frame: CGRect(x: 10, y: -2.5, width: 20, height: 20))
        departureIcon.image = UIImage(named: "locationIcon")
        departureIcon.contentMode = .scaleAspectFit
        iconContainer.addSubview(departureIcon)
        
        departureTextField.textField.leftView = iconContainer;
        departureTextField.textField.leftViewMode = UITextField.ViewMode.always
        departureTextField.textField.leftViewMode = .always
        view.addSubview(departureTextField)
        
        departureTextField.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(taxiButton.snp.bottom).offset(36)
            make.trailing.equalToSuperview().inset(32)
            make.height.equalTo(textFieldHeight)
        }
    }
    
    private func setupArrivalTextField() {
        let labelFont = UIFont(name: "Rambla-Regular", size: 16)
        let textFieldHeight = 56
        
        let arrivalLabel = UILabel()
        arrivalLabel.text = "Departure"
        arrivalLabel.font = labelFont
        arrivalLabel.accessibilityLabel = "name"
        arrivalLabel.textColor = UIColor.scooped.offBlack

        arrivalTextField.delegate = self
        arrivalTextField.setup(title: "Arrival location")

        // Sets up the icon inside the text field.
        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 15))
        let arrivalIcon = UIImageView(frame: CGRect(x: 10, y: -2.5, width: 20, height: 20))
        arrivalIcon.image = UIImage(named: "destinationIcon")
        arrivalIcon.contentMode = .scaleAspectFit
        iconContainer.addSubview(arrivalIcon)
        
        arrivalTextField.textField.leftView = iconContainer;
        arrivalTextField.textField.leftViewMode = .always
        arrivalTextField.textField.addTarget(self, action: #selector(presentArrivalSearch), for: .touchDown)
        view.addSubview(arrivalTextField)
        
        arrivalTextField.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(departureTextField.snp.bottom).offset(24)
            make.trailing.equalToSuperview().inset(32)
            make.height.equalTo(textFieldHeight)
        }
    }
    
    // MARK: - Helper Functions
    
    @objc private func studentDriverButtonToggle() {
        if taxiButton.isSelected {
            taxiButton.isSelected.toggle()
        }
        studentDriverButton.isSelected.toggle()
    }
    
    @objc private func taxiButtonToggle() {
        if studentDriverButton.isSelected {
            studentDriverButton.isSelected.toggle()
        }
        taxiButton.isSelected.toggle()
    }
    
    @objc private func presentDepartureSearch() {
        let departureVC = DepartureSearchViewController()
        departureVC.delegate = self
        navigationController?.pushViewController(departureVC, animated: true)
    }
    
    @objc private func presentArrivalSearch() {
        let arrivalVC = ArrivalSearchViewController()
        arrivalVC.delegate = self
        navigationController?.pushViewController(arrivalVC, animated: true)
    }
    
    @objc private func dismissView() {
        containerDelegate?.navigationController?.popViewController(animated: true)
    }
    
    private func checkButtonStatus() {
        var responses: [String] = []
        [arrivalTextField, departureTextField].forEach { textField in
            responses.append(textField.textField.text ?? "")
        }
        
        setNextButtonColor(disabled: !textFieldsComplete(texts: responses))
    }
    
}

// MARK: - SearchInitialViewControllerDelegate

extension InitialPostRideViewController: SearchInitialViewControllerDelegate {
    
    func didSelectLocation(viewController: UIViewController, location: GMSPlace) {
        if viewController is DepartureSearchViewController {
            departureTextField.textField.text = location.name
            departureLocationID = location.placeID
            departureTextField.hidesLabel(isHidden: false)
            departureTextField.hideError()
        } else if viewController is ArrivalSearchViewController {
            arrivalTextField.textField.text = location.name
            arrivalLocationID = location.placeID
            arrivalTextField.hidesLabel(isHidden: false)
            arrivalTextField.hideError()
        }
        
        checkButtonStatus()
    }
    
}

// MARK: - UITextFieldDelegate

extension InitialPostRideViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let onboardingTextField = textField as? OnboardingTextField,
           let associatedView = onboardingTextField.associatedView as? LabeledTextField {
            associatedView.labeledTextField(isSelected: true)
            associatedView.hidesLabel(isHidden: false)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let onboardingTextField = textField as? OnboardingTextField,
           let associatedView = onboardingTextField.associatedView as? LabeledTextField {
            associatedView.labeledTextField(isSelected: false)
            if textField.text?.isEmpty ?? true {
                associatedView.hidesLabel(isHidden: true)
            }
        }

        var responses: [String] = []
        [departureTextField, arrivalTextField].forEach { textField in
            responses.append(textField.textField.text ?? "")
        }

        setNextButtonColor(disabled: !textFieldsComplete(texts: responses))
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let onboardingTextField = textField as? OnboardingTextField,
           let associatedView = onboardingTextField.associatedView as? LabeledTextField {
            associatedView.labeledTextField(isSelected: true)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
}
