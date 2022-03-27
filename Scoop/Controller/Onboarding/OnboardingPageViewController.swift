//
//  OnboardingViewController.swift
//  Scoop
//
//  Created by Reade Plunkett on 3/16/22.
//

import UIKit

class OnboardingPageViewController: UIPageViewController {
    
    private var pages = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        delegate = self
        dataSource = self
        
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = .systemGray5
        appearance.currentPageIndicatorTintColor = .systemGray3
        
        setupPages()
        disableSwiping()
    }
    
    private func setupPages() {
        pages = [
            ProfilePictureViewController(),
            AboutYouViewController(),
            PreferredContactViewController(),
            PreferencesViewController(),
            FavoritesViewController()
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
    
    private func presentNextVC(_ viewController: UIViewController) {
        if let viewControllerIndex = pages.firstIndex(of: viewController) {
            if viewControllerIndex < pages.count - 1 {
                let vc = pages[viewControllerIndex + 1]
                self.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
            }
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
        return pages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let currentController = viewControllers?.first, let index = pages.firstIndex(of: currentController) else { return 0 }
        return index
    }
    
}

// MARK: - OnboardingDelegate
extension OnboardingPageViewController: OnboardingDelegate {
    
    func didTapNext(_ viewController: UIViewController, nextViewController: UIViewController?) {
        guard let nextVC = nextViewController else {
            presentNextVC(viewController)
            return
        }
        
        presentNextVC(nextVC)
    }
    
}
