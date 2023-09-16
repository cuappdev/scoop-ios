//
//  OnboardingViewController.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/16/22.
//

import UIKit

class OnboardingPageViewController: UIPageViewController {
    
    private var pages = [UIViewController]()
    weak var animationDelegate: AnimationDelegate?
    
    // MARK: - Initializers
    
    init(delegate: AnimationDelegate) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        animationDelegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        delegate = self
        dataSource = self
        
        setupPages()
        disableSwiping()
    }
    
    // MARK: - Helper Functions
    
    private func setupPages() {
        pages = [
            AboutYouViewController(),
            PreferredContactViewController(),
            PreferencesViewController(),
            FavoritesViewController(),
            ProfilePictureViewController(containerDelegate: animationDelegate)
        ]
        
        for i in 0..<pages.count {
            if let page = pages[i] as? OnboardingViewController {
                page.delegate = self
            }
            
            pages[i] = UINavigationController(rootViewController: pages[i])
        }
        
        setViewControllers([pages[0]], direction: .forward, animated: true, completion: nil)
    }
    
    private func disableSwiping() {
        for view in view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }
    
    // MARK: - Page Control Functions
    
    private func presentNextVC(_ viewController: UIViewController) {
        if let viewControllerIndex = pages.firstIndex(of: viewController) {
            if viewControllerIndex < pages.count - 1 {
                let vc = pages[viewControllerIndex + 1]
                animationDelegate?.animateCar(startPage: viewControllerIndex, endPage: viewControllerIndex + 1)
                animationDelegate?.animateTrack(name: "Onboarding", frame: viewControllerIndex + 1)
                self.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
            }
        }
    }
    
    private func presentPreviousVC(_ viewController: UIViewController) {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return
        }
            if viewControllerIndex > 0 {
                let vc = pages[viewControllerIndex - 1]
                animationDelegate?.animateCar(startPage: viewControllerIndex, endPage: viewControllerIndex - 1)
                animationDelegate?.animateTrack(name: "Onboarding", frame: viewControllerIndex - 1)
                self.setViewControllers([vc], direction: .reverse, animated: true, completion: nil)
            }
        }

}

// MARK: - UIPageViewControllerDelegate

extension OnboardingPageViewController: UIPageViewControllerDelegate {
    
}

// MARK: - UIPageViewControllerDataSource

extension OnboardingPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else { return nil }
        
        return pages[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index + 1 < pages.count else { return nil }
        
        return pages[index + 1]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        for subview in view.subviews {
            if subview is UIPageControl {
                subview.isHidden = true
            }
        }
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let currentController = viewControllers?.first, let index = pages.firstIndex(of: currentController) else { return 0 }
        return index
    }
    
}

// MARK: - OnboardingDelegate

extension OnboardingPageViewController: OnboardingDelegate {
    
    func didTapBack(_ viewController: UIViewController, previousViewController: UIViewController?) {
        guard let prevVC = previousViewController else {
            presentPreviousVC(viewController)
            return
        }
        
        presentPreviousVC(prevVC)
    }
    
    func didTapNext(_ viewController: UIViewController, nextViewController: UIViewController?) {
        guard let nextVC = nextViewController else {
            presentNextVC(viewController)
            return
        }
        
        presentNextVC(nextVC)
    }
}

protocol AnimationDelegate: UIViewController {
    func animateCar(startPage: Int, endPage: Int)
    func animateTrack(name: String, frame: Int)
}
