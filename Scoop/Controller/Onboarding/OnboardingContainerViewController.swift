//
//  OnboardingContainerViewController.swift
//  Scoop
//
//  Created by Richie Sun on 3/16/23.
//

import UIKit

class OnboardingContainerViewController: ViewController {
    
    let screenMultiplier = 335.0/375.0
    
    // MARK: - Views
    
    var pageViewController: OnboardingPageViewController!
    let carImageView = UIImageView(image: UIImage(named: "car"))
    let dotsImageView = UIImageView(image: UIImage(named: "cardots"))
    let screenRect = UIScreen.main.bounds
    var screenWidth: CGFloat!
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageViewController = OnboardingPageViewController(delegate: self)
        screenWidth = view.frame.width - 24
        view.backgroundColor = .white
        view.addSubview(pageViewController.view)
        view.addSubview(dotsImageView)
        dotsImageView.contentMode = .scaleAspectFill
        view.addSubview(carImageView)
        
        pageViewController.view.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
            make.leading.trailing.equalToSuperview().inset(5)
        }
        
        dotsImageView.snp.makeConstraints { make in
            make.centerY.equalTo(carImageView).inset(-20)
            make.height.equalTo(37)
            make.width.equalTo(screenWidth * screenMultiplier)
            make.trailing.equalToSuperview().inset(30)
        }
        
        carImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-30)
            make.leading.equalToSuperview().inset(24)
            make.height.equalTo(36)
            make.width.equalTo(43)
        }
    }
    
}

// MARK: - AnimationDelegate

extension OnboardingContainerViewController: AnimationDelegate {
    
    func animateCar(startPage: Int, endPage: Int) {
        let pageCount : Double = 5
        let startX = screenWidth * screenMultiplier * CGFloat(startPage) / pageCount
        let endX = screenWidth * screenMultiplier * CGFloat(endPage) / pageCount
        UIView.animate(withDuration: 0.8, delay: 0.0) {
            self.carImageView.transform = self.carImageView.transform.concatenating (
                CGAffineTransform(translationX: endX - startX, y: 0.0)
            )
        }
    }
    
    func animateTrack(name: String, frame: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.dotsImageView.image = UIImage(named: "\(name)\(frame)")
        }
    }
    
}
