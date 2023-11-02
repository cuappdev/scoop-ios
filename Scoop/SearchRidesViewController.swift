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
    
    private let arrivalLabel = UILabel()
    private let arrivalTextField = ImageTextField()
    private let calendarIconImageView = UIImageView()
    private let datePicker = UIDatePicker()
    private let departureDateLabel = UILabel()
    private let departureDateTextField = OnboardingTextField()
    private let departureLabel = UILabel()
    private let departureTextField = ImageTextField()
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
        setupLabels()
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
        
        departureTextField.textField.textColor = UIColor.scooped.offBlack
        departureTextField.textField.delegate = self
        departureTextField.textField.attributedPlaceholder = NSAttributedString(
            string: "Departure location",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.scooped.offBlack])
        departureTextField.textField.addTarget(self, action: #selector(presentDepartureSearch), for: .touchDown)
        departureTextField.imageView.image = UIImage(named: "locationIcon")
        stackView.addArrangedSubview(departureTextField)
        
        arrivalTextField.textField.textColor = UIColor.scooped.offBlack
        arrivalTextField.textField.delegate = self
        arrivalTextField.textField.attributedPlaceholder = NSAttributedString(
            string: "Arrival location",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.scooped.offBlack])
        arrivalTextField.textField.addTarget(self, action: #selector(presentArrivalSearch), for: .touchDown)
        arrivalTextField.imageView.image = UIImage(named: "destinationIcon")
        stackView.addArrangedSubview(arrivalTextField)
        
        departureDateTextField.textColor = UIColor.scooped.offBlack
        departureDateTextField.delegate = self
        departureDateTextField.attributedPlaceholder = NSAttributedString(
            string: "Departure date",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.scooped.offBlack])
        departureDateTextField.inputView = datePicker
        departureDateTextField.addTarget(self, action: #selector(updateDate), for: .touchDown)
        departureDateTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingDidEnd)
        stackView.addArrangedSubview(departureDateTextField)
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(updateDate), for: .valueChanged)
        
        calendarIconImageView.image = UIImage(named: "calendarIcon")
        calendarIconImageView.contentMode = .scaleAspectFit
        view.addSubview(calendarIconImageView)
        
        calendarIconImageView.snp.makeConstraints { make in
            make.centerY.equalTo(departureDateTextField)
            make.trailing.equalTo(departureDateTextField).inset(12)
            make.size.equalTo(24)
        }
        
        [departureTextField, arrivalTextField, departureDateTextField].forEach { text in
            text.layer.borderWidth = textFieldBorderWidth
            text.layer.borderColor = UIColor.scooped.textFieldBorderColor.cgColor
            text.layer.cornerRadius = textFieldCornerRadius
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
    
    private func setupLabels() {
        let labelLeading = 10
        let labelTop = 8
        
        [departureLabel, arrivalLabel, departureDateLabel].forEach { label in
            label.font = .systemFont(ofSize: 12)
            label.textColor = UIColor.scooped.textFieldBorderColor
            label.backgroundColor = .white
            label.textAlignment = .center
            label.isHidden = true
            view.addSubview(label)
        }
        
        departureLabel.text = "Departure location"
        departureLabel.snp.makeConstraints { make in
            make.top.equalTo(departureTextField).inset(-labelTop)
            make.leading.equalTo(departureTextField).inset(labelLeading)
            make.height.equalTo(16)
            make.width.equalTo(120)
        }
        
        arrivalLabel.text = "Arrival location"
        arrivalLabel.snp.makeConstraints { make in
            make.top.equalTo(arrivalTextField).inset(-labelTop)
            make.leading.equalTo(arrivalTextField).inset(labelLeading)
            make.height.equalTo(16)
            make.width.equalTo(99)
        }
        
        departureDateLabel.text = "Departure date"
        departureDateLabel.snp.makeConstraints { make in
            make.top.equalTo(departureDateTextField).inset(-labelTop)
            make.leading.equalTo(departureDateTextField).inset(labelLeading)
            make.height.equalTo(16)
            make.width.equalTo(99)
        }
    }
    
    // MARK: - Helper Functions
    
    @objc private func presentDepartureSearch() {
        let depatureVC = DepartureSearchViewController()
        depatureVC.delegate = self
        navigationController?.pushViewController(depatureVC, animated: true)
        departureLabel.isHidden = false
    }

    @objc private func presentArrivalSearch() {
        let arrivalVC = ArrivalSearchViewController()
        arrivalVC.delegate = self
        navigationController?.pushViewController(arrivalVC, animated: true)
        arrivalLabel.isHidden = false
    }
    
    @objc private func updateDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        departureDateTextField.text = dateFormatter.string(from: datePicker.date)
        departureDateLabel.isHidden = false
    }
    
    @objc private func presentMatches() {
        findTripsButton.isEnabled = false
        findTripsButton.backgroundColor = UIColor.scooped.disabledGreen
        guard let departure = self.departureTextField.textField.text, !departure.isEmpty,
              let arrival = self.arrivalTextField.textField.text, !arrival.isEmpty,
              let departureID = departurePlace?.placeID,
              let dateString = departureDateTextField.text, !dateString.isEmpty,
              let arrivalID = arrivalPlace?.placeID else {
                  presentErrorAlert(title: "Error", message: "Please complete all fields.")
                  return
              }
        
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
              let text3 = departureDateTextField.text,
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
    
}

// MARK: - SearchInitialViewControllerDelegate

extension SearchRidesViewController: SearchInitialViewControllerDelegate {

    func didSelectLocation(viewController: UIViewController, location: GMSPlace) {
        if viewController is DepartureSearchViewController {
            departurePlace = location
            departureTextField.textField.text = location.name
            self.textFieldDidChange(sender: departureTextField.textField)
        } else if viewController is ArrivalSearchViewController {
            arrivalPlace = location
            arrivalTextField.textField.text = location.name
            self.textFieldDidChange(sender: arrivalTextField.textField)
        }
    }

}

