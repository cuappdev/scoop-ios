//
//  SearchRidesViewController.swift
//  Scoop
//
//  Created by Richie Sun on 4/7/23.
//

import GooglePlaces
import UIKit

class SearchRidesViewController: UIViewController {
    
    // MARK: - Views

    private let arrivalTextField = LabeledTextField(isShifted: true)
    private let calendarIconImageView = UIImageView()
    private let datePicker = UIDatePicker()
    private let departureDateTextField = LabeledTextField()
    private let departureTextField = LabeledTextField(isShifted: true)
    private let findTripsButton = UIButton()
    private let stackView = UIStackView()
    
    // MARK: - Data
    
    private var arrivalPlace: GMSPlace?
    private var departurePlace: GMSPlace?
    private var tripDate: String = ""
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tripDate = formatDate(dateToConvert: Date())
        
        setupHeader()
        setupStackView()
        setupLocationTextFields()
        setupButton()
    }
    
    // MARK: - Setup View Functions
    
    private func setupHeader() {
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
        
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Trip Details"
        navigationController?.navigationBar.titleTextAttributes = [.font: UIFont(name: "Sen-Regular", size: 24)]
    }
    
    private func setupStackView() {
        let screenSize = UIScreen.main.bounds
        let stackViewMultiplier = 0.15
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 24
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(stackViewMultiplier * screenSize.height)
            make.leading.trailing.equalToSuperview().inset(32)
        }
    }
    
    private func setupLocationTextFields() {
        let textFieldBorderWidth = 1.0
        let textFieldCornerRadius = 4.0
        let textFieldHeight = 56

        departureTextField.textField.delegate = self
        departureTextField.setup(title: "Departure location")

        // Sets up the icon inside the text field.
        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 15))
        let departureIcon = UIImageView(frame: CGRect(x: 10, y: -2.5, width: 20, height: 20))
        departureIcon.image = UIImage(named: "locationIcon")
        departureIcon.contentMode = .scaleAspectFit
        iconContainer.addSubview(departureIcon)

        departureTextField.textField.leftView = iconContainer;
        departureTextField.textField.leftViewMode = UITextField.ViewMode.always
        departureTextField.textField.leftViewMode = .always
        departureTextField.textField.addTarget(self, action: #selector(presentDepartureSearch), for: .touchDown)
        stackView.addArrangedSubview(departureTextField)

        arrivalTextField.textField.delegate = self
        arrivalTextField.setup(title: "Arrival location")
        
        // Sets up the icon inside the text field.
        let iconContainer2 = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 15))
        let arrivalIcon = UIImageView(frame: CGRect(x: 10, y: -2.5, width: 20, height: 20))
        arrivalIcon.image = UIImage(named: "destinationIcon")
        arrivalIcon.contentMode = .scaleAspectFit
        iconContainer2.addSubview(arrivalIcon)

        arrivalTextField.textField.leftView = iconContainer2;
        arrivalTextField.textField.leftViewMode = .always
        arrivalTextField.textField.addTarget(self, action: #selector(presentArrivalSearch), for: .touchDown)
        stackView.addArrangedSubview(arrivalTextField)

        departureDateTextField.delegate = self
        departureDateTextField.setup(title: "Departure date")
        departureDateTextField.textField.inputView = datePicker
        departureDateTextField.textField.addTarget(self, action: #selector(updateDate), for: .touchDown)
        departureDateTextField.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidEnd)
        stackView.addArrangedSubview(departureDateTextField)
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(updateDate), for: .valueChanged)
        
        calendarIconImageView.image = UIImage(named: "calendarIcon")
        calendarIconImageView.contentMode = .scaleAspectFit
        view.addSubview(calendarIconImageView)
        
        calendarIconImageView.snp.makeConstraints { make in
            make.centerY.equalTo(departureDateTextField.textField)
            make.trailing.equalTo(departureDateTextField).inset(12)
            make.size.equalTo(24)
        }
        
        [departureTextField, arrivalTextField, departureDateTextField].forEach { text in
            text.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(textFieldHeight)
            }
        }
    }
    
    private func setupButton() {
        findTripsButton.setTitle("Find Trips", for: .normal)
        findTripsButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        findTripsButton.backgroundColor = .black
        findTripsButton.layer.cornerRadius = 25
        findTripsButton.addTarget(self, action: #selector(presentMatches), for: .touchUpInside)
        findTripsButton.backgroundColor = UIColor.scooped.disabledGreen
        findTripsButton.setTitleColor(UIColor.scooped.disabledGrey, for: .normal)
        view.addSubview(findTripsButton)
                
        findTripsButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(40)
            make.width.equalTo(stackView.snp.width).inset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    // MARK: - Helper Functions
    
    @objc private func presentDepartureSearch() {
        let depatureVC = DepartureSearchViewController()
        depatureVC.delegate = self
        navigationController?.pushViewController(depatureVC, animated: true)
    }

    @objc private func presentArrivalSearch() {
        let arrivalVC = ArrivalSearchViewController()
        arrivalVC.delegate = self
        navigationController?.pushViewController(arrivalVC, animated: true)
    }
    
    @objc private func updateDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        departureDateTextField.textField.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc private func presentMatches() {
        findTripsButton.isEnabled = false

        [departureTextField, arrivalTextField, departureDateTextField].forEach { textField in
            if (textField.textField.text ?? "").isEmpty {
                textField.displayError()
            }
        }

        findTripsButton.backgroundColor = UIColor.scooped.disabledGreen
        guard let departure = self.departureTextField.textField.text, !departure.isEmpty,
              let arrival = self.arrivalTextField.textField.text, !arrival.isEmpty,
              let departureID = departurePlace?.placeID,
              let dateString = departureDateTextField.textField.text, !dateString.isEmpty,
              let arrivalID = arrivalPlace?.placeID else { return }
        
        tripDate = formatDate(dateToConvert: self.datePicker.date)
        NetworkManager.shared.searchLocation(depatureDate: tripDate, startLocation: departureID, endLocation: arrivalID) { [weak self] response in
            switch response {
            case .success(let response):
                guard let strongSelf = self else { return }
                let matchesVC = MatchesViewController(arrival: arrival, departure: departure, date: dateString, rides: response)
                matchesVC.hidesBottomBarWhenPushed = true
                strongSelf.navigationController?.pushViewController(matchesVC, animated: true)
                strongSelf.findTripsButton.isEnabled = true
                strongSelf.findTripsButton.backgroundColor = UIColor.scooped.scoopDarkGreen
            case .failure(let error):
                print("Error in SearchRidesVC: \(error)")
            }
        }
    }
    
    @objc func textFieldDidChange(sender: UITextField) {
        guard let text1 = departureTextField.textField.text,
              !text1.isEmpty,
              let text2 = arrivalTextField.textField.text,
              !text2.isEmpty,
              let text3 = departureDateTextField.textField.text,
              !text3.isEmpty else {
            findTripsButton.backgroundColor = UIColor.scooped.disabledGreen
            return
        }
        findTripsButton.backgroundColor = UIColor.scooped.scoopDarkGreen
        findTripsButton.setTitleColor(.white, for: .normal)
    }

    /// Converts a Date object into String format, where this one is specifically in the YYYY-MM-dd format.
    private func formatDate(dateToConvert: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        return dateFormatter.string(from: dateToConvert)
    }
    
}

// MARK: - UITextFieldDelegate

extension SearchRidesViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }

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
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let onboardingTextField = textField as? OnboardingTextField,
           let associatedView = onboardingTextField.associatedView as? LabeledTextField {
            associatedView.labeledTextField(isSelected: true)
        }
    }
    
}

// MARK: - SearchInitialViewControllerDelegate

extension SearchRidesViewController: SearchInitialViewControllerDelegate {

    func didSelectLocation(viewController: UIViewController, location: GMSPlace) {
        if viewController is DepartureSearchViewController {
            departurePlace = location
            departureTextField.textField.text = location.name
            self.textFieldDidChange(sender: departureTextField.textField)
            departureTextField.hidesLabel(isHidden: false)
            departureTextField.labeledTextField(isSelected: false)
        } else if viewController is ArrivalSearchViewController {
            arrivalPlace = location
            arrivalTextField.textField.text = location.name
            self.textFieldDidChange(sender: arrivalTextField.textField)
            arrivalTextField.hidesLabel(isHidden: false)
            arrivalTextField.labeledTextField(isSelected: false)
        }
    }

}

