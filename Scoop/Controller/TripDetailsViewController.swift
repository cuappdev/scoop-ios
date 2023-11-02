//
//  TripDetailsViewController.swift
//  Scoop
//
//  Created by Richie Sun on 2/22/23.
//

import UIKit
import SDWebImage

class TripDetailsViewController: UIViewController {
    
    private let iconTextSpacing = 10
    private let iconSize = 19
    private let spacing = 10
    
    var currentRide: Ride?
    weak var profileDelegate: ProfileViewDelegate?
    
    // MARK: - Views
    
    private let stackView = UIStackView()
    private let creatorLabel = UILabel()
    private let creatorProfile = UIImageView()
    private let creatorEmail = UILabel()
    private let transportationMethod = UILabel()
    private let driverType = UILabel()
    private let locations = UILabel()
    private let arrivalLocationLabel = UILabel()
    private let departureLocationLabel = UILabel()
    private let departureDateLabel = UILabel()
    private let departureDate = UILabel()
    private let numberTravelersLabel = UILabel()
    private let numberTravelers = UILabel()
    private let detailsLabel = UILabel()
    private let detailsTextView = UITextView()
    private let requestButton = UIButton()
    
    private let mailIcon = UIImageView(image: UIImage(named: "mailIcon"))
    private let carIcon = UIImageView(image: UIImage(named: "carIcon"))
    private let departureIcon = UIImageView(image: UIImage(named: "locationIcon"))
    private let arrivalIcon = UIImageView(image: UIImage(named: "destinationIcon"))
    private let calendarIcon = UIImageView(image: UIImage(named: "calendarIcon"))
    private let iconSeperator = UIImageView(image: UIImage(named: "iconSeperator"))
    
    private let driverInfoContainerView = UIView()
    private let transportationContainerView = UIView()
    private let locationsContainerView = UIView()
    private let dateContainerView = UIView()
    private let numberTravelersContainerView = UIView()
    
    // MARK: - Initializers
    
    init(currentRide: Ride) {
        super.init(nibName: nil, bundle: nil)
        self.currentRide = currentRide
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        guard let creator = currentRide?.creator else { return }
        navigationItem.title = "\(creator.firstName)'s Ride"
        setUpStackView()
        setUpButton()
        setUpLabelFont()
        setUpTextFont()
        setUpIcons()
    }
    
    // MARK: - Setup View Functions
    
    private func setUpStackView() {
        let stackViewMultiplier = 0.05
        let leadingTrailingInset = 32
        let screenSize = UIScreen.main.bounds
        
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .top
        stackView.spacing = 24
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(leadingTrailingInset)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(stackViewMultiplier * screenSize.height)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(0.15 * screenSize.height)
        }
        
        setUpDriverInfo()
        setUpTransportationInfo()
        setUpLocationInfo()
        setUpDateInfo()
        setUpTravelerInfo()
        setupDetailsInfo()
    }
    
    private func setUpDriverInfo() {
        guard let creator = currentRide?.creator else { return }
        
        creatorProfile.sd_setImage(with: URL(string: creator.profilePicUrl ?? ""), placeholderImage: UIImage(named: "emptyimage"))
        creatorProfile.contentMode = .scaleAspectFill
        creatorProfile.layer.borderWidth = 1
        creatorProfile.layer.masksToBounds = false
        creatorProfile.layer.borderColor = UIColor.black.cgColor
        creatorProfile.layer.cornerRadius = 20.5
        creatorProfile.clipsToBounds = true
        driverInfoContainerView.addSubview(creatorProfile)
        
        creatorProfile.snp.makeConstraints { make in
            make.size.equalTo(41)
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        creatorLabel.text = "\(creator.firstName) \(creator.lastName)"
        driverInfoContainerView.addSubview(creatorLabel)
        
        creatorLabel.snp.makeConstraints { make in
            make.leading.equalTo(creatorProfile.snp.trailing).inset(-iconTextSpacing)
            make.top.equalTo(creatorProfile)
        }
        
        driverInfoContainerView.addSubview(mailIcon)
        
        mailIcon.snp.makeConstraints { make in
            make.size.equalTo(15)
            make.leading.equalTo(creatorLabel)
            make.bottom.equalTo(creatorProfile)
        }
        
        creatorEmail.text = "\(creator.netid)@cornell.edu"
        driverInfoContainerView.addSubview(creatorEmail)
        
        creatorEmail.snp.makeConstraints { make in
            make.top.equalTo(creatorLabel.snp.bottom)
            make.leading.equalTo(mailIcon.snp.trailing).inset(-iconTextSpacing)
        }
        
        stackView.addArrangedSubview(driverInfoContainerView)
        
        driverInfoContainerView.snp.makeConstraints { make in
            make.height.equalTo(71)
            make.leading.trailing.equalToSuperview()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileTap))
        driverInfoContainerView.addGestureRecognizer(tapGesture)
        
        driverInfoContainerView.backgroundColor = .white
        driverInfoContainerView.addDropShadow()
        driverInfoContainerView.layer.cornerRadius = 10
    }
    
    private func setUpTransportationInfo() {
        guard let ride = currentRide else { return }
        
        transportationMethod.text = "TRANSPORTATION METHOD"
        transportationContainerView.addSubview(transportationMethod)
        
        transportationMethod.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        transportationContainerView.addSubview(carIcon)
        
        carIcon.snp.makeConstraints { make in
            make.size.equalTo(iconSize)
            make.leading.equalTo(transportationMethod)
            make.top.equalTo(transportationMethod.snp.bottom).inset(-spacing)
        }
        
        driverType.text = ride.type
        transportationContainerView.addSubview(driverType)
        
        driverType.snp.makeConstraints { make in
            make.top.equalTo(carIcon)
            make.leading.equalTo(carIcon.snp.trailing).inset(-iconTextSpacing)
        }
        
        stackView.addArrangedSubview(transportationContainerView)
        
        transportationContainerView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
    
    private func setUpLocationInfo() {
        guard let ride = currentRide else { return }
        
        locations.text = "LOCATIONS"
        locationsContainerView.addSubview(locations)
        
        locations.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        locationsContainerView.addSubview(departureIcon)
        
        departureIcon.snp.makeConstraints { make in
            make.size.equalTo(iconSize)
            make.leading.equalTo(locations)
            make.top.equalTo(locations.snp.bottom).inset(-spacing)
        }
        
        departureLocationLabel.text = ride.path.startLocationName
        locationsContainerView.addSubview(departureLocationLabel)
        
        departureLocationLabel.snp.makeConstraints { make in
            make.top.equalTo(departureIcon)
            make.leading.equalTo(departureIcon.snp.trailing).inset(-iconTextSpacing)
        }
        
        locationsContainerView.addSubview(iconSeperator)
        
        iconSeperator.snp.makeConstraints { make in
            make.height.equalTo(8)
            make.width.equalTo(1.5)
            make.leading.equalTo(locations).inset(8)
            make.top.equalTo(departureIcon.snp.bottom).inset(-spacing)
        }
        
        locationsContainerView.addSubview(arrivalIcon)
        
        arrivalIcon.snp.makeConstraints { make in
            make.size.equalTo(iconSize)
            make.leading.equalTo(locations)
            make.top.equalTo(iconSeperator.snp.bottom).inset(-spacing)
        }
        
        arrivalLocationLabel.text = ride.path.endLocationName
        locationsContainerView.addSubview(arrivalLocationLabel)
        
        arrivalLocationLabel.snp.makeConstraints { make in
            make.top.equalTo(arrivalIcon)
            make.leading.equalTo(arrivalIcon.snp.trailing).inset(-iconTextSpacing)
        }
        
        stackView.addArrangedSubview(locationsContainerView)
        
        locationsContainerView.snp.makeConstraints { make in
            make.height.equalTo(85)
        }
    }
    
    private func setUpDateInfo() {
        guard let ride = currentRide else { return }
        
        departureDateLabel.text = "DEPARTURE DATE"
        dateContainerView.addSubview(departureDateLabel)
        
        departureDateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        dateContainerView.addSubview(calendarIcon)
        
        calendarIcon.snp.makeConstraints { make in
            make.size.equalTo(iconSize)
            make.leading.equalTo(departureDateLabel)
            make.top.equalTo(departureDateLabel.snp.bottom).inset(-spacing)
        }
        
        departureDate.text = formatDate(date: ride.departureDatetime)
        dateContainerView.addSubview(departureDate)
        
        departureDate.snp.makeConstraints { make in
            make.top.equalTo(calendarIcon)
            make.leading.equalTo(calendarIcon.snp.trailing).inset(-iconTextSpacing)
        }
        
        stackView.addArrangedSubview(dateContainerView)
        
        dateContainerView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
    
    private func setUpTravelerInfo() {
        guard let ride = currentRide else { return }
        
        numberTravelersLabel.text = "NUMBER OF TRAVELERS"
        numberTravelersContainerView.addSubview(numberTravelersLabel)
        
        numberTravelersLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        numberTravelers.text = "\(ride.minTravelers) to \(ride.maxTravelers) people"
        numberTravelersContainerView.addSubview(numberTravelers)
        
        numberTravelers.snp.makeConstraints { make in
            make.top.equalTo(numberTravelersLabel.snp.bottom).inset(-spacing)
            make.leading.equalTo(numberTravelers)
        }
        
        stackView.addArrangedSubview(numberTravelersContainerView)
        
        numberTravelersContainerView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
    
    private func setupDetailsInfo() {
        guard let ride = currentRide else { return }
        
        let containerView = UIView()
        
        detailsLabel.text = "DETAILS"
        containerView.addSubview(detailsLabel)
        
        detailsLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        detailsTextView.text = ride.description
        detailsTextView.font = .systemFont(ofSize: 16)
        detailsTextView.textColor = .black
        detailsTextView.isEditable = false
        detailsTextView.isSelectable = false
        containerView.addSubview(detailsTextView)

        detailsTextView.snp.makeConstraints { make in
            make.top.equalTo(detailsLabel.snp.bottom).offset(6)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        stackView.addArrangedSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func setUpButton() {
        requestButton.setTitle("Request to Join", for: .normal)
        requestButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        requestButton.backgroundColor = UIColor.scooped.scoopGreen
        requestButton.layer.cornerRadius = 25
        requestButton.addTarget(self, action: #selector(requestRide), for: .touchUpInside)
        view.addSubview(requestButton)
        
        requestButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom)
            make.centerX.equalToSuperview()
            make.height.equalTo(51)
            make.width.equalTo(296)
        }
    }
    
    // MARK: - Helper Functions
    
    @objc private func requestRide() {
        guard let currentRide = currentRide else { return }
        
        NetworkManager.shared.postRequest(approveeID: NetworkManager.shared.currentUser.id, rideID: currentRide.id) { [weak self] response in
            guard let strongSelf = self else { return }
            let alertVC = UIAlertController(title: "Request Sent", message: "Reach out to \(currentRide.creator.firstName) with any questions about the trip!", preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "Close", style: .default) { UIAlertAction in
                strongSelf.navigationController?.popViewController(animated: true)
            }
            
            let viewAction = UIAlertAction(title: "View Profile", style: .default) { UIAlertAction in
                strongSelf.present(ProfileViewController(user: currentRide.creator), animated: true)
                strongSelf.navigationController?.popViewController(animated: true)
            }
            
            alertVC.addAction(closeAction)
            alertVC.addAction(viewAction)
            alertVC.view.tintColor = UIColor.scooped.scoopDarkGreen
            strongSelf.present(alertVC, animated: true)
        }
    }
    
    @objc private func profileTap() {
        guard let driver = currentRide?.creator else { return }
        
        let profileVC = ProfileViewController(user: driver)
        profileDelegate = profileVC
        profileDelegate?.updateDriverProfile()
        present(profileVC, animated: true)
    }
    
    private func setUpLabelFont() {
        [transportationMethod, locations, departureDateLabel, numberTravelersLabel, detailsLabel].forEach { label in
            label.font = UIFont(name: "Rambla-Regular", size: 16)
            label.textColor = .black
        }
    }
    
    private func setUpTextFont() {
        [creatorLabel, creatorEmail, driverType, arrivalLocationLabel, departureLocationLabel, departureDate, numberTravelers].forEach { textView in
            textView.font = UIFont(name: "SFPro-Regular", size: 16)
            textView.textColor = .black
        }
    }
    
    private func setUpIcons() {
        [mailIcon, carIcon, arrivalIcon, departureIcon, calendarIcon, iconSeperator].forEach { image in
            image.contentMode = .scaleAspectFill
        }
    }
    
    /// Reformats a date string to only contain the month and day , i.e. [Mar 26] from "yyyy-MM-dd'T'HH:mm:ssZ" -> "MMM dd"
    private func formatDate(date: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM d, h:mm a"
        
        if let date = dateFormatterGet.date(from: date) {
            return dateFormatterPrint.string(from: date)
        }
        // Return the original date string if the conversion was not successfully
        return date
    }
    
    func hideRequestButton() {
        requestButton.isHidden = true
    }
    
}
