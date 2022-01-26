//
//  ViewController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/17.
//

import UIKit
import Toast

final class RegisterViewController: UIViewController {

    private let mainView = RegisterView()
    private let viewModel = RegisterViewModel()
    
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
    
    private func binding() {
        viewModel.phoneNumber.bind { text in
            self.mainView.phoneNumberView.textField.text = text
        }
    }
    
    private func addTargets() {
        mainView.getVerificationCodeButton.addTarget(self, action: #selector(changeState), for: .touchUpInside)
        mainView.phoneNumberView.textField.addTarget(self, action: #selector(phoneNumberChanged), for: .editingChanged)
    }
    
    
    @objc func phoneNumberChanged(_ textField: UITextField) {
        viewModel.phoneNumber.value = textField.text ?? ""
        mainView.getVerificationCodeButton.stateOfButton = viewModel.checkPhoneNumberState()
        textField.text = textField.text?.format(with:  "XXX-XXXX-XXXX")
        
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
        if mainView.getVerificationCodeButton.stateOfButton == .cancel {
            self.view.makeToast("잘못된 번호 형식입니다")
        }else {
            FireBaseService.sendMessage(phoneNumber: viewModel.getInternationalPhoneNum())
            let vc = VerifiyPhoneNumberViewController()
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        mainView.phoneNumberView.stateOfTextField = .focus
    }
}

