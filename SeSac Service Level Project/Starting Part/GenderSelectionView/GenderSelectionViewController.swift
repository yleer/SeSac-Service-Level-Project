//
//  GenderSelectionViewController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/20.
//

import UIKit
import Toast

class GenderSelectionViewController: UIViewController {
    
    let viewModel = GenderSelectionViewModel()
    let mainView = GenderSelectionView()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        viewModel.selectedGender.value = UserDefaults.standard.integer(forKey: "gender")
        mainView.toNextButton.stateOfButton = .fill
    }
    
    @objc func addTapped() {
        
        guard let idToekn = UserDefaults.standard.string(forKey: UserDefaults.myKey.idToken.rawValue) else { return }
        ApiService.deleteUser(idToken: idToekn) { error, statusCode in
                print(error)
            print(statusCode)
        }
    }
    
    func addTargets() {
        let maleGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnMaleView))
        maleGesture.numberOfTapsRequired = 1
        
        let femaleGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOnFemaleView))
        femaleGesture.numberOfTapsRequired = 1
        
        mainView.maleButton.isUserInteractionEnabled = true
        mainView.femaleButton.isUserInteractionEnabled = true
        
        mainView.maleButton.addGestureRecognizer(maleGesture)
        mainView.femaleButton.addGestureRecognizer(femaleGesture)
    
        mainView.toNextButton.addTarget(self, action: #selector(toNextbuttonClicked), for: .touchUpInside)
    }
    
    @objc func tapOnFemaleView() {
        viewModel.selectedGender.value = 0
        mainView.femaleButton.backgroundColor = UIColor(named: "brand colorgreen")
        mainView.maleButton.backgroundColor = .white
        mainView.femaleButton.layer.borderColor = UIColor(named: "brand colorgreen")?.cgColor
        mainView.maleButton.layer.borderColor = UIColor(named: "grayscalegray3")?.cgColor
        
        mainView.toNextButton.stateOfButton = .fill
        
    }
    
    @objc func tapOnMaleView() {
        viewModel.selectedGender.value = 1
        mainView.femaleButton.backgroundColor = .white
        mainView.maleButton.backgroundColor = UIColor(named: "brand colorgreen")
        mainView.femaleButton.layer.borderColor = UIColor(named: "grayscalegray3")?.cgColor
        mainView.maleButton.layer.borderColor = UIColor(named: "brand colorgreen")?.cgColor
        mainView.toNextButton.stateOfButton = .fill
    }
    
    
    
    @objc func toNextbuttonClicked() {
        viewModel.getUserInfo { message, success in
            
            DispatchQueue.main.async {
                if success {
                    guard let message = message else {
                        
                        
                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                        
                        windowScene.windows.first?.rootViewController = MainTabBarController()
                        windowScene.windows.first?.makeKeyAndVisible()
                        return
                    }
                    // toast message ->
                    guard let viewControllerStack = self.navigationController?.viewControllers else { return }
                    for viewController in viewControllerStack {
                        if let nickNameVc = viewController as? NickNameViewController {
                            nickNameVc.notAbleNickName = true
                            self.navigationController?.popToViewController(nickNameVc, animated: true)
                        }
                    }
                }else {
                    guard let message = message else { return }
                    self.view.makeToast(message)
                }
            }
        }
    }
    
}
