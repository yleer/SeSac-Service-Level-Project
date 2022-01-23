//
//  NickNameViewModel.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/19.
//

import Foundation

class NickNameViewModel {
    
    var nickName: Observalble<String> = Observalble("")
    
    func checkNickName() -> Bool {
        if nickName.value.count > 0 && nickName.value.count <= 10 {
            UserDefaults.standard.set(nickName.value, forKey: "nickName")
            return true
        }else {
            return false
        }
    }
}
