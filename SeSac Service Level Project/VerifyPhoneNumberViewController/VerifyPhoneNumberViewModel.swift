//
//  VerifyPhoneNumberViewModel.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/19.
//

import Foundation

final class VerifyPhoneNumberViewModel {
    
    var timeLeft: Observalble<String> = Observalble("")
    var verifyCode: Observalble<String> = Observalble("")
    
    var intCount = 25
        
        func testMain(){
            // 실시간 반복 작업 시작 실시
            stopTimer()
            intCount = 25
            startTimer()
        }
    
        // [실시간 반복 작업 시작 호출]
        private var timer : Timer?
    
        func startTimer(){
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
        }
    
        // [실시간 반복 작업 수행 부분]
        @objc private func timerCallback() {
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
                
                NotificationCenter.default.post(name: NSNotification.Name("time done"), object: self)
            }
        }
    
        // [실시간 반복 작업 정지 호출]
        private func stopTimer(){
            // [실시간 반복 작업 중지]
            if timer != nil && timer!.isValid {
                timer!.invalidate()
            }
        }
    
    
    func checkPhoneNumberState() -> ButtonState {
        if verifyCode.value.count >= 6 {
            return .fill
        }else {
            return .cancel
        }
    }
    
    func verifyCodeFromFireBase(completion: @escaping (Error?, Int?) -> Void) {
        FireBaseService.verifyCodeFromFirebase(verificationCode: verifyCode.value) { authResult, error in
            if let error = error {
                print("eeror", error)
                completion(error, nil)
                return
            }
            
            FireBaseService.getIdToken()
            if let idToken = UserDefaults.standard.string(forKey: "idToken") {
                ApiService.getUserInfo(idToken: idToken) { error, statusCode in
                    if error == nil {
                        if statusCode == 200 {
                        // home 화면으로
                            completion(nil, 200)
                        }else {
                            completion(nil, 201)
                        }
                        
                    }else {
                        if statusCode == 401 {
                            completion(APIError.firebaseTokenError(errorContent: "나중에 다시 시도해 주세요"),401)
                        }else if statusCode == 500 {
                            completion(APIError.serverError(errorContent: "서버 에러"), 500)
                        }else if statusCode == 501 {
                            completion(APIError.clientError(errorContent: "사용자 에러"), 501)
                        }
                    }
                }

            }
        }
    }
    
}
