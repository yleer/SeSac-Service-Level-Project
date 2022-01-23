//
//  EmailViewController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/20.
//


import UIKit
import Toast

final class EmailViewController: UIViewController {
    
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
        mainView.toNextButton.stateOfButton = viewModel.checkForPreviousData()
    }
    
    private func bindings() {
        viewModel.email.bind { text in
            self.mainView.emailTextFieldView.textField.text = text
        }
    }
    
    private func addTargets() {
        mainView.emailTextFieldView.textField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        mainView.toNextButton.addTarget(self, action: #selector(toNextButtonClicked), for: .touchUpInside)
    }
    
    
    @objc private func emailChanged(_ textField: UITextField) {
        viewModel.email.value = textField.text ?? ""
        
        if viewModel.isValidEmail(){
            mainView.toNextButton.stateOfButton = .fill
        }else {
            mainView.toNextButton.stateOfButton = .cancel
        }
    }
    
    @objc private func toNextButtonClicked() {
        if viewModel.isValidEmail() {
            let vc = GenderSelectionViewController()
            navigationController?.pushViewController(vc, animated: true)
        } else {
            self.view.makeToast(ToastMessage.notValidEmail.rawValue)
        }
    }
}

extension EmailViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        mainView.emailTextFieldView.stateOfTextField = .focus
    }
}


