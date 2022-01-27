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
        
//        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        view.isOpaque = false
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

    @objc func confurmButtonClicked() {
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
