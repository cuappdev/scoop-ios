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
    
    private let arrivalLabel = UILabel()
    private let arrivalTextField = ShiftedRightTextField()
    private let departureLabel = UILabel()
    private let departureTextField = ShiftedRightTextField()
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
        
        nextAction = UIAction { _ in
            guard let navCtrl = self.navigationController else {
                return
            }
            
            guard let arrival = self.arrivalTextField.text, !arrival.isEmpty,
                  let departure = self.departureTextField.text, !departure.isEmpty,
                  self.studentDriverButton.isSelected || self.taxiButton.isSelected
            else {
                self.presentErrorAlert(title: "Error", message: "Please complete all fields.")
                return
            }
            
            NetworkManager.shared.currentRide.type = self.studentDriverButton.isSelected ? "Student Driver" : "Shared Taxi"
            if let arrival = self.arrivalTextField.text,
               let departure = self.departureTextField.text,
               let arrivalID = self.arrivalLocationID,
               let departureID = self.departureLocationID {
                NetworkManager.shared.currentRide.path.endLocationPlaceId = arrivalID
                NetworkManager.shared.currentRide.path.endLocationName = arrival
                NetworkManager.shared.currentRide.path.startLocationName = departure
                NetworkManager.shared.currentRide.path.startLocationPlaceId = departureID
            }
            
            self.setupBackButton()
            self.delegate?.didTapNext(navCtrl, nextViewController: nil)
        }
        
        setupNextButton(action: nextAction ?? UIAction(handler: { _ in
            return
        }))
        
        setupTitleLabel()
        setupStudentDriverButton()
        setupTaxiButton()
        setupDepartureTextField()
        setupArrivalTextField()
        setupLabels()
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
        let textFieldBorderWidth = 1.0
        let textFieldCornerRadius = 8.0
        let textFieldFont = UIFont(name: "SFPro", size: 16)
        
        let departureLabel = UILabel()
        departureLabel.text = "Departure"
        departureLabel.font = labelFont
        departureLabel.accessibilityLabel = "name"
        departureLabel.textColor = UIColor.scooped.offBlack
        
        departureTextField.layer.borderWidth = textFieldBorderWidth
        departureTextField.layer.borderColor = UIColor.scooped.textFieldBorderColor.cgColor
        departureTextField.layer.cornerRadius = textFieldCornerRadius
        departureTextField.font = textFieldFont
        departureTextField.textColor = .darkGray
        departureTextField.attributedPlaceholder = NSAttributedString(string:"Departure location", attributes: [NSAttributedString.Key.foregroundColor: UIColor.scooped.offBlack])
        departureTextField.addTarget(self, action: #selector(presentDepartureSearch), for: .touchDown)
        
        // Sets up the icon inside the text field.
        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 15))
        let departureIcon = UIImageView(frame: CGRect(x: 10, y: -2.5, width: 20, height: 20))
        departureIcon.image = UIImage(named: "locationIcon")
        departureIcon.contentMode = .scaleAspectFit
        iconContainer.addSubview(departureIcon)
        
        departureTextField.leftView = iconContainer;
        departureTextField.leftViewMode = UITextField.ViewMode.always
        departureTextField.leftViewMode = .always
        view.addSubview(departureTextField)
        
        departureTextField.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(taxiButton.snp.bottom).offset(24)
            make.trailing.equalToSuperview().inset(32)
        }
    }
    
    private func setupArrivalTextField() {
        let labelFont = UIFont(name: "Rambla-Regular", size: 16)
        let textFieldBorderWidth = 1.0
        let textFieldCornerRadius = 8.0
        let textFieldFont = UIFont(name: "SFPro", size: 16)
        
        let arrivalLabel = UILabel()
        arrivalLabel.text = "Departure"
        arrivalLabel.font = labelFont
        arrivalLabel.accessibilityLabel = "name"
        arrivalLabel.textColor = UIColor.scooped.offBlack
        
        arrivalTextField.textColor = .darkGray
        arrivalTextField.layer.borderWidth = textFieldBorderWidth
        arrivalTextField.layer.borderColor = UIColor.scooped.textFieldBorderColor.cgColor
        arrivalTextField.layer.cornerRadius = textFieldCornerRadius
        arrivalTextField.font = textFieldFont
        arrivalTextField.attributedPlaceholder = NSAttributedString(string:"Arrival location", attributes: [NSAttributedString.Key.foregroundColor: UIColor.scooped.offBlack])
        // Sets up the icon inside the text field.
        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 15))
        let arrivalIcon = UIImageView(frame: CGRect(x: 10, y: -2.5, width: 20, height: 20))
        arrivalIcon.image = UIImage(named: "destinationIcon")
        arrivalIcon.contentMode = .scaleAspectFit
        iconContainer.addSubview(arrivalIcon)
        
        arrivalTextField.leftView = iconContainer;
        arrivalTextField.leftViewMode = .always
        arrivalTextField.addTarget(self, action: #selector(presentArrivalSearch), for: .touchDown)
        view.addSubview(arrivalTextField)
        
        arrivalTextField.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(departureTextField.snp.bottom).offset(24)
            make.trailing.equalToSuperview().inset(32)
        }
    }
    
    private func setupLabels() {
        let labelLeading = 10
        let labelTop = 8
        [departureLabel, arrivalLabel].forEach { label in
            label.font = .systemFont(ofSize: 12)
            label.textColor = UIColor.scooped.scoopDarkGreen
            label.backgroundColor = .white
            label.textAlignment = .center
            label.isHidden = true
            view.addSubview(label)
        }
        
        departureLabel.text = "Departure"
        arrivalLabel.text = "Arrival"
        
        departureLabel.snp.makeConstraints { make in
            make.top.equalTo(departureTextField).inset(-labelTop)
            make.leading.equalTo(departureTextField).inset(labelLeading)
            make.height.equalTo(16)
            make.width.equalTo(65)
        }
        
        arrivalLabel.snp.makeConstraints { make in
            make.top.equalTo(arrivalTextField).inset(-labelTop)
            make.leading.equalTo(arrivalTextField).inset(labelLeading)
            make.height.equalTo(16)
            make.width.equalTo(40)
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
            responses.append(textField.text ?? "")
        }
        
        setNextButtonColor(disabled: !textFieldsComplete(texts: responses))
    }
    
}

// MARK: - SearchInitialViewControllerDelegate

extension InitialPostRideViewController: SearchInitialViewControllerDelegate {
    
    func didSelectLocation(viewController: UIViewController, location: GMSPlace) {
        if viewController is DepartureSearchViewController {
            departureTextField.text = location.name
            departureLocationID = location.placeID
            departureLabel.textColor = UIColor.scooped.offBlack
            departureLabel.isHidden = false
        } else if viewController is ArrivalSearchViewController {
            arrivalTextField.text = location.name
            arrivalLocationID = location.placeID
            arrivalLabel.textColor = UIColor.scooped.offBlack
            arrivalLabel.isHidden = false
        }
        
        checkButtonStatus()
    }
    
}
