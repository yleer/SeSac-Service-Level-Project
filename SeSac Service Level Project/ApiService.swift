//
//  ApiService.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/21.
//

import Foundation
import Alamofire
import SwiftUI

enum APIError: Error {
    case firebaseTokenError(errorContent: String)
    case serverError(errorContent: String)
    case clientError(errorContent: String)
    case alreadyWithdrawl(errorContent: String)
}

class ApiService {
    
    // MARK: Get
    static func getUserInfo(idToken: String, completion: @escaping (APIError?, Int) -> Void) {
        
        let headers: HTTPHeaders = ["idtoken": idToken]
        
        AF.request(EndPoint.getUserInfo.url, method: .get, headers: headers).responseData { response in
            switch response.result {
            case .success(let value):
                guard let statusCode = response.response?.statusCode else { return }
                if statusCode == 200 {
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(User.self, from: value)
                        print(result)
                        UserInfo.current.user = result
                    }catch {
                        print("user info decoding error : ", error)
                    }
                    completion(nil, 200)
                }else if statusCode == 201 {
                    print("need  to make account")
                    completion(nil, 201)
                }else {
                    handleErrorCodes(statusCode: statusCode, completion: completion)
                }
            case .failure(let error):
                print("error", error)
            }
        }
    }
    
    
    // MARK: POST
    
    static func deleteUser(idToken: String, completion: @escaping (APIError?, Int) -> Void) {
        let headers: HTTPHeaders = ["idtoken": idToken]
        AF.request(EndPoint.withdraw.url, method: .post, headers: headers).responseString { response in
            switch response.result {
            case .success(_):
                guard let statusCode = response.response?.statusCode else { return }
                handlePostCall(statusCode: statusCode, completion: completion)
            case .failure(let error):
                print("error", error)
            }
        }
    }
    
    static func updateUserInfo(searchable: Int, min: Int, max: Int, gender: Int, hobby:String?, idToken: String, completion: @escaping (APIError?, Int) -> Void) {
        
        let headers: HTTPHeaders = ["idtoken": idToken]
        
        let parameter = MyInfoUpdateParameter(
            searchable: searchable,
            ageMin: min, ageMax: max,
            gender: gender, hobby: hobby
        )
        
        AF.request(EndPoint.updateMypage.url, method: .post, parameters: parameter, headers: headers).responseData { response in
            switch response.result {
            case .success(_):
                guard let statusCode = response.response?.statusCode else { return }
                handlePostCall(statusCode: statusCode, completion: completion)
            case .failure(_):
                print("error")
            }
        }
    }
    
    static func register(phoneNumber: String, fcmToken: String, nickName: String, birth: String, email: String, gender: Int, idToken: String, completion: @escaping (APIError?, Int) -> Void) {
        
        print(gender, "from apiService")
        let parameter = RegisterParameter(
            phoneNumber: phoneNumber,
            FCMtoken: fcmToken, nick: nickName, birth: birth,
            email: email, gender: gender
        )
        
        let headers: HTTPHeaders = ["idtoken": idToken]

        AF.request(EndPoint.register.url, method: .post, parameters: parameter, encoder: JSONParameterEncoder.prettyPrinted, headers: headers).responseString { response in
            switch response.result {
            case .success(_):
                guard let statusCode = response.response?.statusCode else { return }
                handlePostCall(statusCode: statusCode, completion: completion)
            case .failure(let error):
                print("error", error)
            }
        }
    }
    
    static func requestToFindFriends(idToken: String, parameter: FindRequestParameter, completion: @escaping (APIError?, Int) -> Void) {
        
        let headers: HTTPHeaders = ["idtoken": idToken]
        
        let p = FindRequestParameter(type: 2, region: 1274830692, lat: 37.48511640269022, long: 126.92947109241517, hf: ["aa"])
        
    
        AF.request(EndPoint.requestToFindFirends.url, method: .post, parameters: p,encoder: .urlEncodedForm() ,headers: headers).responseData { response in
            switch response.result {
            case .success(_):
                guard let statusCode = response.response?.statusCode else { return }
                
                if statusCode == 201{
                    completion(nil, statusCode)
                }else if statusCode == 203{
                    completion(nil, statusCode)
                }else if statusCode == 204{
                    completion(nil, statusCode)
                }else if statusCode == 205{
                    completion(nil, statusCode)
                }else if statusCode == 206{
                    completion(nil, statusCode)
                }
                handlePostCall(statusCode: statusCode, completion: completion)
            case .failure(_):
                print("error")
            }
        }
    }
    
    static func handlePostCall(statusCode: Int, completion: @escaping (APIError?, Int) -> Void) {
        switch statusCode {
        case 200:
            completion(nil, statusCode)
        case 201:
            completion(nil, statusCode)
        case 202:
            completion(nil, statusCode)
        case 400...599:
            handleErrorCodes(statusCode: statusCode, completion: completion)
        default:
            print(statusCode)
        }
    }
    
    static func handleErrorCodes(statusCode: Int, completion: @escaping (APIError?, Int) -> Void) {
        switch statusCode {
        case 401:
            completion(.firebaseTokenError(errorContent: "에러가 발생했습니다. 잠시 후 다시 실행해주세요."), statusCode)
        case 406:
            completion(.alreadyWithdrawl(errorContent: "이미 탈퇴된 회원"), statusCode)
        case 500:
            completion(.serverError(errorContent: "서버에 문제가 있습니다"), statusCode)
        case 501:
            completion(.clientError(errorContent: "클라이언트 오류"), statusCode)
        default:
            print(statusCode)
        }
    }
}

