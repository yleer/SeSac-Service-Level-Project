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
        
    override func loadView() {
        super.loadView()
    }
    
    var mTimer : Timer?
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        startTimer()
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        if let timer = mTimer {
//            if(timer.isValid){
//                timer.invalidate()
//            }
//        }
//    }
    
    
    
    func startTimer() {
        if let timer = mTimer {
            //timer 객체가 nil 이 아닌경우에는 invalid 상태에만 시작한다
            if !timer.isValid {
                /** 1초마다 timerCallback함수를 호출하는 타이머 */
                mTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
            }
        }else{
            //timer 객체가 nil 인 경우에 객체를 생성하고 타이머를 시작한다
            mTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
        }
    }
            
    @objc func timerCallback(){
        let region = UserInfo.current.onqueueParameter?.region
        let lat = UserInfo.current.onqueueParameter?.lat
        let long = UserInfo.current.onqueueParameter?.long
        
        guard let idToken = UserDefaults.standard.string(forKey: "idToken"), let region = region, let lat = lat, let long = long else { return }
        HomeApiService.myQueueState(idToken: idToken) { error, statusCode in
            print(statusCode)
            if statusCode == 200 {
                if UserInfo.current.matched == 1 {
                    UserDefaults.standard.set(2, forKey: "CurrentUserState")
                    self.view.makeToast("\(UserInfo.current.matchedNick)님과 매칭되셨습니다. 잠시 후 채팅방으로 이동합니다")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        let vc = ChattingViewController()
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }else {

            }
        }
        
        
        HomeApiService.onqueue(idToken: idToken, region: region, lat: lat, long: long) { error, statusCode, onqueueData in
            print("need to reload data", statusCode)
        }

   }


   
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "새싹 찾기"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "찾기중단", style: .plain, target: self, action: #selector(stopMathcingButtonClicked))
        
        
        let firstViewController = NearUserViewController()
        let secondViewController = RecivedReqiestViewController()
        
        
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
    
    @objc func stopMathcingButtonClicked() {
        FireBaseService.getIdToken {
            if let idToken = UserDefaults.standard.string(forKey: "idToken") {
                HomeApiService.stopFinding(idToken: idToken) { error, statusCode in
                    if let error = error {
                        switch error {
                        case .firebaseTokenError(let errorContent), .serverError(let errorContent), .clientError(let errorContent), .alreadyWithdrawl(let errorContent):
                            self.view.makeToast(errorContent)
                        }
                    }else {
                        if statusCode == 200 {
                            UserDefaults.standard.set(0, forKey: "CurrentUserState")
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
