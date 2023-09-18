//
//  PostRideContainerViewController.swift
//  Scoop
//
//  Created by Richie Sun on 4/3/23.
//

import UIKit

class PostRideContainerViewController: ViewController {
    
    let screenMultiplier = 335.0/375.0
    
    // MARK: - Views
    
    var pageViewController: PostRidePageViewController!
    let carImageView = UIImageView(image: UIImage(named: "car"))
    let dotsImageView = UIImageView(image: UIImage(named: "Post0"))
    let screenRect = UIScreen.main.bounds
    var screenWidth: CGFloat!
    
    weak var postDelegate: PostRideSummaryDelegate?
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageViewController = PostRidePageViewController(delegate: self)
        pageViewController.postDelegate = self.postDelegate
        screenWidth = view.frame.width - 24
        view.backgroundColor = .white
        
        setupAnimation()
        setupTitleLines()
        setupTitle(name: "Trip details")
        self.navigationItem.hidesBackButton = true
    }
    
    // MARK: - Setup View Functions
    
    private func setupAnimation() {
        view.addSubview(pageViewController.view)
        view.addSubview(dotsImageView)
        dotsImageView.contentMode = .scaleAspectFill
        view.addSubview(carImageView)
        
        pageViewController.view.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50)
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
    
    private func setupTitle(name: String) {
        self.navigationController?.navigationBar.titleTextAttributes = [.font: UIFont(name: "Sen-Regular", size: 24)]
        self.navigationItem.title = name
    }
    
    private func setupTitleLines() {
        let dottedLineMultiplier = 0.52
        let solidLineVerticalInset = -12.75
        let solidLineMultiplier = 0.32
        let screenSize = UIScreen.main.bounds
        let dottedline = UIImageView(image: UIImage(named: "dottedline"))
        
        dottedline.contentMode = .scaleAspectFit
        view.addSubview(dottedline)
        dottedline.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(screenSize.width*dottedLineMultiplier)
            make.trailing.equalToSuperview().inset(10)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        
        let solidline = UIView()
        solidline.backgroundColor = .black
        view.addSubview(solidline)
        solidline.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.width.equalTo(screenSize.width*solidLineMultiplier)
            make.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(solidLineVerticalInset)
        }
    }
    
}

// MARK: - AnimationDelegate

extension PostRideContainerViewController: AnimationDelegate {
    
    func animateCar(startPage: Int, endPage: Int) {
        let pageCount : Double = 2.5
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

