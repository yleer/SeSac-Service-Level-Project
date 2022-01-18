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
    
    
    
    
    // binding 문제가 있긴 한데. 이거 안해도 작동은 다 함.
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
        print(viewModel.phoneNumber.value)
        viewModel.phoneNumber.value = textField.text ?? ""
        mainView.getVerificationCodeButton.stateOfButton = viewModel.checkPhoneNumberState()
        let formattedPhoneNumber = format(with:  "XXX-XXXX-XXXX", phone: textField.text ?? "")
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
        view.endEditing(true)
        print(viewModel.getInternationalPhoneNum())
    }
    
    func format(with mask: String, phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator
        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
    
    
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        mainView.phoneNumberView.stateOfTextField = .focus
    }
    
    
    
    //
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        let status = viewModel.checkTextFieldState()
//        switch status {
//        case .inActive:
//            <#code#>
//        case .focus:
//            <#code#>
//        case .active:
//            <#code#>
//        case .disable:
//            <#code#>
//        case .error(let text):
//            <#code#>
//        case .success(let text):
//            <#code#>
//        }
//    }
}

extension String {
    subscript(idx: Int) -> String? {
        guard (0..<count).contains(idx) else {
            return nil
        }
        let result = index(startIndex, offsetBy: idx)
        return String(self[result])
    }
}
