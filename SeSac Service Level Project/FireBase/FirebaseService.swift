//
//  FirebaseService.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/22.
//

import Foundation
import Firebase
import FirebaseAuth

class FireBaseService{
    
    // MARK: 문자 인증시, 문자 보내는 함수.
    static func sendMessage(phoneNumber: String) {
        PhoneAuthProvider.provider()
          .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
              if let error = error {
                print(error.localizedDescription)
                return
              }else{
                  UserDefaults.standard.set(verificationID, forKey: UserDefaults.myKey.authVerificationID.rawValue)
              }
          }
    }
    
    // MARK: 문자 인증 함수
    static func verifyCodeFromFirebase(verificationCode: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        let verificationID = UserDefaults.standard.string(forKey: UserDefaults.myKey.authVerificationID.rawValue)
        let credential = PhoneAuthProvider.provider().credential(
          withVerificationID: verificationID!,
          verificationCode: verificationCode
        )
        Auth.auth().signIn(with: credential, completion: completion)
    }
    
    // MARK: FCM token 만료시 함수를 호출하여 재발급.
    //  completion으로 발급 후 작업 가능.
    static func getIdToken(completion: (() -> Void)?) {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
          if let error = error {
            print(error.localizedDescription)
            return
          }
            UserDefaults.standard.set(idToken!, forKey: UserDefaults.myKey.idToken.rawValue)
            
            completion?()
        }
    }
}
