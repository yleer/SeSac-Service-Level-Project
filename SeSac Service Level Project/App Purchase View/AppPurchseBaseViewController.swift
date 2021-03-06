//
//  AppPurchaseViewController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/19.
//

import UIKit
import SnapKit
import Parchment

enum SeSacImages: Int {
    case first = 0
    case second = 1
    case third = 2
    case fourth = 3
    case fivth = 4
    
}

final class AppPurchseBaseViewController: UIViewController {
    
    let currentBackgroundImage = UIImageView()
    let sessacImage = UIImageView()
    let saveButton = InActiveButton()
    var pagingViewController = PagingViewController()
    var currentSelectedItems = (0,0)
    
    @objc func saveButtonClicked() {
        guard let idToken = UserDefaults.standard.string(forKey: UserDefaults.myKey.idToken.rawValue) else { return }
        print("saveButton clicked")
        ShopApiService.updateMyState(idToken: idToken, sesac: currentSelectedItems.0, background: currentSelectedItems.1) { error, statusCode in
            print("statusCode: ", statusCode)
            if statusCode == 200 {
                self.view.makeToast("성공적으로 변경되었습니다")
            }else if statusCode == 201 {
                self.view.makeToast("보유하지 않은 아이템이 선택되었습니다")
            }else {
                switch error! {
                    
                case .firebaseTokenError(errorContent: let errorContent):
                    self.view.makeToast(errorContent)
                    self.saveButtonClicked()
                case .serverError(errorContent: let errorContent), .clientError(errorContent: let errorContent), .alreadyWithdrawl(errorContent: let errorContent):
                    self.view.makeToast(errorContent)
                }
                
            }
        }
    }

    
    private func addTargets() {
        saveButton.addTarget(self, action: #selector(saveButtonClicked), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(handleCancelPush),
                                               name: .cancelPush,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleReqeustPush),
                                               name: .requestPush,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAcceptPush),
                                               name: .acceptPush,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleChatPush),
                                               name: .chatPush,
                                               object: nil)
    }
    
    @objc func handleCancelPush() {}
    @objc func handleChatPush() {
        let userState = UserDefaults.standard.integer(forKey: UserDefaults.myKey.CurrentUserState.rawValue)
        if userState == 0 || userState == 1 {
            self.tabBarController?.selectedIndex = 0
        }else if userState == 2 {
            self.tabBarController?.selectedIndex = 0
            let vc = ChattingViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @objc func handleAcceptPush() {
        let userState = UserDefaults.standard.integer(forKey: UserDefaults.myKey.CurrentUserState.rawValue)
        if userState == 0 || userState == 2 {
            self.tabBarController?.selectedIndex = 0
        }else if userState == 1 {
            self.tabBarController?.selectedIndex = 0
            let vc = ChattingViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @objc func handleReqeustPush() {
        let userState = UserDefaults.standard.integer(forKey: UserDefaults.myKey.CurrentUserState.rawValue)
        if userState == 0 || userState == 2 {
            self.tabBarController?.selectedIndex = 0
        }else if userState == 1 {
            self.tabBarController?.selectedIndex = 0
            let vc = NearUserPageMenuController()
            vc.isSecond = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpParchment()
        setUpConstraints()
        
        addTargets()
        
        currentSelectedItems = (UserInfo.current.user!.sesac, UserInfo.current.user!.background)
        let c = UserInfo.current.user!.sesac
        
        if c == 0 {
            sessacImage.image = UIImage(named: ImageNames.AppPurchaseViewController.img)
        }else if c == 1 {
            sessacImage.image = UIImage(named: ImageNames.AppPurchaseViewController.img1)
        }else if c == 2 {
            sessacImage.image = UIImage(named: ImageNames.AppPurchaseViewController.img2)
        }else if c == 3 {
            sessacImage.image = UIImage(named: ImageNames.AppPurchaseViewController.img3)
        }else if c == 4 {
            sessacImage.image = UIImage(named: ImageNames.AppPurchaseViewController.img4)
        }
        
        let back = UserInfo.current.user!.background
        
        if back == 0 {
            currentBackgroundImage.image = UIImage(named: ImageNames.AppPurchaseViewController.background1)
        }else if back == 1{
            currentBackgroundImage.image = UIImage(named: ImageNames.AppPurchaseViewController.background2)
        }else if back == 2{
            currentBackgroundImage.image = UIImage(named: ImageNames.AppPurchaseViewController.background3)
        }else if back == 3{
            currentBackgroundImage.image = UIImage(named: ImageNames.AppPurchaseViewController.background4)
        }else if back == 4{
            currentBackgroundImage.image = UIImage(named: ImageNames.AppPurchaseViewController.background5)
        }else if back == 5{
            currentBackgroundImage.image = UIImage(named: ImageNames.AppPurchaseViewController.background6)
        }else if back == 6{
            currentBackgroundImage.image = UIImage(named: ImageNames.AppPurchaseViewController.background7)
        }else if back == 7{
            currentBackgroundImage.image = UIImage(named: ImageNames.AppPurchaseViewController.background8)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getShopInfo()
    }
    
    private func getShopInfo() {
        guard let idToken = UserDefaults.standard.string(forKey: UserDefaults.myKey.idToken.rawValue) else { return }
        ShopApiService.getMyShopInfo(idToken: idToken) { error, statusCode in
            if let error = error {
                switch error {
                case .firebaseTokenError(errorContent: let errorContent):
                    self.view.makeToast(errorContent)
                    self.getShopInfo()
                case .serverError(errorContent: let errorContent), .clientError(errorContent: let errorContent), .alreadyWithdrawl(errorContent: let errorContent):
                    self.view.makeToast(errorContent)
                }
            }else {
                print("success")
            }
        }
    }
    
    private func setUp() {
        view.backgroundColor = .white
        title = "새싹샵"
        
        self.view.addSubview(currentBackgroundImage)
        currentBackgroundImage.addSubview(sessacImage)
        self.view.addSubview(saveButton)
        saveButton.backgroundColor = .black
        
        currentBackgroundImage.image = UIImage(named: ImageNames.AppPurchaseViewController.background2)
        
        currentBackgroundImage.layer.cornerRadius = 15
        
        saveButton.stateOfButton = .fill
        saveButton.setTitle("저장하기", for: .normal)
        
    }
    
    private func setUpConstraints() {
        
        currentBackgroundImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.height.equalTo(175)
        }
        
        sessacImage.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.size.equalTo(160)
            make.centerX.equalToSuperview()
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(currentBackgroundImage.snp.top).offset(13)
            make.trailing.equalTo(currentBackgroundImage.snp.trailing).offset(-13)
//            make.top.equalToSuperview().offset(13)
//            make.trailing.equalToSuperview().offset(-13)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        

        pagingViewController.view.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            pagingViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          pagingViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
          pagingViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pagingViewController.view.topAnchor.constraint(equalTo: currentBackgroundImage.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func getBackGroundImage(num: Int) -> UIImage? {
        currentSelectedItems = (currentSelectedItems.0, num)
        if num == 0 {
            return UIImage(named: ImageNames.AppPurchaseViewController.background1)
        }else if num == 1 {
            return UIImage(named: ImageNames.AppPurchaseViewController.background2)
        }else if num == 2 {
            return UIImage(named: ImageNames.AppPurchaseViewController.background3)
        }else if num == 3 {
            return UIImage(named: ImageNames.AppPurchaseViewController.background4)
        }else if num == 4 {
            return UIImage(named: ImageNames.AppPurchaseViewController.background5)
        }else if num == 5 {
            return UIImage(named: ImageNames.AppPurchaseViewController.background6)
        }else if num == 6 {
            return UIImage(named: ImageNames.AppPurchaseViewController.background7)
        }else {
            return UIImage(named: ImageNames.AppPurchaseViewController.background8)
        }
        
    }
    
    private func getSeSacImage(num: Int) -> UIImage? {
        currentSelectedItems = (num, currentSelectedItems.1)
        if num == 0 {
            return UIImage(named: ImageNames.AppPurchaseViewController.img)
        }else if num == 1 {
            return UIImage(named: ImageNames.AppPurchaseViewController.img1)
        }else if num == 2 {
            return UIImage(named: ImageNames.AppPurchaseViewController.img2)
        }else if num == 3 {
            return UIImage(named: ImageNames.AppPurchaseViewController.img3)
        }else {
            return UIImage(named: ImageNames.AppPurchaseViewController.img4)
        }
    }
    private func setUpParchment() {
        let firstViewController = SeSacPurchaseViewController()
        let secondViewController = BackgroundPurchaseViewController()
        
        firstViewController.title = "새싹"
        secondViewController.title = "배경"
        firstViewController.changeSeSacCompletion = { num in
            self.sessacImage.image = self.getSeSacImage(num: num)
        }
        secondViewController.changeBackgroundCompletion = { num in
            self.currentBackgroundImage.image = self.getBackGroundImage(num: num)
        }
        
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
    }
    
}


extension AppPurchseBaseViewController: PagingViewControllerDelegate, PagingViewControllerSizeDelegate {
    
    func pagingViewController(_: PagingViewController, widthForPagingItem pagingItem: PagingItem, isSelected: Bool) -> CGFloat {
        return 200
    }

}
