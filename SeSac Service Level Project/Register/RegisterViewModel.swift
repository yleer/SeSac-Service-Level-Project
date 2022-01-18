//
//  RegisterViewModel.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/18.
//

import Foundation

class RegisterViewModel {
    
    var phoneNumber: Observalble<String> = Observalble("")
    
    // need to check phoneNumber state and change the button accoring to state.
    
    func checkPhoneNumberState() -> ButtonState {
        phoneNumber.value = phoneNumber.value.replacingOccurrences(of: "-", with: "")
//        print(phoneNumber.value)

        if phoneNumber.value.count >= 11 {
            return .fill
        }else {
            return .disable
        }
    }
    
    func getInternationalPhoneNum() -> String {
        let num = String(phoneNumber.value.dropFirst())
        
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
}
