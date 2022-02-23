//
//  ShopApiService.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/20.
//

import Foundation
import Alamofire

class ShopApiService {
    
    static func updateMyState(idToken: String, sesac: Int, background: Int, completion:  ((APIError?, Int) -> Void)?) {
        let headers: HTTPHeaders = ["idtoken": idToken]
        let p: Parameters = [
            "sesac": sesac,
            "background": background
        ]
        
        AF.request(
            EndPoint.updateShop.url,
            method: .post,
            parameters: p,
            headers: headers
        ).responseData { response in
            switch response.result {
            case .success(_):
                guard let statusCode = response.response?.statusCode else { return }
                print(statusCode)
                if statusCode == 200{
                    completion?(nil, statusCode)
                }else if statusCode == 201 {
                    completion?(nil, statusCode)
                }else {
                    ApiService.handleErrorCodes(statusCode: statusCode, completion: completion)
                }
            case .failure(let error):
                print("what kind of error", error)
            }
        }
    }
    
    static func buyItem(idToken: String, receipt: String, product: String, completion:  ((APIError?, Int) -> Void)?) {
        let headers: HTTPHeaders = ["idtoken": idToken]
        let p: Parameters = [
            "receipt": receipt,
            "product": product
        ]
        AF.request(
            EndPoint.shopIos.url,
            method: .post,
            parameters: p,
            headers: headers
        ).responseData { response in
            switch response.result {
            case .success(let value):
                guard let statusCode = response.response?.statusCode else { return }
                if statusCode == 200{
                    completion?(nil, statusCode)
                }else if statusCode == 201 {
                    completion?(nil, statusCode)
                }else {
                    completion?(nil, statusCode)
                    ApiService.handleErrorCodes(statusCode: statusCode, completion: completion)
                }
            case .failure(let error):
                print("what kind of error", error)
            }
        }
        
    }
    
    static func getMyShopInfo(idToken: String, completion:  ((APIError?, Int) -> Void)?) {
        let headers: HTTPHeaders = ["idtoken": idToken]
        
        AF.request(
            EndPoint.shopMyInfo.url,
            method: .get,
            headers: headers
        ).responseData { response in
            switch response.result {
            case .success(let value):
                guard let statusCode = response.response?.statusCode else { return }
                if statusCode == 200{
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(User.self, from: value)
                        UserInfo.current.user = result
                        completion?(nil, statusCode)
                    }catch {
                        print("chat info decoding error : ", error)
                        completion?(nil, statusCode)
                    }
                }else {
                    ApiService.handleErrorCodes(statusCode: statusCode, completion: completion)
                }
            case .failure(let error):
                print("what kind of error", error)
            }
        }
    }
}
