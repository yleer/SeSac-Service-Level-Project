//
//  HomeApiService.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/05.
//

import Foundation
import Alamofire


class HomeApiService {
    
    static func acceptRequest(idToken: String, otherUid: String, completion: @escaping (APIError?, Int) -> Void) {
        let headers: HTTPHeaders = ["idtoken": idToken]
        let p: Parameters = [
            "otheruid": otherUid
        ]
        AF.request(
            EndPoint.acceptRequest.url,
            method: .post,
            parameters: p,
            headers: headers
        ).responseData { response in
            switch response.result {
            case .success(let value):
                guard let statusCode = response.response?.statusCode else { return }
                
                print(statusCode)
                
                
                if statusCode == 200{
                    completion(nil, statusCode)
                }else if statusCode == 201 {
                    completion(nil, statusCode)
                }else if statusCode == 202 {
                    completion(nil, statusCode)
                }else if statusCode == 401 {
                    completion(nil, statusCode)
                }else if statusCode == 406 {
                    completion(nil, statusCode)
                }else if statusCode == 500 {
                    completion(nil, statusCode)
                }else if statusCode == 501 {
                    completion(nil, statusCode)
                }
              
            case .failure(let error):
                print("what kind of error", error)
            }
        }
    }
    
    static func sendMessage(idToken: String, otherUid: String, message: String, completion: @escaping (APIError?, Int, Payload?) -> Void) {
        let headers: HTTPHeaders = ["idtoken": idToken]
        let p: Parameters = [
            "chat": message
        ]
        
        let url = "http://test.monocoding.com:35484/chat/\(otherUid)"
        
        AF.request(
            url,
            method: .post,
            parameters: p,
            headers: headers
        ).responseData { response in
            switch response.result {
            case .success(let value):
                guard let statusCode = response.response?.statusCode else { return }
                print(statusCode, "from sending chat")
                
                if statusCode == 200{
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(Payload.self, from: value)
                        print(result, "send completed")
                        completion(nil, statusCode, result)
                    }catch {
                        print("Payload info decoding error : ", error)
                        completion(nil, statusCode, nil)
                    }
                }else if statusCode == 201 {
                    
                }else if statusCode == 401 {
                    completion(nil, statusCode, nil)
                }else if statusCode == 406 {
                    completion(nil, statusCode, nil)
                }else if statusCode == 500 {
                    completion(nil, statusCode, nil)
                }else if statusCode == 501 {
                    completion(nil, statusCode, nil)
                }
              
            case .failure(let error):
                print("what kind of error", error)
            }
        }
    }
    
    static func requestFriend(idToken: String, otherUid: String, completion: @escaping (APIError?, Int) -> Void) {
        let headers: HTTPHeaders = ["idtoken": idToken]
        let p: Parameters = [
            "otheruid": otherUid
        ]
        AF.request(
            EndPoint.requestFreind.url,
            method: .post,
            parameters: p,
            headers: headers
        ).responseData { response in
            switch response.result {
            case .success(let value):
                guard let statusCode = response.response?.statusCode else { return }
                print(statusCode)
                if statusCode == 200{
                    completion(nil, statusCode)
                }else if statusCode == 201 {
                    completion(nil, statusCode)
                }else if statusCode == 202 {
                    completion(nil, statusCode)
                }else if statusCode == 401 {
                    completion(nil, statusCode)
                }else if statusCode == 406 {
                    completion(nil, statusCode)
                }else if statusCode == 500 {
                    completion(nil, statusCode)
                }else if statusCode == 501 {
                    completion(nil, statusCode)
                }
              
            case .failure(let error):
                print("what kind of error", error)
            }
        }
        
    }
    
    static func getChatHistory(idToken: String, otherUid: String, date: String, completion: @escaping (APIError?, Int, ChatData?) -> Void) {
        let headers: HTTPHeaders = ["idtoken": idToken]
        let url = "http://test.monocoding.com:35484/chat/\(otherUid)?lastchatDate=\(date)"
        
        AF.request(
            url,
            method: .get,
            headers: headers
        ).responseData { response in
            switch response.result {
            case .success(let value):
                guard let statusCode = response.response?.statusCode else { return }
                if statusCode == 200{
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(ChatData.self, from: value)
  
                        completion(nil, statusCode, result)
                    }catch {
                        print("chat info decoding error : ", error)
                        completion(nil, statusCode, nil)
                    }
                }else if statusCode == 401 {
                    completion(nil, statusCode, nil)
                }else if statusCode == 406 {
                    completion(nil, statusCode, nil)
                }else if statusCode == 500 {
                    completion(nil, statusCode, nil)
                }
              
            case .failure(let error):
                print("what kind of error", error)
            }
        }
    }

    
    static func myQueueState(idToken: String, completion: @escaping (APIError?, Int) -> Void) {
        
        let headers: HTTPHeaders = ["idtoken": idToken]

        AF.request(
            EndPoint.myQueueState.url,
            method: .get,
            headers: headers
        ).responseData { response in
            switch response.result {
            case .success(let value):
                guard let statusCode = response.response?.statusCode else { return }
                if statusCode == 200{
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(UserMatchingState.self, from: value)
                        UserInfo.current.dodged = result.dodged
                        UserInfo.current.matchedNick = result.matchedNick
                        UserInfo.current.reviewed = result .reviewed
                        UserInfo.current.matched = result.matched
                        UserInfo.current.matchedUid = result.matchedUid
                        completion(nil, statusCode)
//                        print("well done, \(result)")
                    }catch {
                        print("user info decoding error : ", error)
                        completion(nil, statusCode)
                    }
                }else if statusCode == 201 {
                    // 매칭 대기 상태가 아닌 상태, 매칭이 되지 않아 종료된 상태 -> toast 필요
                    completion(nil, statusCode)
                }else if statusCode == 401 {
                    completion(nil, statusCode)
                }else if statusCode == 406 {
                    completion(nil, statusCode)
                }else if statusCode == 500 {
                    completion(nil, statusCode)
                }
              
            case .failure(let error):
                print("what kind of error", error)
            }
        }
    }
    
    static func stopFinding(idToken: String, completion: @escaping (APIError?, Int) -> Void) {
        let headers: HTTPHeaders = ["idtoken": idToken]
        AF.request(
            EndPoint.requestToFindFirends.url,
            method: .delete,
            headers: headers
        ).responseData { response in
            switch response.result {
            case .success(_):
                guard let statusCode = response.response?.statusCode else { return }
                
                if statusCode == 200{
                   completion(nil, statusCode)
                }else if statusCode == 201 {
                    completion(nil, statusCode)
                }else if statusCode == 401 {
                    completion(.firebaseTokenError(errorContent: "FCM 갱신해주세요"), statusCode)
                }else if statusCode == 406 {
                    completion(.alreadyWithdrawl(errorContent: "이미 탈되된 회원입니다"), statusCode)
                }else if statusCode == 500 {
                    completion(.serverError(errorContent: "서버에 문제가 있습니다"), statusCode)
                }
              
            case .failure(let error):
                print("what kind of error", error)
            }
        }
    }
    
    static func review(idToken: String, otherUid: String, reputation: [Int], comment: String, completion: @escaping (APIError?, Int) -> Void) {
        let headers: HTTPHeaders = ["idtoken": idToken]
        
        let p: Parameters = [
            "otheruid": otherUid,
            "reputation": reputation,
            "comment": comment
        ]
        
        let url = "http://test.monocoding.com:35484/queue/rate/\(otherUid)"
        
        AF.request(
            url,
            method: .post,
            parameters: p,
            encoding: URLEncoding(arrayEncoding: .noBrackets) ,
            headers: headers
        ).responseData { response in
            switch response.result {
            case .success(_):
                guard let statusCode = response.response?.statusCode else { return }
                if statusCode == 200{
                   completion(nil, statusCode)
                }else if statusCode == 401 {
                    completion(.firebaseTokenError(errorContent: "FCM 갱신해주세요"), statusCode)
                }else if statusCode == 406 {
                    completion(.alreadyWithdrawl(errorContent: "이미 탈되된 회원입니다"), statusCode)
                }else if statusCode == 500 {
                    completion(.serverError(errorContent: "서버에 문제가 있습니다"), statusCode)
                }else if statusCode == 501 {
                    completion(.clientError(errorContent: "클라이언트 애러"), statusCode)
                }
            case .failure(let error):
                print("what kind of error", error)
            }
        }
        
    }
    
    static func report(idToken: String, otherUid: String, report: [Int], comment: String, completion: @escaping (APIError?, Int) -> Void) {
        let headers: HTTPHeaders = ["idtoken": idToken]
        
        let p: Parameters = [
            "otheruid": otherUid,
            "reportedReputation": report,
            "comment": comment
        ]
        AF.request(
            EndPoint.report.url,
            method: .post,
            parameters: p,
            encoding: URLEncoding(arrayEncoding: .noBrackets) ,
            headers: headers
        ).responseData { response in
            
            switch response.result {
            case .success(_):
                guard let statusCode = response.response?.statusCode else { return }
                if statusCode == 200{
                   completion(nil, statusCode)
                }else if statusCode == 401 {
                    completion(.firebaseTokenError(errorContent: "FCM 갱신해주세요"), statusCode)
                }else if statusCode == 406 {
                    completion(.alreadyWithdrawl(errorContent: "이미 탈되된 회원입니다"), statusCode)
                }else if statusCode == 500 {
                    completion(.serverError(errorContent: "서버에 문제가 있습니다"), statusCode)
                }else if statusCode == 501 {
                    completion(.clientError(errorContent: "클라이언트 애러"), statusCode)
                }
            case .failure(let error):
                print("what kind of error", error)
            }
        }
        
        
    }
    
    static func dodge(idToken: String, otherUid: String, completion: @escaping (APIError?, Int) -> Void) {
        let headers: HTTPHeaders = ["idtoken": idToken]
        
        let p: Parameters = [
            "otheruid": otherUid
        ]
        
        AF.request(
            EndPoint.dodge.url,
            method: .post,
            parameters: p,
            headers: headers
        ).responseData { response in
            
            switch response.result {
            case .success(_):
                guard let statusCode = response.response?.statusCode else { return }
                if statusCode == 200{
                   completion(nil, statusCode)
                }else if statusCode == 201 {
                    completion(nil, statusCode)
                }else if statusCode == 401 {
                    completion(.firebaseTokenError(errorContent: "FCM 갱신해주세요"), statusCode)
                }else if statusCode == 406 {
                    completion(.alreadyWithdrawl(errorContent: "이미 탈되된 회원입니다"), statusCode)
                }else if statusCode == 500 {
                    completion(.serverError(errorContent: "서버에 문제가 있습니다"), statusCode)
                }else if statusCode == 501 {
                    completion(.clientError(errorContent: "클라이언트 애러"), statusCode)
                }
            case .failure(let error):
                print("what kind of error", error)
            }
        }
    }
    
    
    
    static func onqueue(idToken: String, region: Int, lat: Double, long: Double, completion: @escaping (APIError?, Int, OnqueueData?) -> Void) {
        let headers: HTTPHeaders = ["idtoken": idToken]
        
        let p: Parameters = [
            "region": region,
            "lat": lat,
            "long": long
        ]
        
        AF.request(
            EndPoint.onqueue.url,
            method: .post,
            parameters: p,
            headers: headers
        ).responseData { response in
            
            
            switch response.result {
            case .success(let value):
                guard let statusCode = response.response?.statusCode else { return }
                if statusCode == 200 {
            
                    let decoder = JSONDecoder()
                    let data = try! decoder.decode(OnqueueData.self, from: value)
                    completion(nil, statusCode, data)
                }else {
//                    handlePostCall(statusCode: statusCode, completion: completion)
                }
            case .failure(let error):
                print("what kind of error", error)
            }
        }
    }
    
}
