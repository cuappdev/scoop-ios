//
//  PostRideSummaryViewController.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/9/22.
//

import CoreLocation
import MapKit
import UIKit

class PostRideSummaryViewController: UIViewController {
    
    // UI Components
    private let containerView = UIView()
    private let postButton = UIButton()
    
    // MapKit
    private let locationManager = CLLocationManager()
    private let mapView = MKMapView()
    
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
        
        setupMapView()
        setupContainerView()
        setupPostButton()
    }
    
    private func setupMapView() {
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalTo(view.snp.centerY)
        }
        
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        if let coor = mapView.userLocation.location?.coordinate {
            mapView.setCenter(coor, animated: true)
        }
    }
    
    private func setupContainerView() {
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 24
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(mapView.snp.bottom).offset(-20)
        }
        
        let scrollView = UIScrollView()
        scrollView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 120, right: 0)
        containerView.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let detailsStackView = UIStackView()
        detailsStackView.axis = .vertical
        detailsStackView.distribution = .fill
        detailsStackView.spacing = 20
        detailsStackView.alignment = .leading
        scrollView.addSubview(detailsStackView)
        
        detailsStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(20)
            make.top.bottom.equalToSuperview()
        }
        
        let rideTitleLabel = UILabel()
        rideTitleLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        rideTitleLabel.text = "Trip to \(ride.path.endLocationName)"
        rideTitleLabel.textColor = .black
        rideTitleLabel.numberOfLines = 2
        rideTitleLabel.adjustsFontSizeToFitWidth = true
        detailsStackView.addArrangedSubview(rideTitleLabel)
        detailsStackView.setCustomSpacing(10, after: rideTitleLabel)
        
        let organizerLabel = UILabel()
        organizerLabel.font = .systemFont(ofSize: 12)
        organizerLabel.text = "Organizer: @\(ride.creator.netid)" // TODO: We need to support Usernames during onboarding
        organizerLabel.textColor = .black
        organizerLabel.adjustsFontSizeToFitWidth = true
        detailsStackView.addArrangedSubview(organizerLabel)
        
        let drivingSection = ImageLabelView()
        drivingSection.label.font = .systemFont(ofSize: 18)
        drivingSection.label.text = "Driving"
        drivingSection.imageView.image = UIImage(systemName: "car", withConfiguration: UIImage.SymbolConfiguration(pointSize: 36))
        detailsStackView.addArrangedSubview(drivingSection)
        
        let startingLocationSection = ImageLabelView()
        startingLocationSection.label.font = .systemFont(ofSize: 18)
        startingLocationSection.label.text = ride.path.startLocationName
        startingLocationSection.imageView.image = UIImage(systemName: "paperplane", withConfiguration: UIImage.SymbolConfiguration(pointSize: 36))
        detailsStackView.addArrangedSubview(startingLocationSection)
        
        let endingLocationSection = ImageLabelView()
        endingLocationSection.label.font = .systemFont(ofSize: 18)
        endingLocationSection.label.text = ride.path.endLocationName
        endingLocationSection.imageView.image = UIImage(systemName: "mappin", withConfiguration: UIImage.SymbolConfiguration(pointSize: 36))
        detailsStackView.addArrangedSubview(endingLocationSection)
        
        let dateSection = ImageLabelView()
        dateSection.label.font = .systemFont(ofSize: 18)
        dateSection.label.text = ride.departureDatetime
        dateSection.imageView.image = UIImage(systemName: "calendar.badge.clock", withConfiguration: UIImage.SymbolConfiguration(pointSize: 36))
        detailsStackView.addArrangedSubview(dateSection)
        
        let peopleSection = ImageLabelView()
        peopleSection.label.font = .systemFont(ofSize: 18)
        peopleSection.label.text = "\(ride.minTravelers) to \(ride.maxTravelers) other travelers"
        peopleSection.imageView.image = UIImage(systemName: "person.2", withConfiguration: UIImage.SymbolConfiguration(pointSize: 36))
        detailsStackView.addArrangedSubview(peopleSection)
        
        let detailsLabel = UILabel()
        detailsLabel.font = .systemFont(ofSize: 18)
        detailsLabel.text = "Details:"
        detailsLabel.textColor = .black
        detailsStackView.addArrangedSubview(detailsLabel)
        detailsStackView.setCustomSpacing(5, after: detailsLabel)
        
        let detailsTextView = UITextView()
        detailsTextView.textContainerInset = .zero
        detailsTextView.textContainer.lineFragmentPadding = .zero
        detailsTextView.isEditable = false
        detailsTextView.isScrollEnabled = false
        detailsTextView.font = .systemFont(ofSize: 14)
        detailsTextView.text = ride.description
        detailsStackView.addArrangedSubview(detailsTextView)
    }
    
    private func setupPostButton() {
        postButton.setTitle("Post Trip", for: .normal)
        postButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        postButton.setTitleColor(.black, for: .normal)
        postButton.backgroundColor = .systemGray5
        postButton.layer.cornerRadius = 25
        postButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        postButton.layer.shadowColor = UIColor.darkGray.cgColor
        postButton.layer.shadowOpacity = 0.5
        postButton.layer.shadowRadius = 4
        view.addSubview(postButton)
        
        postButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(200)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        let postAction = UIAction { _ in
            // Convert back to backend's "yyyy-MM-dd'T'HH:mm:ssZ" form.
            // Source: https://stackoverflow.com/questions/35700281/date-format-in-swift
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "M/dd/yy @ h:mm a"
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            
            if let date = dateFormatterGet.date(from: self.ride.departureDatetime) {
                // TODO: getAllRides networking call goes here after backend is finalized
                // TODO: Network Manager currently uses a User instead of BaseUser object -> Needs to be adjusted so currently commented out
                //                NetworkManager.shared.postRide(startName: ride.path.startLocationName, endName: ride.path.endLocationName, creator: NetworkManager.shared.currentUser, maxTravellers: ride.maxTravelers, minTravellers: ride.minTravelers, type: ride.type, isFlexible: ride.isFlexible, departureTime: dateFormatterPrint.string(from: date)) { Ride in
                //                    print(ride)
                //                }
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        postButton.addAction(postAction, for: .touchUpInside)
    }
}

// MARK: - MKMapViewDelegate
extension PostRideSummaryViewController: MKMapViewDelegate {
    
}

// MARK: - CLLLocationManagerDelegate
extension PostRideSummaryViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = manager.location?.coordinate else {
            return
        }
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "Ride Pickup!"
        annotation.subtitle = "Your ride is here."
        mapView.addAnnotation(annotation)
    }
    
}
