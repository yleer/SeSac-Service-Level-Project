//
//  VerifiyPhoneNumberViewController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/19.
//

import UIKit

class VerifiyPhoneNumberViewController: UIViewController {
    
    let viewModel = VerifyPhoneNumberViewModel()
    let mainView = VerifyPhoneNumberView()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTargets()
        binding()
        mainView.verificationCodeView.textField.delegate = self
        
        viewModel.testMain()
    }
    
    
    func addTargets() {
        mainView.resendButton.addTarget(self, action: #selector(resendButtonCliked), for: .touchUpInside)
        mainView.verifyAndStartButton.addTarget(self, action: #selector(verifyButtonClicked), for: .touchUpInside)
        mainView.verificationCodeView.textField.addTarget(self, action: #selector(verificationCodeChanged), for: .editingChanged)
    }
    
    @objc func verificationCodeChanged(_ textField: UITextField) {
        viewModel.verifyCode.value = textField.text ?? ""
        mainView.verifyAndStartButton.stateOfButton = viewModel.checkPhoneNumberState()
    }
    
    @objc func resendButtonCliked() {
        // 재전송 성공 alert 보여주자 .
        view.endEditing(true)
        if let phoneNumber = UserDefaults.standard.string(forKey: "userPhoneNumber") {
            FireBaseService.sendMessage(phoneNumber: phoneNumber)
            viewModel.startTimer()
        }
    }
    
    @objc func verifyButtonClicked() {
        
        viewModel.verifyCodeFromFireBase { message, vc in
            if let message = message {
                self.view.makeToast(message)
            }else {
                if let vc = vc as? NickNameViewController{
                    self.navigationController?.pushViewController(vc, animated: true)
                }else {
                    print("홈 화면으로 이동해야됨.")
                }
            }
        }
    }
    
    func binding() {
        viewModel.timeLeft.bind { text in
            self.mainView.timerLabel.text = text
        }
        
        viewModel.verifyCode.bind { text in
            self.mainView.verificationCodeView.textField.text = text
        }
    }
    
}

extension VerifiyPhoneNumberViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        mainView.verificationCodeView.stateOfTextField = .focus
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text?.count == 0 {
            mainView.verificationCodeView.stateOfTextField = .inActive
        }else {
            mainView.verificationCodeView.stateOfTextField = .active
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 6
        let currentString: NSString = NSString(string:textField.text!)
        let newString: NSString =
        currentString.replacingCharacters(in: range, with: string) as NSString
        if newString.length <= maxLength{
            let allowedCharacters = CharacterSet.decimalDigits
                let characterSet = CharacterSet(charactersIn: string)
                return allowedCharacters.isSuperset(of: characterSet)
        }else {
            return false
        }
    }
}