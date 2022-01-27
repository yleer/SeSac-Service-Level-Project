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
    
    static func verifyCodeFromFirebase(verificationCode: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        let verificationID = UserDefaults.standard.string(forKey: UserDefaults.myKey.authVerificationID.rawValue)
        let credential = PhoneAuthProvider.provider().credential(
          withVerificationID: verificationID!,
          verificationCode: verificationCode
        )
        Auth.auth().signIn(with: credential, completion: completion)
    }
    
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
