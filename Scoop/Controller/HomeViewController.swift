//
//  HomeViewController.swift
//  Scoop
//
//  Created by Reade Plunkett on 2/23/22.
//

import CoreLocation
import GoogleSignIn
import MapKit
import UIKit

class HomeViewController: UIViewController {
    
    private let locationManager = CLLocationManager()
    private let mapView = MKMapView()
    private let signOutButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        //        setupSignOutButton()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        setupMapView()
    }
    
    private func setupMapView() {
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        if let coor = mapView.userLocation.location?.coordinate {
            mapView.setCenter(coor, animated: true)
        }
    }
    
    private func setupSignOutButton() {
        signOutButton.setTitle("Sign Out", for: .normal)
        signOutButton.setTitleColor(.white, for: .normal)
        signOutButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        view.addSubview(signOutButton)
        
        signOutButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        let signOutAction = UIAction { _ in
            self.signOut()
        }
        
        signOutButton.addAction(signOutAction, for: .touchUpInside)
    }
    
    private func signOut() {
        GIDSignIn.sharedInstance.signOut()
        dismiss(animated: true)
    }
    
}

// MARK: - MKMapViewDelegate
extension HomeViewController: MKMapViewDelegate {
    
}

// MARK: - CLLLocationManagerDelegate
extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        mapView.mapType = .standard
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        annotation.title = "Ride Pickup!"
        annotation.subtitle = "Your ride is here."
        mapView.addAnnotation(annotation)
    }
    
}
