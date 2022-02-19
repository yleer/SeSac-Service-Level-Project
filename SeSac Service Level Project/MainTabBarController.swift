//
//  MainTabBarController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/26.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.tintColor = UIColor(named: ColorNames.brandGreen)
        self.tabBar.unselectedItemTintColor = UIColor(named: ColorNames.gray6)
        self.tabBar.backgroundColor = .white

        let homeVC = UINavigationController(rootViewController: HomeViewController())
        homeVC.tabBarItem.selectedImage = UIImage(named: ImageNames.TabBarController.ShopActivate)
        homeVC.tabBarItem.image = UIImage(named: ImageNames.TabBarController.ShopInActivate)
        homeVC.tabBarItem.imageInsets = UIEdgeInsets(top: 9.5, left: 0, bottom: -2.5, right: 0)
        
        
        let sessacShopVC = UINavigationController(rootViewController: AppPurchaseViewController())
        sessacShopVC.tabBarItem.selectedImage = UIImage(named: ImageNames.TabBarController.HomeActiviate)
        sessacShopVC.tabBarItem.image = UIImage(named: ImageNames.TabBarController.HomeInActivate)
        sessacShopVC.tabBarItem.imageInsets = UIEdgeInsets(top: 9.5, left: 0, bottom: -2.5, right: 0)
        
        let sesacFriendsVC = UIViewController()
        sesacFriendsVC.view.backgroundColor = .white
        sesacFriendsVC.tabBarItem.selectedImage = UIImage(named: ImageNames.TabBarController.FriendActivate)
        sesacFriendsVC.tabBarItem.image = UIImage(named: ImageNames.TabBarController.FriendInActivate)
        sesacFriendsVC.tabBarItem.imageInsets = UIEdgeInsets(top: 9.5, left: 0, bottom: -2.5, right: 0)
        
//        let myPageNavController = UINavigationController(rootViewController: MyInfoViewController())
        
        let myPageNavController = UINavigationController(rootViewController: MyInfoViewController())
//        myPageNavController.view.backgroundColor = .white
        myPageNavController.tabBarItem.selectedImage = UIImage(named: ImageNames.TabBarController.MyInfoActivate)
        myPageNavController.tabBarItem.image = UIImage(named: ImageNames.TabBarController.MyInfoInActivate)
        myPageNavController.tabBarItem.imageInsets = UIEdgeInsets(top: 9.5, left: 0, bottom: -2.5, right: 0)


        viewControllers = [homeVC, sessacShopVC, sesacFriendsVC, myPageNavController]
        
        guard let idToken = UserDefaults.standard.string(forKey: UserDefaults.myKey.idToken.rawValue) else { return }
        
        ApiService.getUserInfo(idToken: idToken) { error, statusCode in
            if let error = error {
                switch error {
                case .firebaseTokenError(let errorContent):
                    self.view.makeToast(errorContent)
                    guard let idToken = UserDefaults.standard.string(forKey: UserDefaults.myKey.idToken.rawValue) else { return }
                    ApiService.getUserInfo(idToken: idToken) { _, _ in
                        print("good")
                    }
                case .serverError(let errorContent), .clientError(let errorContent), .alreadyWithdrawl(let errorContent):
                self.view.makeToast(errorContent)
                }
            }else {
                print("check")
            }
        }
    }
}
