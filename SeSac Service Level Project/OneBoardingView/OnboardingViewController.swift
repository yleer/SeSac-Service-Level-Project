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
        mainView.scrollView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.configureScrollView()
    }
    
    private func addTargets() {
        mainView.pageControl.addTarget(self, action: #selector(pageControlDidChange), for: .valueChanged)
        mainView.startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
    }
    
    
    @objc private func pageControlDidChange(_ sender: UIPageControl) {
        let current = sender.currentPage
        mainView.scrollView.setContentOffset(CGPoint(x: CGFloat(current) * mainView.scrollView.frame.size.width, y: 0), animated: true)
    }
    
    @objc private func startButtonClicked(_ sender: UIButton) {
        let current = mainView.pageControl.currentPage
        if current == 2 {
            let vc = RegisterViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            mainView.scrollView.setContentOffset(CGPoint(x: CGFloat(current + 1) * mainView.scrollView.frame.size.width, y: 0), animated: true)
        }
    }
}


extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.frame.size.width == 0 {
            mainView.pageControl.currentPage = Int(floorf(Float(scrollView.contentOffset.x) / Float(1)))
        }else{
            mainView.pageControl.currentPage = Int(floorf(Float(scrollView.contentOffset.x) / Float(mainView.scrollView.frame.size.width )))
        }
        
    }
}
