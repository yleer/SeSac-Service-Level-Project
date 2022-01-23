//
//  EmailViewController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/20.
//


import UIKit

class EmailViewController: UIViewController {
    
    let mainView = EmailView()
    let viewModel = EmailViewModel()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bindings()
        addTargets()
        mainView.emailTextFieldView.textField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainView.emailTextFieldView.textField.becomeFirstResponder()
        
        if let email = UserDefaults.standard.string(forKey: "email") {
            viewModel.email.value = email
            mainView.toNextButton.stateOfButton = .fill
        }
    }
    
    func bindings() {
        viewModel.email.bind { text in
            self.mainView.emailTextFieldView.textField.text = text
        }
    }
    
    func addTargets() {
        mainView.emailTextFieldView.textField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        mainView.toNextButton.addTarget(self, action: #selector(toNextButtonClicked), for: .touchUpInside)
    }
    
    
    @objc func emailChanged(_ textField: UITextField) {
        viewModel.email.value = textField.text ?? ""
        
        if viewModel.isValidEmail(){
            mainView.toNextButton.stateOfButton = .fill
        }else {
            mainView.toNextButton.stateOfButton = .cancel
        }
    }
    
    @objc func toNextButtonClicked() {
        if viewModel.isValidEmail() {
            let vc = GenderSelectionViewController()
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let alertVC = UIAlertController(title: "이메일 형식이 올바르지 않습니다", message: "", preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alertVC.addAction(cancelButton)
            present(alertVC, animated: true, completion: nil)
            
        }
    }
}

extension EmailViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        mainView.emailTextFieldView.stateOfTextField = .focus
    }
}
