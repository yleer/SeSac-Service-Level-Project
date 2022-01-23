//
//  ViewController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/17.
//

import UIKit

class RegisterViewController: UIViewController {

    let mainView = RegisterView()
    let viewModel = RegisterViewModel()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        mainView.phoneNumberView.textField.delegate = self
        binding()
    }
    
    func binding() {
        viewModel.phoneNumber.bind { text in
            self.mainView.phoneNumberView.textField.text = text
        }
    }
    
    func addTargets() {
        mainView.getVerificationCodeButton.addTarget(self, action: #selector(changeState), for: .touchUpInside)
        mainView.phoneNumberView.textField.addTarget(self, action: #selector(phoneNumberChanged), for: .editingChanged)
    }
    
    
    @objc func phoneNumberChanged(_ textField: UITextField) {
        viewModel.phoneNumber.value = textField.text ?? ""
        mainView.getVerificationCodeButton.stateOfButton = viewModel.checkPhoneNumberState()
        
        
        let formattedPhoneNumber = textField.text?.format(with:  "XXX-XXXX-XXXX")
        textField.text = formattedPhoneNumber
        
        let textFieldState = viewModel.checkTextFieldState()
        switch textFieldState {
        case .error(let text):
            mainView.phoneNumberView.stateOfTextField = .error(text: text)
        case .success(let text):
            mainView.phoneNumberView.stateOfTextField = .success(text: text)
        default:
            print("")
        }
    }
    
    @objc func changeState() {
        // 1. 문자 보내고
        FireBaseService.sendMessage(phoneNumber: viewModel.getInternationalPhoneNum())
        // 2. 화면 전환
        let vc = VerifiyPhoneNumberViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        mainView.phoneNumberView.stateOfTextField = .focus
    }
}

