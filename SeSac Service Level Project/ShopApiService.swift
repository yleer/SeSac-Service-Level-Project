//
//  ShopApiService.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/20.
//

import Foundation
import Alamofire

class ShopApiService {
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
