//
//  AppPurchaseViewController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/19.
//

import UIKit
import SnapKit
import Parchment

final class AppPurchaseViewController: UIViewController {
    
    let currentBackgroundImage = UIImageView()
    let saveButton = UIButton()
    var pagingViewController = PagingViewController()
    
    override func loadView() {
        super.loadView()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpParchment()
        setUpConstraints()
    }
    
    private func setUp() {
        view.backgroundColor = .white
        title = "새싹샵"
        
        self.view.addSubview(currentBackgroundImage)
        currentBackgroundImage.addSubview(saveButton)
        saveButton.backgroundColor = .black
        
        currentBackgroundImage.image = UIImage(named: ImageNames.AppPurchaseViewController.background2)
        
        currentBackgroundImage.layer.cornerRadius = 15
        
    }
    
    private func setUpConstraints() {
        
        currentBackgroundImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.height.equalTo(175)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(13)
            make.trailing.equalToSuperview().offset(-13)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        pagingViewController.view.snp.makeConstraints { make in
            make.top.equalTo(currentBackgroundImage.snp.bottom).offset(11)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    
    private func setUpParchment() {
        let firstViewController = SeSacPurchaseViewController()
        let secondViewController = BackgroundPurchaseViewController()
        
        firstViewController.title = "새싹"
        secondViewController.title = "배경"
        
        
        pagingViewController = PagingViewController(viewControllers: [
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
    }
    
}


extension AppPurchaseViewController: PagingViewControllerDelegate, PagingViewControllerSizeDelegate {
    
    func pagingViewController(_: PagingViewController, widthForPagingItem pagingItem: PagingItem, isSelected: Bool) -> CGFloat {
        return 200
    }

}
