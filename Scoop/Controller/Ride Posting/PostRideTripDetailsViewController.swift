//
//  PostRideTripDetailsViewController.swift
//  Scoop
//
//  Created by Richie Sun on 3/18/23.
//

import UIKit

class PostRideTripDetailsViewController: PostRideViewController {
    
    private let textFieldHeight = 56
    private let textFieldBorderWidth = 1.0
    private let textFieldCornerRadius = 4.0
    private let textFieldFont = UIFont(name: "SFPro", size: 16)
    private let iconSize = 24
    private let iconSpacing = 12
    
    private let stackView = UIStackView()
    
    private let dateTextField = OnboardingTextField()
    private let datePicker = UIDatePicker()
    private let calendarIcon = UIImageView()
    private let requiredLabel = UILabel()
    
    private let timeTextField = OnboardingTextField()
    private let timePicker = UIDatePicker()
    
    private let travelersLabel = UILabel()
    private let minTextField = OnboardingTextField()
    private let maxTextField = OnboardingTextField()
    private let travelersContainerView = UIView()
    
    private let detailsExample = UILabel()
    private let detailsTextField = UITextView()
    
    private let dateLabel = UILabel()
    private let timeLabel = UILabel()
    private let minLabel = UILabel()
    private let maxLabel = UILabel()
    private let detailsLabel = UILabel()
    
    
    private var ride: Ride!
    
    init(ride: Ride) {
        super.init(nibName: nil, bundle: nil)
        self.ride = ride
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        nextAction = UIAction { _ in
            guard let navCtrl = self.navigationController else { return }
            
            guard let travelerCountLowerText = self.minTextField.text,
                  let travelerCountUpperText = self.maxTextField.text else {
                      self.presentErrorAlert(title: "Error", message: "Please complete all fields.")
                      return
                  }
            
            guard let travelerCountLower = Int(travelerCountLowerText),
                  let travelerCountUpper = Int(travelerCountUpperText),
                  travelerCountLower <= travelerCountUpper,
                  let date = self.getTravelDate() else {
                      self.presentErrorAlert(title: "Error", message: "Please enter valid input.")
                      return
                  }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M/dd/yy @ h:mm a"
            
            NetworkManager.shared.currentRide.minTravelers = travelerCountLower
            NetworkManager.shared.currentRide.maxTravelers = travelerCountUpper
            NetworkManager.shared.currentRide.departureDatetime = dateFormatter.string(from: date)
            NetworkManager.shared.currentRide.description = self.detailsTextField.text ?? ""
            
            self.delegate?.didTapNext(navCtrl, nextViewController: nil)
        }
        
        setupStackView()
        setupDateView()
        setupTimeView()
        setupTravelersView()
        setupDetailsView()
        setupLabels()
        configTextFields()
        setupNextButton(action: nextAction ?? UIAction(handler: { _ in
            return
        }))
    }
    
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
            make.height.equalTo(88)
        }
        
        stackView.addArrangedSubview(detailsTextField)
        
    }
    
    private func setupDateView() {
        dateTextField.delegate = self
        dateTextField.textColor = .offBlack
        dateTextField.backgroundColor = .white
        dateTextField.attributedPlaceholder = NSAttributedString(
            string: "Departure date",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.offBlack])
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.isHighlighted = false
        datePicker.addTarget(self, action: #selector(updateDate), for: .valueChanged)
        dateTextField.inputView = datePicker
        
        dateTextField.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
        }
        
        calendarIcon.image = UIImage(named: "calendarIcon")
        calendarIcon.contentMode = .scaleAspectFit
        view.addSubview(calendarIcon)
        
        calendarIcon.snp.makeConstraints { make in
            make.centerY.equalTo(dateTextField)
            make.trailing.equalTo(dateTextField).inset(iconSpacing)
            make.size.equalTo(iconSize)
        }
        
        requiredLabel.text = "*required"
        requiredLabel.font = UIFont(name: "Roboto", size: 12)
        requiredLabel.textColor = .offBlack
        view.addSubview(requiredLabel)
        
        requiredLabel.snp.makeConstraints { make in
            make.leading.equalTo(dateTextField).inset(10)
            make.top.equalTo(dateTextField.snp.bottom).inset(-4)
        }
    }
    
    private func setupTimeView() {
        timeTextField.delegate = self
        timeTextField.textColor = .offBlack
        timeTextField.attributedPlaceholder = NSAttributedString(
            string: "Departure time",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.offBlack])
        timeTextField.inputView = timePicker
        timePicker.datePickerMode = .time
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.addTarget(self, action: #selector(updateTime), for: .valueChanged)
        
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
        minTextField.textColor = .offBlack
        minTextField.attributedPlaceholder = NSAttributedString(
            string: "Minimum",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.offBlack])
        minTextField.keyboardType = .numberPad
        travelersContainerView.addSubview(minTextField)
        
        minTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.equalTo((stackViewWidth - 15.0)/2)
            make.height.equalTo(textFieldHeight)
            make.top.equalTo(travelersLabel.snp.bottom).inset(-8)
        }
        
        maxTextField.delegate = self
        maxTextField.textColor = .offBlack
        maxTextField.attributedPlaceholder = NSAttributedString(
            string: "Maximum",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.offBlack])
        maxTextField.keyboardType = .numberPad
        travelersContainerView.addSubview(maxTextField)
        
        maxTextField.snp.makeConstraints { make in
            make.leading.equalTo(minTextField.snp.trailing).inset(-15)
            make.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
            make.top.equalTo(travelersLabel.snp.bottom).inset(-8)
        }
    }
    
    private func setupDetailsView() {
        detailsTextField.delegate = self
        detailsTextField.text = "Details"
        detailsTextField.textContainerInset = UIEdgeInsets(top: 18.5, left: 16, bottom: 18.5, right: 16)
        detailsTextField.textColor = .black
        detailsTextField.layer.borderWidth = textFieldBorderWidth
        detailsTextField.layer.borderColor = UIColor.textFieldBorderColor.cgColor
        detailsTextField.layer.cornerRadius = textFieldCornerRadius
        detailsTextField.font = .systemFont(ofSize: 16)
        
        detailsTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(textFieldHeight)
        }
        
        detailsExample.text = "ie. splitting gas, departure time, etc."
        detailsExample.font = UIFont(name: "Roboto", size: 12)
        detailsExample.textColor = .offBlack
        view.addSubview(detailsExample)
        
        detailsExample.snp.makeConstraints { make in
            make.leading.equalTo(detailsTextField).inset(10)
            make.top.equalTo(detailsTextField.snp.bottom).inset(-4)
        }
    }
    
    private func configTextFields() {
        [dateTextField, timeTextField, minTextField, maxTextField].forEach { text in
            text.layer.borderWidth = textFieldBorderWidth
            text.layer.borderColor = UIColor.textFieldBorderColor.cgColor
            text.layer.cornerRadius = textFieldCornerRadius
            text.font = textFieldFont
        }
    }
    
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
    
    private func setupLabels() {
        let labelLeading = 10
        let labelTop = 8
        [dateLabel, timeLabel, minLabel, maxLabel, detailsLabel].forEach { label in
            label.font = .systemFont(ofSize: 12)
            label.textColor = .scoopDarkGreen
            label.backgroundColor = .white
            label.textAlignment = .center
            label.isHidden = true
            view.addSubview(label)
        }
        
        dateLabel.text = "Departure date"
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(dateTextField).inset(-labelTop)
            make.leading.equalTo(dateTextField).inset(labelLeading)
            make.height.equalTo(16)
            make.width.equalTo(91)
        }
        
        timeLabel.text = "Departure time"
        timeLabel.snp.makeConstraints { make in
            make.top.equalTo(timeTextField).inset(-labelTop)
            make.leading.equalTo(timeTextField).inset(labelLeading)
            make.height.equalTo(16)
            make.width.equalTo(91)
        }
        
        minLabel.text = "Minimum"
        minLabel.snp.makeConstraints { make in
            make.top.equalTo(minTextField).inset(-labelTop)
            make.leading.equalTo(minTextField).inset(labelLeading)
            make.height.equalTo(16)
            make.width.equalTo(54)
        }
        
        maxLabel.text = "Maximum"
        maxLabel.snp.makeConstraints { make in
            make.top.equalTo(maxTextField).inset(-labelTop)
            make.leading.equalTo(maxTextField).inset(labelLeading)
            make.height.equalTo(16)
            make.width.equalTo(57)
        }
        
        detailsLabel.text = "Details"
        detailsLabel.snp.makeConstraints { make in
            make.top.equalTo(detailsTextField).inset(-labelTop)
            make.leading.equalTo(detailsTextField).inset(labelLeading)
            make.height.equalTo(16)
            make.width.equalTo(42)
        }
    }
    
    @objc private func updateDate() {
        print("click")
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateTextField.text = dateFormatter.string(from: datePicker.date)
    }
    
    @objc private func updateTime() {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        timeTextField.text = timeFormatter.string(from: timePicker.date)
    }
    
}

extension PostRideTripDetailsViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == maxTextField || textField == minTextField {
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
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.scoopDarkGreen.cgColor
        textField.placeholder = ""
        if textField == dateTextField {
            dateLabel.textColor = .scoopDarkGreen
            dateLabel.isHidden = false
        } else if textField == timeTextField {
            timeLabel.textColor = .scoopDarkGreen
            timeLabel.isHidden = false
        } else if textField == maxTextField {
            maxLabel.textColor = .scoopDarkGreen
            maxLabel.isHidden = false
        } else {
            minLabel.textColor = .scoopDarkGreen
            minLabel.isHidden = false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.textFieldBorderColor.cgColor
        if textField == dateTextField {
            dateLabel.textColor = .textFieldBorderColor
        } else if textField == timeTextField {
            timeLabel.textColor = .textFieldBorderColor
        } else if textField == maxTextField {
            maxLabel.textColor = .textFieldBorderColor
        } else {
            minLabel.textColor = .textFieldBorderColor
        }
    }
    
}

extension PostRideTripDetailsViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.black {
                textView.text = nil
                textView.textColor = UIColor.offBlack
            }
        textView.layer.borderWidth = 2
        textView.layer.borderColor = UIColor.scoopDarkGreen.cgColor
        detailsLabel.textColor = .scoopDarkGreen
        detailsLabel.isHidden = false
        
        textView.snp.removeConstraints()
        textView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(82)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.textFieldBorderColor.cgColor
        detailsLabel.textColor = .textFieldBorderColor
    }
    
}
