//
//  EmailViewModel.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/20.
//

import Foundation

class EmailViewModel {
    var email: Observalble<String> = Observalble("")
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        if emailTest.evaluate(with: email.value) {
            UserDefaults.standard.set(email.value, forKey: UserDefaults.myKey.email.rawValue)
            return true
        } else{
            return false
        }
   }
    
    
    func checkForPreviousData() -> ButtonState {
        if let email = UserDefaults.standard.string(forKey: UserDefaults.myKey.email.rawValue) {
            self.email.value = email
            return .fill
        }
        return .cancel
    }
}
