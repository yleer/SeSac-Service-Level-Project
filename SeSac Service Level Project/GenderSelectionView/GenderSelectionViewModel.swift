//
//  GenderSelectionViewModel.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/20.
//

import Foundation

class GenderSelectionViewModel {
    
    var selectedGender: Observalble<Int> = Observalble(2)

    func getUserInfo(completion: @escaping (String?, Bool) -> Void) {
        
        guard let phone = UserDefaults.standard.string(forKey: "userPhoneNumber"), let fcmToken = UserDefaults.standard.string(forKey: "fcmToken"), let nick = UserDefaults.standard.string(forKey: "nickName"), let age = UserDefaults.standard.string(forKey: "age"), let email = UserDefaults.standard.string(forKey: "email"), let idToken = UserDefaults.standard.string(forKey: "idToken") else {
            return
        }

        ApiService.register(phoneNumber: phone, fcmToken: fcmToken, nickName: nick, birth: age, email: email, gender: selectedGender.value, idToken: idToken) { error, statusCode in
            print(statusCode)
            if let error = error {
                switch error {
                case .firebaseTokenError(let errorContent):
                    completion(errorContent, false)
                    
                    FireBaseService.getIdToken()
                case .serverError(let errorContent):
                    completion(errorContent, false)
                case .clientError(let errorContent):
                    completion(errorContent, false)
                }
            }else{
                // No error
                if statusCode == 200{
                    print("회원 가입 완료")
                    completion(nil, true)
                }else if statusCode == 201 {
                 print("이미 가입된 회원")
                    completion("사용 금지돤 닉네임입니다", true)
                }else if statusCode == 202 {
                    completion("사용 금지돤 닉네임입니다", true)
                }
            }
        }
    }
}
