//
//  RegisterViewModel.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/18.
//

import Foundation

import FirebaseAuth
import Firebase

class RegisterViewModel {
    
    var phoneNumber: Observalble<String> = Observalble("")
    
    // need to check phoneNumber state and change the button accoring to state.
    
    func checkPhoneNumberState() -> ButtonState {
        phoneNumber.value = phoneNumber.value.replacingOccurrences(of: "-", with: "")
//        print(phoneNumber.value)

        if phoneNumber.value.count >= 11 {
            let textFieldStatus = checkTextFieldState()

            switch textFieldStatus {
            case .error:
                return .disable
            case .success:
                return .fill
            default:
                return .disable
            }
        }else {
            return .disable
        }
    }
    
    func getInternationalPhoneNum() -> String {
        let num = String(phoneNumber.value.dropFirst())
        UserDefaults.standard.set("+82" + num, forKey: "userPhoneNumber")
        return "+82" + num
    }
    
    func checkTextFieldState() -> TextFieldState {
        let text = phoneNumber.value
        if text.count >= 11{
            let first = text[0]! + text[1]! + text[2]!
            if first == "010" {
                return .success(text: "번호 입력 완료")
                
            }else {
                return .error(text: "올바른 번호가 아닙니다")
            }
        }else{
            return .error(text: "11자리 핸드폰 번호를 입력해 주세요")
        }
    }
    
    func sendMessage() {
        let phoneNumber = getInternationalPhoneNum()
        print(phoneNumber)
        PhoneAuthProvider.provider()
          .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
              if let error = error {
                print(error.localizedDescription)
                return
              }else{
                  UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
              }
          }
    }
}
