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
                  UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
              }
          }
    }
    
    static func verifyCodeFromFirebase(verificationCode: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        let credential = PhoneAuthProvider.provider().credential(
          withVerificationID: verificationID!,
          verificationCode: verificationCode
        )
        Auth.auth().signIn(with: credential, completion: completion)
    }
    
    static func getIdToken() {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
          if let error = error {
            print(error)
            return
          }
            UserDefaults.standard.set(idToken!, forKey: "idToken")
        }
    }
}
