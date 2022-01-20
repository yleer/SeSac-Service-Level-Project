//
//  VerifyPhoneNumberViewModel.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/19.
//

import Foundation
import FirebaseAuth
import Firebase

class VerifyPhoneNumberViewModel {
    
    var timeLeft: Observalble<String> = Observalble("")
    var verifyCode: Observalble<String> = Observalble("")
    
    var intCount = 300
        
        func testMain(){
            // 실시간 반복 작업 시작 실시
            stopTimer()
            intCount = 300
            startTimer()
        }
    
        // [실시간 반복 작업 시작 호출]
        var timer : Timer?
    
        func startTimer(){
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
        }
    
        // [실시간 반복 작업 수행 부분]
        @objc func timerCallback() {
            let minute = (intCount % 3600 ) / 60
            let second = (intCount % 3600 ) % 60
            
            if second < 10 {
                timeLeft.value = String(minute) + ":" + "0" + String(second)
            }else {
                timeLeft.value = String(minute) + ":" + String(second)
            }
//            print(timeLeft.value)
            // [처리할 로직 작성 실시]
//            timeLeft.value = String(intCount) // UI 카운트 값 표시 실시
            intCount -= 1 // 1씩 카운트 값 증가 실시
            if intCount == 0 { // 카운트 값이 5인 경우
                stopTimer() // 타이머 종료 실시
                timeLeft.value = "0:00"
                print("done")
            }
        }
    
        // [실시간 반복 작업 정지 호출]
        func stopTimer(){
            // [실시간 반복 작업 중지]
            if timer != nil && timer!.isValid {
                timer!.invalidate()
            }
        }
    
    
    func checkPhoneNumberState() -> ButtonState {
        if verifyCode.value.count >= 6 {
            return .fill
        }else {
            return .disable
        }
    }
    
    
    func verifyCodeFromFirebase(completion: @escaping (AuthDataResult?, Error?) -> Void) {
        let verificationCode = verifyCode.value
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
        
        let credential = PhoneAuthProvider.provider().credential(
          withVerificationID: verificationID!,
          verificationCode: verificationCode
        )

//        Auth.auth().signIn(with: credential) { authResult, error in
//            if let error = error {
//                print("eeror", error)
//                return false
//            }
//            print("good code ")
//            return true
//        }
//
        Auth.auth().signIn(with: credential, completion: completion)
    }
    
    func sendMessage() {
        if let phoneNumber = UserDefaults.standard.string(forKey: "userPhoneNumber") {
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
}
