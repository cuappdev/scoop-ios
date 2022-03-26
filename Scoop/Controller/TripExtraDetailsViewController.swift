//
//  TripExtraDetailsViewController.swift
//  Scoop
//
//  Created by Elvis Marcelo on 3/18/22.
//

import UIKit

class TripExtraDetailsViewController: UIViewController {
    
    private let travelersLabel = UILabel()
    private let toLabel = UILabel()
    private let count1TextField = UITextField()
    private let count2TextField = UITextField()
    private let peopleImageView = UIImageView()
    
    private let dateLabel = UILabel()
    private let dateTextField = UITextField()
    private let calendarImageView = UIImageView()
    
    private let timeLabel = UILabel()
    private let timeTextField = UITextField()
    private let clockImageView = UIImageView()
    
    private let detailsLabel = UILabel()
    private let detailsTextField = UITextField()
    
    private var containerView = UIView()
    
    private let labelSpace = 5
    private let fieldSpace = 40

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Trip Details"
        view.backgroundColor = .white
        
        view.addSubview(containerView)
        
        setupContainerView()
        setupTravelers()
        setupDate()
        setupTime()
        setupOtherDetails()
    }
    
    func setupContainerView() {
        containerView.backgroundColor = .clear
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
        }
    }
    
    func setupTravelers() {
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
        
        count2TextField.placeholder = "0"
        count2TextField.tintColor = .black
        containerView.addSubview(count2TextField)
        
        count2TextField.snp.makeConstraints { make in
            make.top.equalTo(peopleImageView)
            make.leading.equalTo(toLabel.snp.trailing).offset(10)
        }
    }
    
    func setupDate() {
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
        
        dateTextField.placeholder = "mm/dd/yyyy"
        dateTextField.textColor = .black
        containerView.addSubview(dateTextField)
        
        dateTextField.snp.makeConstraints { make in
            make.leading.equalTo(calendarImageView.snp.trailing).offset(10)
            make.top.equalTo(calendarImageView)
            make.trailing.equalToSuperview()
        }
    }
    
    func setupTime() {
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
        
        timeTextField.placeholder = "1:33 AM"
        timeTextField.textColor = .black
        containerView.addSubview(timeTextField)
        
        timeTextField.snp.makeConstraints { make in
            make.leading.equalTo(clockImageView.snp.trailing).offset(10)
            make.top.equalTo(clockImageView)
            make.trailing.equalToSuperview()
       }
    }
    
    func setupOtherDetails(){
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
        
        detailsTextField.placeholder = "enter details..."
        detailsTextField.textColor = .black
        containerView.addSubview(detailsTextField)
        
        detailsTextField.snp.makeConstraints { make in
            make.leading.equalTo(writeImageView.snp.trailing).offset(10)
            make.top.equalTo(writeImageView)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(labelSpace)
         }
    }
}
