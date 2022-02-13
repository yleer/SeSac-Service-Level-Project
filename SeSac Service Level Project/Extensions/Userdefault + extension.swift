//
//  Userdefault + extension.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/23.
//

import Foundation

extension UserDefaults {
    enum myKey: String {
        case email
        case age
        case authVerificationID
        case idToken
        case userPhoneNumber
        case nickName
        case fcmToken
        case CurrentUserState
    }
}
