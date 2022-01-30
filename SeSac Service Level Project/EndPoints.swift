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
            
            
            
//        case .login:
//            return .makeEndPoint("auth/local")
//        case .board(id: let id):
//            if let id = id {
//                return .makeEndPoint("posts/\(id)")
//            }else{
//                return .makeEndPoint("posts")
//            }
//
//        case .comments(id: let id):
//            if let id = id {
//                return .makeEndPoint("comments/\(id)")
//            }
//            return .makeEndPoint("comments")
//
//        case .changePassword:
//            return .makeEndPoint("custom/change-password")
//        case .boardPageing(start: let start, limit: let limit):
//            return .makeEndPoint("posts?_sort=created_at:desc&_start=\(start)&_limit=\(limit)")
        }
    }
}

extension URL {
    static let baseUrl = "http://test.monocoding.com:35484"
    
    static func makeEndPoint(_ endPoint: String) -> URL {
        return URL(string: URL.baseUrl + endPoint)!
    }
}
