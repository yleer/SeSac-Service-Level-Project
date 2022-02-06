//
//  EndPoints.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/22.
//

import Foundation

enum EndPoint {
    case register
    case getUserInfo
    case withdraw
    case updateFcmToken
    case updateMypage
    
    case requestToFindFirends
    case onqueue
    case myQueueState
    
}

extension EndPoint {
    var url: URL {
        switch self {
        case.register:
            return .makeEndPoint("/user")
        case .getUserInfo:
            return .makeEndPoint("/user")
        case .withdraw:
            return .makeEndPoint("/user/withdraw")
        case .updateFcmToken:
            return .makeEndPoint("/user/update_fcm_token")
        case .updateMypage:
            return .makeEndPoint("/user/update/mypage")
            
            
        case .requestToFindFirends:
            return .makeEndPoint("/queue")
        case .onqueue:
            return .makeEndPoint("/queue/onqueue")
        case .myQueueState:
            return .makeEndPoint("/queue/myQueueState")
        }
    }
}

extension URL {
    static let baseUrl = "http://test.monocoding.com:35484"
    
    static func makeEndPoint(_ endPoint: String) -> URL {
        return URL(string: URL.baseUrl + endPoint)!
    }
}
