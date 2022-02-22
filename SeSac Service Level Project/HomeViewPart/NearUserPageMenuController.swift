//
//  NearUserViewController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/01.
//

import UIKit
import SnapKit
import Parchment
import Toast

class NearUserPageMenuController: UIViewController {
    
    var pagingViewController = PagingViewController()
    var isSecond = false
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "새싹 찾기"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "찾기중단", style: .plain, target: self, action: #selector(stopMathcingButtonClicked))
        
        
        let firstViewController = NearUserViewController()
        let secondViewController = RecivedReqiestViewController()
        
        
        firstViewController.title = "주변 새싹"
        secondViewController.title = "받은 요청"
        
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
        
        pagingViewController.didMove(toParent: self)
        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            pagingViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          pagingViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
          pagingViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
          pagingViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
        
        if isSecond {
            pagingViewController.select(index: 1)
            isSecond = false
        }
    }
    
    @objc func stopMathcingButtonClicked() {
        FireBaseService.getIdToken {
            if let idToken = UserDefaults.standard.string(forKey: UserDefaults.myKey.idToken.rawValue) {
                HomeApiService.stopFinding(idToken: idToken) { error, statusCode in
                    print("some error in stop ", statusCode, error)
                    if let error = error {
                        switch error {
                        case .firebaseTokenError(let errorContent):
                            self.view.makeToast(errorContent)
                            self.stopMathcingButtonClicked()
                        case.serverError(let errorContent), .clientError(let errorContent), .alreadyWithdrawl(let errorContent):
                            self.view.makeToast(errorContent)
                        }
                    }else {
                        if statusCode == 200 {
                            UserDefaults.standard.set(0, forKey: UserDefaults.myKey.CurrentUserState.rawValue)
                            self.navigationController?.popToRootViewController(animated: true)
                            
                        }else if statusCode == 201 {
                            self.view.makeToast("앗! 누군가가 나의 취미 함께 하기를 수락하였어요!")
                        }
                    }
                }
            }
        }
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

}
