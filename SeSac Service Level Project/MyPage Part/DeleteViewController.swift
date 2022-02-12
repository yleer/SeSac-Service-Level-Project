//
//  DeleteViewController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/26.
//

import UIKit
import SnapKit
import Toast

class DeleteViewController: UIViewController {

    let mainView = DeleteView()
        
    override func loadView() {
        super.loadView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)
        view.addSubview(mainView)
        mainView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(156)
            make.width.equalTo(344)
        }
        
        mainView.cancelButton.addTarget(self, action: #selector(cancelButtonClicked), for: .touchUpInside)
        mainView.deleteButton.addTarget(self, action: #selector(confurmButtonClicked), for: .touchUpInside)
    }
    
    @objc func cancelButtonClicked() {
        self.dismiss(animated: true, completion: nil)
    }

    
    var idToken: String!
    var uid: String!
    
    var completion: ((Int, String) -> Void)?
    
    @objc func confurmButtonClicked() {
        
        switch mainView.viewType {
        case .basic:
            buttonForBasic()
        case .request:
            HomeApiService.requestFriend(idToken: idToken, otherUid: uid) { error, statusCode in
                if let error = error {
                    switch error {
                    case .firebaseTokenError(let errorContent):
                        FireBaseService.getIdToken(completion: nil)
                    case .serverError(let errorContent), .clientError(let errorContent), .alreadyWithdrawl(let errorContent):
                        self.view.makeToast(errorContent)
                    }
                }else {
                    self.completion?(statusCode, self.uid)
                }
            }
        case .accept:
            HomeApiService.acceptRequest(idToken: idToken, otherUid:uid) { error, statusCode in
                if let error = error {
                    switch error {
                    case .firebaseTokenError(let errorContent):
                        FireBaseService.getIdToken(completion: nil)
                    case .serverError(let errorContent), .clientError(let errorContent), .alreadyWithdrawl(let errorContent):
                        self.view.makeToast(errorContent)
                    }
                } else {
                    self.completion?(statusCode, self.uid)
                }
            }
        case .dodge:
//            let a = idToken
//            let b = uid
            print("..",idToken!, uid!, "//")
            HomeApiService.dodge(idToken: idToken!, otherUid: uid!) { error, statusCode in
//                print(statusCode)
                if let error = error {
                    switch error {
                    case .firebaseTokenError(let errorContent):
                        FireBaseService.getIdToken(completion: nil)
                    case .serverError(let errorContent), .clientError(let errorContent), .alreadyWithdrawl(let errorContent):
                        self.view.makeToast(errorContent)
                    }
                    self.completion?(statusCode, self.uid)
                } else {
                    if statusCode == 200 {
                        self.completion?(statusCode, self.uid)
                    }else {
                        self.completion?(statusCode, self.uid)
                    }
                    
                }
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    private func buttonForBasic() {
        let idToekn = UserDefaults.standard.string(forKey: "idToken")
        ApiService.deleteUser(idToken: idToekn!) { error, statusCode in
            if let error = error {
                switch error {
                case .firebaseTokenError(let errorContent):
                    FireBaseService.getIdToken(completion: nil)
                    self.view.makeToast(errorContent)
                case .serverError(let errorContent):
                    self.view.makeToast(errorContent)
                case .clientError(let errorContent):
                    self.view.makeToast(errorContent)
                case .alreadyWithdrawl(let errorContent):
                    self.view.makeToast(errorContent)
                }
            }
            
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            
            windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: OnboardingViewController())
            windowScene.windows.first?.makeKeyAndVisible()
    }
    }


    
}
