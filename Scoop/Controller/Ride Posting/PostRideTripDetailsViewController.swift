//
//  PostRideTripDetailsViewController.swift
//  Scoop
//
//  Created by Richie Sun on 3/18/23.
//

import UIKit

protocol PostRideDelegate {
    func updateSummary()
}

class PostRideTripDetailsViewController: PostRideViewController {
    
    var summaryDelegate: PostRideDelegate?
    
    private let textFieldHeight = 56
    private let textFieldBorderWidth = 1.0
    private let textFieldCornerRadius = 4.0
    private let textFieldFont = UIFont(name: "SFPro", size: 16)
    private let iconSize = 24
    private let iconSpacing = 12
    
    // MARK: - Views
    
    private let stackView = UIStackView()
    
    private let dateTextField = LabeledTextField()
    private let datePicker = UIDatePicker()
    private let calendarIcon = UIImageView()
    
    private let timeTextField = LabeledTextField()
    private let timePicker = UIDatePicker()
    
    private let travelersLabel = UILabel()
    private let minMaxLabel = UILabel()
    private let minTextField = LabeledTextField()
    private let maxTextField = LabeledTextField()
    private let travelersContainerView = UIView()
    
    private let detailsExample = UILabel()
    private let detailsTextField = LabeledTextView()
    
    private var ride: Ride!
    
    // MARK: - Initializers
    
    init(ride: Ride) {
        super.init(nibName: nil, bundle: nil)
        self.ride = ride
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        nextAction = UIAction { [self ]_ in
            guard let navCtrl = navigationController else { return }

            [dateTextField, timeTextField, minTextField, maxTextField].forEach { textField in
                if (textField.textField.text ?? "").isEmpty {
                    textField.displayError()
                }
            }
            
            guard let travelerCountLowerText = minTextField.textField.text, !travelerCountLowerText.isEmpty,
                  let travelerCountUpperText = maxTextField.textField.text, !travelerCountUpperText.isEmpty else { return }
            
            guard let travelerCountLower = Int(travelerCountLowerText),
                  let travelerCountUpper = Int(travelerCountUpperText),
                  travelerCountLower <= travelerCountUpper,
                  let date = getTravelDate() else {
                minTextField.displayError()
                maxTextField.displayError()
                minTextField.errorLabel.isHidden = true
                maxTextField.errorLabel.isHidden = true
                minMaxLabel.text = "The minimum must be less than the maximum"
                minMaxLabel.isHidden = false
                return
            }

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            
            if travelerCountLower == 0 {
                minTextField.displayError()
                maxTextField.displayError()
                minTextField.errorLabel.isHidden = true
                maxTextField.errorLabel.isHidden = true
                minMaxLabel.text = "You cannot have a minimum of 0 travelers!"
                minMaxLabel.isHidden = false
            } else {
                NetworkManager.shared.currentRide.minTravelers = travelerCountLower
                NetworkManager.shared.currentRide.maxTravelers = travelerCountUpper
                NetworkManager.shared.currentRide.departureDatetime = dateFormatter.string(from: date)
                NetworkManager.shared.currentRide.description = detailsTextField.textView.text ?? ""
                
                delegate?.didTapNext(navCtrl, nextViewController: nil)
            }
            
            summaryDelegate?.updateSummary()
        }
        
        setupStackView()
        setupDateView()
        setupTimeView()
        setupTravelersView()
        setupDetailsView()
        setupNextButton(action: nextAction ?? UIAction(handler: { _ in
            return
        }))
    }
    
    // MARK: - Setup View Functions
    
    private func setupStackView() {
        let stackViewMultiplier = 0.1
        let leadingTrailingInset = 32
        let screenSize = UIScreen.main.bounds
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 38
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingTrailingInset)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(stackViewMultiplier * screenSize.height)
        }
        
        stackView.addArrangedSubview(dateTextField)
        stackView.addArrangedSubview(timeTextField)
        stackView.addArrangedSubview(travelersContainerView)
        
        travelersContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        
        stackView.addArrangedSubview(detailsTextField)
    }
    
    private func setupDateView() {
        dateTextField.delegate = self
        dateTextField.setup(title: "Departure date")
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minimumDate = Date()
        datePicker.isHighlighted = false
        datePicker.addTarget(self, action: #selector(updateDate), for: .valueChanged)
        dateTextField.textField.addTarget(self, action: #selector(updateDate), for: .touchDown)
        dateTextField.textField.inputView = datePicker
        
        dateTextField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
        }
        
        calendarIcon.image = UIImage(named: "calendarIcon")
        calendarIcon.contentMode = .scaleAspectFit
        view.addSubview(calendarIcon)
        
        calendarIcon.snp.makeConstraints { make in
            make.centerY.equalTo(dateTextField.textField)
            make.trailing.equalTo(dateTextField).inset(iconSpacing)
            make.size.equalTo(iconSize)
        }
    }
    
    private func setupTimeView() {
        timeTextField.delegate = self
        timeTextField.setup(title: "Departure time")
        timeTextField.textField.inputView = timePicker
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.addTarget(self, action: #selector(updateTime), for: .valueChanged)
        timeTextField.textField.addTarget(self, action: #selector(updateTime), for: .touchDown)
        
        timeTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
        }
    }
    
    private func setupTravelersView() {
        let stackViewWidth = UIScreen.main.bounds.width - 64.0
        
        travelersLabel.text = "NUMBER OF TRAVELERS"
        travelersLabel.font = UIFont(name: "Rambla-Regular", size: 16)
        travelersContainerView.addSubview(travelersLabel)
        
        travelersLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        minTextField.delegate = self
        minTextField.setup(title: "Minimum", error: "Please complete")
        minTextField.textField.keyboardType = .numberPad
        travelersContainerView.addSubview(minTextField)
        
        minTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(travelersLabel.snp.bottom).offset(24)
            make.width.equalTo((stackViewWidth - 15.0)/2)
            make.height.equalTo(textFieldHeight)
        }
        
        maxTextField.delegate = self
        maxTextField.setup(title: "Maximum", error: "Please complete")
        maxTextField.textField.keyboardType = .numberPad
        travelersContainerView.addSubview(maxTextField)
        
        maxTextField.snp.makeConstraints { make in
            make.top.equalTo(minTextField)
            make.leading.equalTo(minTextField.snp.trailing).inset(-15)
            make.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
        }

        minMaxLabel.text = "The minimum must be less than the maximum"
        minMaxLabel.font = .systemFont(ofSize: 12)
        minMaxLabel.textColor = UIColor.scooped.errorRed
        minMaxLabel.isHidden = true
        travelersContainerView.addSubview(minMaxLabel)

        minMaxLabel.snp.makeConstraints { make in
            make.leading.equalTo(minTextField).inset(10)
            make.top.equalTo(minTextField.snp.bottom).offset(-5)
            make.bottom.equalToSuperview()
        }
    }
    
    private func setupDetailsView() {
        detailsTextField.delegate = self
        detailsTextField.setup(title: "Details")
        
        detailsTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(82)
        }
        
        detailsExample.text = "ie. splitting gas, departure time, etc."
        detailsExample.font = UIFont(name: "Roboto", size: 12)
        detailsExample.textColor = UIColor.scooped.offBlack
        view.addSubview(detailsExample)
        
        detailsExample.snp.makeConstraints { make in
            make.leading.equalTo(detailsTextField).inset(10)
            make.top.equalTo(detailsTextField.snp.bottom).inset(-4)
        }
    }

    // MARK: - Helper Functions
    
    private func getTravelDate() -> Date? {
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: datePicker.date)
        
        let timeComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: timePicker.date)
        
        var mergedComponents = DateComponents()
        mergedComponents.year = dateComponents.year
        mergedComponents.month = dateComponents.month
        mergedComponents.day = dateComponents.day
        mergedComponents.hour = timeComponents.hour
        mergedComponents.minute = timeComponents.minute
        mergedComponents.second = timeComponents.second
        
        return Calendar.current.date(from: mergedComponents)
    }
    
    @objc private func updateDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateTextField.textField.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc private func updateTime() {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        timeTextField.textField.text = timeFormatter.string(from: timePicker.date)
    }
    
}

// MARK: - UITextFieldDelegate

extension PostRideTripDetailsViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == maxTextField.textField || textField == minTextField.textField {
            let numOnly = CharacterSet.decimalDigits
            let characters = CharacterSet(charactersIn: string)
            // Source: https://stackoverflow.com/a/31363255/5278889
            let maxLength = 1
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength && numOnly.isSuperset(of: characters)
        } else {
            return false
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let onboardingTextField = textField as? OnboardingTextField,
           let associatedView = onboardingTextField.associatedView as? LabeledTextField {
            associatedView.labeledTextField(isSelected: true)
            associatedView.hidesLabel(isHidden: false)
        }

        if textField == minTextField.textField || textField == maxTextField.textField {
            minMaxLabel.isHidden = true
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
        [dateTextField, timeTextField, minTextField, maxTextField, ].forEach { textField in
            responses.append(textField.textField.text ?? "")
        }

        setNextButtonColor(disabled: !textFieldsComplete(texts: responses))
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let onboardingTextField = textField as? OnboardingTextField,
           let associatedView = onboardingTextField.associatedView as? LabeledTextField {
            associatedView.labeledTextField(isSelected: true)
        }

        if textField == minTextField.textField || textField == maxTextField.textField {
            minMaxLabel.isHidden = true
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
    
}

// MARK: - UITextViewDelegate

extension PostRideTripDetailsViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let paddedTextView = textView as? PaddedTextView,
           let associatedView = paddedTextView.associatedView as? LabeledTextView {
            associatedView.labeledTextView(isSelected: true)
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if let paddedTextView = textView as? PaddedTextView,
           let associatedView = paddedTextView.associatedView as? LabeledTextView {
            associatedView.labeledTextView(isSelected: false)
        }
    }
    
}
