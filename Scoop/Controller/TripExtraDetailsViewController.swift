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
    private let count1Field = UITextField()
    private let count2Field = UITextField()
    
    private let dateLabel = UILabel()
    private let dateField = UITextField()
    
    private let timeLabel = UILabel()
    private let timeField = UITextField()
    
    private let detailsLabel = UILabel()
    private let detailsField = UITextField()


    override func viewDidLoad() {
        

        
        self.navigationItem.title = "Trip Details"
        view.backgroundColor = .white
        
        travelersLabel.text = "Number of Travelers"
        travelersLabel.textColor = .black
        view.addSubview(travelersLabel)
        
        let peopleImage = UIImage(systemName: "person.2")
        let peopleView = UIImageView(image: peopleImage)
        peopleView.tintColor = .black
        view.addSubview(peopleView)
        
        count1Field.placeholder = "0"
        count1Field.textColor = .black
        view.addSubview(count1Field)
        
        toLabel.text = "to"
        toLabel.textColor = .black
        view.addSubview(toLabel)
        
        count2Field.placeholder = "0"
        count2Field.tintColor = .black
        view.addSubview(count2Field)
        
        
        dateLabel.text = "Date of Trip"
        dateLabel.textColor = .black
        view.addSubview(dateLabel)
        
        let calendarView = UIImageView(image: UIImage(systemName: "calendar"))
        calendarView.tintColor = .black
        view.addSubview(calendarView)
        
        dateField.placeholder = "mm/dd/yyyy"
        dateField.textColor = .black
        view.addSubview(dateField)
        
        
        timeLabel.text = "Time of Trip"
        timeLabel.textColor = .black
        view.addSubview(timeLabel)
        
        let clockView = UIImageView(image: UIImage(systemName: "clock"))
        clockView.tintColor = .black
        view.addSubview(clockView)
        
        timeField.placeholder = "1:33 AM"
        timeField.textColor = .black
        view.addSubview(timeField)
        
        
        detailsLabel.text = "Other Details"
        detailsLabel.textColor = .black
        view.addSubview(detailsLabel)
        
        let writeView = UIImageView(image: UIImage(systemName: "square.and.pencil"))
        writeView.tintColor = .black
        view.addSubview(writeView)
        
        detailsField.placeholder = "enter details..."
        detailsField.textColor = .black
        view.addSubview(detailsField)

//        let transImage = UIImage(systemName: "location")
//        let transView = UIImageView(image: transImage)
//        transView.tintColor = .black
//        transView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
//        view.addSubview(transView)
        
        
        travelersLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(300)
            make.leading.equalToSuperview().offset(80)
        }
        
        peopleView.snp.makeConstraints { make in
            make.top.equalTo(travelersLabel.snp.bottom).offset(10)
            make.leading.equalTo(travelersLabel.snp.leading)
        }
        
        count1Field.snp.makeConstraints { make in
            make.top.equalTo(peopleView.snp.top)
            make.leading.equalTo(peopleView.snp.trailing).offset(10)
        }
        toLabel.snp.makeConstraints { make in
            make.top.equalTo(peopleView.snp.top)
            make.leading.equalTo(count1Field.snp.trailing).offset(10)
        }
        count2Field.snp.makeConstraints { make in
            make.top.equalTo(peopleView.snp.top)
            make.leading.equalTo(toLabel.snp.trailing).offset(10)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(travelersLabel.snp.leading)
            make.top.equalTo(peopleView.snp.bottom).offset(25)
        }
        
        calendarView.snp.makeConstraints { make in
            make.leading.equalTo(dateLabel)
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
        }
        
        dateField.snp.makeConstraints { make in
            make.leading.equalTo(calendarView.snp.trailing).offset(10)
            make.top.equalTo(calendarView.snp.top)
        }
        
       timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(travelersLabel.snp.leading)
            make.top.equalTo(calendarView.snp.bottom).offset(25)
        }
        
        clockView.snp.makeConstraints { make in
            make.leading.equalTo(timeLabel)
            make.top.equalTo(timeLabel.snp.bottom).offset(10)
        }
        
        timeField.snp.makeConstraints { make in
            make.leading.equalTo(clockView.snp.trailing).offset(10)
            make.top.equalTo(clockView.snp.top)
        }
        
        detailsLabel.snp.makeConstraints { make in
             make.leading.equalTo(travelersLabel.snp.leading)
             make.top.equalTo(clockView.snp.bottom).offset(25)
         }
         
         writeView.snp.makeConstraints { make in
             make.leading.equalTo(detailsLabel)
             make.top.equalTo(detailsLabel.snp.bottom).offset(10)
         }
         
         detailsField.snp.makeConstraints { make in
             make.leading.equalTo(writeView.snp.trailing).offset(10)
             make.top.equalTo(writeView.snp.top)
         }
         
//        dateLabel.snp.makeConstraints { make in
//            make.leading.equalTo()
//        }
        
//        super.viewDidLoad()

        
//        view.backgroundColor = .red
        
        
    }
    

}
