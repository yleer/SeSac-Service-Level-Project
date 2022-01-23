//
//  OnboardingViewController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/23.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    let mainView = OnBoardingView()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        mainView.configureScrollView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.configureScrollView()
    }
    
    private func addTargets() {
        mainView.pageControl.addTarget(self, action: #selector(pageControlDidChange), for: .valueChanged)
    }
    
    
    @objc private func pageControlDidChange(_ sender: UIPageControl) {
        let current = sender.currentPage
        
    }
    
    
    
}
