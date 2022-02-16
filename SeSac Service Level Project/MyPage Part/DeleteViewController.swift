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
        
        idToken = UserDefaults.standard.string(forKey: UserDefaults.myKey.idToken.rawValue)
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
    var otherUid: String!
    
    var completion: ((Int, String) -> Void)?
    
    private func updateIdToken() {
        self.idToken = UserDefaults.standard.string(forKey: UserDefaults.myKey.idToken.rawValue)
    }
    
    private func buttonForRequest() {
        HomeApiService.requestFriend(idToken: idToken, otherUid: otherUid) { error, statusCode in
            if let error = error {
                switch error {
                case .firebaseTokenError(let errorContent):
                    self.view.makeToast(errorContent)
                    self.updateIdToken()
                    self.buttonForRequest()
                case .serverError(let errorContent), .clientError(let errorContent), .alreadyWithdrawl(let errorContent):
                    self.view.makeToast(errorContent)
                }
            }
            self.completion?(statusCode, self.otherUid)
        }
        
    }

    
    private func buttonForAccept() {
        HomeApiService.acceptRequest(idToken: idToken, otherUid: otherUid) { error, statusCode in
            if let error = error {
                switch error {
                case .firebaseTokenError(let errorContent):
                    self.view.makeToast(errorContent)
                    self.updateIdToken()
                    self.buttonForAccept()
                case .serverError(let errorContent), .clientError(let errorContent), .alreadyWithdrawl(let errorContent):
                    self.view.makeToast(errorContent)
                }
            } else {
                UserInfo.current.matchedUid = self.otherUid
                self.completion?(statusCode, self.otherUid)
            }
        }
    }
    
    private func buttonForDodge() {
        HomeApiService.dodge(idToken: idToken!, otherUid: otherUid!) { error, statusCode in
            if let error = error {
                switch error {
                case .firebaseTokenError(let errorContent):
                    self.view.makeToast(errorContent)
                    self.updateIdToken()
                    self.buttonForDodge()
                case .serverError(let errorContent), .clientError(let errorContent), .alreadyWithdrawl(let errorContent):
                    self.view.makeToast(errorContent)
                }
                self.completion?(statusCode, self.otherUid)
            } else {
                self.completion?(statusCode, self.otherUid)
            }
        }
    }
    
    
    @objc func confurmButtonClicked() {
        
        switch mainView.viewType {
        case .basic:
            buttonForBasic()
        case .request:
            buttonForRequest()
        case .accept:
            buttonForAccept()
        case .dodge:
            buttonForDodge()
            
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    private func buttonForBasic() {
        let idToekn = UserDefaults.standard.string(forKey: UserDefaults.myKey.idToken.rawValue)
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
