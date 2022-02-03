//
//  NearUserViewController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/01.
//

import UIKit
import Parchment

class NearUserPageMenuController: UIViewController {
        
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        title = "새싹 찾기"
        let firstViewController = OnboardingViewController()
        let secondViewController = RegisterViewController()
        
        firstViewController.title = "주변 새싹"
        secondViewController.title = "받은 요청"
        
        
        
        
        let pagingViewController = PagingViewController(viewControllers: [
            firstViewController,
          secondViewController
        ])
        
        pagingViewController.font = UIFont(name: FontNames.medium, size: 14)!
        pagingViewController.selectedTextColor = .brandGreen!
        pagingViewController.textColor = .gray6!
        pagingViewController.indicatorColor = .brandGreen!
        

        
        
        
        
        
        
        pagingViewController.menuItemSize = .fixed(width: 200, height: 44)
        
        pagingViewController.sizeDelegate = self
        pagingViewController.delegate = self
        
        addChild(pagingViewController)
        
        view.addSubview(pagingViewController.view)
        
        pagingViewController.didMove(toParent: self)
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
          pagingViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          pagingViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
          pagingViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
          pagingViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    
    }
}

extension NearUserPageMenuController: PagingViewControllerSizeDelegate {
    func pagingViewController(
            _: PagingViewController,
            widthForPagingItem pagingItem: PagingItem,
            isSelected: Bool) -> CGFloat {
                return 200
            }
    
    
    
}

extension NearUserPageMenuController: PagingViewControllerDelegate {
//    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
//        return (title: "View \(index)", index: index)
//        index.title
//        }
}
