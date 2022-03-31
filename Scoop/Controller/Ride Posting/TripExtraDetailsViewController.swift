//
//  TripExtraDetailsViewController.swift
//  Scoop
//
//  Created by Elvis Marcelo on 3/18/22.
//

import UIKit

class TripExtraDetailsViewController: UIViewController {
    
    private var containerView = UIView()
    
    private let travelersLabel = UILabel()
    private let toLabel = UILabel()
    private let count1TextField = UITextField()
    private let count2TextField = UITextField()
    private let peopleImageView = UIImageView()
    
    private let dateLabel = UILabel()
    private let datePicker = UIDatePicker()
    private let calendarImageView = UIImageView()
    
    private let timeLabel = UILabel()
    private let timePicker = UIDatePicker()
    private let clockImageView = UIImageView()
    
    private let detailsLabel = UILabel()
    private let detailsTextView = UITextView()
    
    private let labelSpace = 5
    private let fieldSpace = 40
    
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
        navigationItem.title = "Trip Details"
        
        let nextAction = UIAction { _ in
            guard let travelerCountLowerText = self.count1TextField.text,
                  let travelerCountUpperText = self.count2TextField.text else {
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
            
            self.ride.travelerCountLower = travelerCountLower
            self.ride.travelerCountUpper = travelerCountUpper
            self.ride.date = dateFormatter.string(from: date)
            self.ride.details = self.detailsTextView.textColor == .placeholderText ? "" : self.detailsTextView.text
            
            self.navigationController?.pushViewController(PostRideSummaryViewController(ride: self.ride), animated: true)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", image: nil, primaryAction: nextAction, menu: nil)
        
        setupContainerView()
        setupTravelers()
        setupDate()
        setupTime()
        setupOtherDetails()
    }
    
    private func setupContainerView() {
        containerView.backgroundColor = .clear
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    private func setupTravelers() {
        travelersLabel.text = "Number of Travelers"
        travelersLabel.textColor = .black
        containerView.addSubview(travelersLabel)
        
        travelersLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
        }
        
        peopleImageView.image = UIImage(systemName: "person.2")
        peopleImageView.tintColor = .black
        containerView.addSubview(peopleImageView)
        
        peopleImageView.snp.makeConstraints { make in
            make.top.equalTo(travelersLabel.snp.bottom).offset(labelSpace)
            make.leading.equalTo(travelersLabel)
        }
        
        count1TextField.delegate = self
        count1TextField.placeholder = "0"
        count1TextField.textColor = .black
        containerView.addSubview(count1TextField)
        
        count1TextField.snp.makeConstraints { make in
            make.top.equalTo(peopleImageView)
            make.leading.equalTo(peopleImageView.snp.trailing).offset(10)
        }
        
        toLabel.text = "to"
        toLabel.textColor = .black
        containerView.addSubview(toLabel)
        
        toLabel.snp.makeConstraints { make in
            make.top.equalTo(peopleImageView)
            make.leading.equalTo(count1TextField.snp.trailing).offset(10)
        }
        
        count2TextField.delegate = self
        count2TextField.placeholder = "0"
        count2TextField.tintColor = .black
        containerView.addSubview(count2TextField)
        
        count2TextField.snp.makeConstraints { make in
            make.top.equalTo(peopleImageView)
            make.leading.equalTo(toLabel.snp.trailing).offset(10)
        }
    }
    
    private func setupDate() {
        dateLabel.text = "Date of Trip"
        dateLabel.textColor = .black
        containerView.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(travelersLabel)
            make.top.equalTo(peopleImageView.snp.bottom).offset(25)
        }
        
        calendarImageView.image = UIImage(systemName: "calendar")
        calendarImageView.tintColor = .black
        containerView.addSubview(calendarImageView)
        
        calendarImageView.snp.makeConstraints { make in
            make.leading.equalTo(dateLabel)
            make.top.equalTo(dateLabel.snp.bottom).offset(labelSpace)
            make.width.equalTo(calendarImageView.snp.height)
        }
        
        datePicker.datePickerMode = .date
        containerView.addSubview(datePicker)
        
        datePicker.snp.makeConstraints { make in
            make.leading.equalTo(calendarImageView.snp.trailing).offset(10)
            make.centerY.equalTo(calendarImageView)
        }
    }
    
    private func setupTime() {
        timeLabel.text = "Time of Trip"
        timeLabel.textColor = .black
        containerView.addSubview(timeLabel)
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(travelersLabel)
            make.top.equalTo(calendarImageView.snp.bottom).offset(fieldSpace)
        }
        
        clockImageView.image = UIImage(systemName: "clock")
        clockImageView.tintColor = .black
        containerView.addSubview(clockImageView)
        
        clockImageView.snp.makeConstraints { make in
            make.leading.equalTo(timeLabel)
            make.top.equalTo(timeLabel.snp.bottom).offset(labelSpace)
            make.width.equalTo(clockImageView.snp.height)
        }
        
        timePicker.datePickerMode = .time
        containerView.addSubview(timePicker)
        
        timePicker.snp.makeConstraints { make in
            make.leading.equalTo(clockImageView.snp.trailing).offset(10)
            make.centerY.equalTo(clockImageView)
        }
    }
    
    private func setupOtherDetails() {
        detailsLabel.text = "Other Details"
        detailsLabel.textColor = .black
        containerView.addSubview(detailsLabel)
        
        detailsLabel.snp.makeConstraints { make in
            make.leading.equalTo(travelersLabel)
            make.top.equalTo(clockImageView.snp.bottom).offset(fieldSpace)
        }
        
        let writeImageView = UIImageView(image: UIImage(systemName: "square.and.pencil"))
        writeImageView.tintColor = .black
        containerView.addSubview(writeImageView)
        
        writeImageView.snp.makeConstraints { make in
            make.leading.equalTo(detailsLabel)
            make.top.equalTo(detailsLabel.snp.bottom).offset(labelSpace)
            make.width.equalTo(writeImageView.snp.height)
        }
        
        detailsTextView.backgroundColor = .clear
        detailsTextView.delegate = self
        detailsTextView.text = "enter details..."
        detailsTextView.textColor = .placeholderText
        detailsTextView.textContainerInset = .zero
        detailsTextView.textContainer.lineFragmentPadding = .zero
        detailsTextView.font = .systemFont(ofSize: 18)
        containerView.addSubview(detailsTextView)
        
        detailsTextView.snp.makeConstraints { make in
            make.leading.equalTo(writeImageView.snp.trailing).offset(10)
            make.top.equalTo(writeImageView)
            make.trailing.equalToSuperview()
            make.height.equalTo(80)
            make.bottom.equalToSuperview().inset(labelSpace)
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
}

// MARK: - UITextFieldDelegate
extension TripExtraDetailsViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Source: https://stackoverflow.com/a/31363255/5278889
        let maxLength = 1
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
        currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
}

// MARK: - UITextViewDelegate
extension TripExtraDetailsViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderText {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "enter details..."
            textView.textColor = .placeholderText
        }
    }
    
}
