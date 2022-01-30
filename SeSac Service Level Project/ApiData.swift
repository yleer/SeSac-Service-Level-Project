//
//  ApiData.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/21.
//

import Foundation

struct RegisterParameter: Encodable {
    let phoneNumber: String
    let FCMtoken: String
    let nick: String
    let birth: String
    let email: String
    let gender: Int
}


struct FindRequestParameter: Encodable {
    let type: Int
    let region: Int
    let lat: Double
    let long: Double
    let hf: [String]
}

struct MyInfoUpdateParameter: Encodable {
    let searchable: Int
    let ageMin: Int
    let ageMax: Int
    let gender: Int
    var hobby: String?
}

class UserInfo {
    static let current = UserInfo()
    var user: User?
}


struct User: Codable {
    let _id: String
    let __v: Int
    let uid, phoneNumber, email, FCMtoken: String
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

