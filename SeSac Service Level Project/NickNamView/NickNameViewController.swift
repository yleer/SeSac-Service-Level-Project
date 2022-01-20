//
//  NickNameViewController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/19.
//

import UIKit

class NickNameViewController: UIViewController {
    
    let mainView = NickNameView()
    let viewModel = NickNameViewModel()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindings()
        addTargets()
        mainView.nickNameTextFieldView.textField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.nickNameTextFieldView.textField.becomeFirstResponder()
    }
    
    func bindings() {
        viewModel.nickName.bind { text in
            self.mainView.nickNameTextFieldView.textField.text = text
        }
    }
    
    func addTargets() {
        mainView.nickNameTextFieldView.textField.addTarget(self, action: #selector(nickNameChanged), for: .editingChanged)
        mainView.toNextButon.addTarget(self, action: #selector(toNextButtonClicked), for: .touchUpInside)
    }
    
    @objc func nickNameChanged(_ textField: UITextField) {
        viewModel.nickName.value = textField.text ?? ""
        if viewModel.checkNickName(){
            mainView.toNextButon.stateOfButton = .fill
        }else {
            mainView.toNextButon.stateOfButton = .cancel
        }
    }
    
    @objc func toNextButtonClicked() {
        if viewModel.checkNickName() {
            UserDefaults.standard.set(viewModel.nickName.value, forKey: "nickName")
            let vc = BirthViewController()
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let alertVC = UIAlertController(title: "닉네임은 1자 이상 10자 이내로 부탁드려요", message: "", preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alertVC.addAction(cancelButton)
            present(alertVC, animated: true, completion: nil)
            
        }
        
    }
    
}

extension NickNameViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        mainView.nickNameTextFieldView.stateOfTextField = .focus
    }
}
