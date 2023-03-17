//
//  OnboardingContainerViewController.swift
//  Scoop
//
//  Created by Richie Sun on 3/16/23.
//

//TODO: Implement Animation with images
import UIKit

class OnboardingContainerViewController: ViewController {
    
    var pageViewController: OnboardingPageViewController!
    let carImageView = UIImageView(image: UIImage(named: "car"))
    let dotsImageView = UIImageView(image: UIImage(named: "cardots"))
    let screenRect = UIScreen.main.bounds
    var screenWidth: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageViewController = OnboardingPageViewController()
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
            make.leading.equalTo(carImageView.snp.trailing).inset(10)
            make.centerY.equalTo(carImageView)
            make.width.equalTo(screenWidth * 310.0/375.0)
        }
        
        carImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-30)
            make.leading.equalToSuperview().inset(24)
        }
    }
}

extension OnboardingContainerViewController: AnimationDelegate {
    func animateCar(startPage: Int, endPage: Int) {
        let pageCount : Double = 5
        let startX = screenWidth * CGFloat(startPage) / pageCount
        let endX = screenWidth * CGFloat(endPage) / pageCount
        UIView.animate(withDuration: 0.8, delay: 0.0) {
            self.carImageView.transform = self.carImageView.transform.concatenating (
                CGAffineTransform(translationX: endX - startX, y: 0.0)
            )
        }
    }
}
