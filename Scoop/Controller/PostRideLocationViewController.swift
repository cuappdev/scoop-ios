//
//  PostRideLocationViewController.swift
//  Scoop
//
//  Created by Elvis Marcelo on 3/9/22.
//

import UIKit

class PostRideLocationViewController: UIViewController {
    
    private let methodLabel = UILabel()
    private let transField = UITextField()
//    private var transLabel = UIImage()
    
    private let locationLabel = UILabel()
    
    private let departureField = UITextField()
    private let arrivalField = UITextField()

    override func viewDidLoad() {
        
        self.navigationItem.title = "Trip Details"
        view.backgroundColor = .white
        
        methodLabel.text = "Method of Transportation"
        methodLabel.textColor = .black
        view.addSubview(methodLabel)
        
        transField.placeholder = "select"
        transField.textColor = .black
        view.addSubview(transField)
        
        let transImage = UIImage(systemName: "location")
        let transView = UIImageView(image: transImage)
        transView.tintColor = .black
        transView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        view.addSubview(transView)
        
        let destImage = UIImage(systemName: "mappin.and.ellipse")
        let destView = UIImageView(image: destImage)
        destView.tintColor = .black
        destView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        view.addSubview(destView)
        
        locationLabel.text = "Locations"
        locationLabel.textColor = .black
        view.addSubview(locationLabel)

        departureField.placeholder = "Departure Location..."
        departureField.textColor = .black
        view.addSubview(departureField)

        arrivalField.placeholder = "Arrival Location..."
        arrivalField.textColor = .black
        view.addSubview(arrivalField)
        
        methodLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(300)
            make.leading.equalToSuperview().offset(80)
        }
        
        transField.snp.makeConstraints { make in
            make.leading.equalTo(methodLabel.snp.leading)
            make.top.equalTo(methodLabel.snp.bottom).offset(10)
        }
                
        locationLabel.snp.makeConstraints { make in
            make.leading.equalTo(transField.snp.leading)
            make.top.equalTo(transField.snp.bottom).offset(30)
//            make.centerY.
        }
//
        transView.snp.makeConstraints { make in
            make.leading.equalTo(locationLabel.snp.leading)
            make.top.equalTo(locationLabel.snp.bottom).offset(10)
        }
//
        departureField.snp.makeConstraints { make in
            make.top.equalTo(transView.snp.top)
            make.leading.equalTo(transView.snp.trailing).offset(10)
        }
        
        destView.snp.makeConstraints { make in
            make.leading.equalTo(transView.snp.leading)
            make.top.equalTo(transView.snp.bottom).offset(25)
        }
        arrivalField.snp.makeConstraints { make in
            make.leading.equalTo(destView.snp.trailing).offset(10)
            make.top.equalTo(destView.snp.top)
        }
//        
    
        
        
        
        
//        super.viewDidLoad()

    }
    


}
