//
//  ApiData.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/21.
//

import Foundation

struct ChatData: Codable {
    let payload: [Payload]
}

// MARK: - Payload
struct Payload: Codable {
    let id: String
    let v: Int
    let to, from, chat, createdAt: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case v = "__v"
        case to, from, chat, createdAt
    }
}




struct UserMatchingState: Codable {
    let dodged, matched, reviewed: Int
//    let matchedNick, matchedUid: String
    var matchedNick, matchedUid: String?
}

//struct UserUnMatchedState: Codable {
//    let dodged, matched, reviewed: Int
//}


struct OnqueueData: Codable {
    let fromQueueDB, fromQueueDBRequested: [FromQueueDB]
    let fromRecommend: [String]
}

// MARK: - FromQueueDB
struct FromQueueDB: Codable {
    let uid, nick: String
    let lat, long: Double
    let reputation: [Int]
    let hf, reviews: [String]
    let gender, type, sesac, background: Int
}

struct RegisterParameter: Codable {
    let phoneNumber: String
    let FCMtoken: String
    let nick: String
    let birth: String
    let email: String
    let gender: Int
}


struct FindRequestParameter: Codable {
    let type: Int
    let region: Int
    let lat: Double
    let long: Double
    var hf: [String]
}

struct MyInfoUpdateParameter: Codable {
    let searchable: Int
    let ageMin: Int
    let ageMax: Int
    let gender: Int
    var hobby: String?
}

class UserInfo {
    static let current = UserInfo()
    var user: User?
    var onqueueParameter: FindRequestParameter?
    var matchedUid: String?
    var matchedNick: String?
    var matched: Int?
    var dodged: Int?
    var reviewed: Int?
    
}


struct User: Codable {
    let _id: String
    let __v: Int
    var uid, phoneNumber, email, FCMtoken: String
    let nick, birth: String
    let gender: Int
    let comment: [String]
    let reputation: [Int]
    let hobby: String
    let sesac: Int
    let sesacCollection: [Int]
    let background: Int
    let backgroundCollection: [Int]
    let purchaseToken, transactionId, reviewedBefore: [String]
    let reportedNum: Int
    let reportedUser: [String]
    let dodgeNum, ageMin, ageMax: Int
    let searchable: Int
    let createdAt: String
}

