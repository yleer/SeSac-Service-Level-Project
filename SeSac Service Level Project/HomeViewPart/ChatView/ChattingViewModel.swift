//
//  ChattingViewModel.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/13.
//

import Foundation
import RealmSwift

final class ChattingViewModel {
    
    var uid: String!
    
    func myState(completion: @escaping (APIError?, Int) -> Void ) {
        if let idToken = UserDefaults.standard.string(forKey: UserDefaults.myKey.idToken.rawValue) {
            HomeApiService.myQueueState(idToken: idToken) { error, statusCode in
                completion(error, statusCode)
            }
        }
    }
    
    init() {
        guard let uid = UserInfo.current.matchedUid else { return }
        self.uid = uid
    }
    
    
    
    // MARK: Realm Part
    
    let localRealm = try! Realm()
    var firstLoadData: Results<ChatRealmData>?
    
    
    func addChatToRealm(chat: String, createdAt: String, to: String, from: String) {
        let task = ChatRealmData(to: to, from: from, message: chat, createdAt: createdAt)
        try! localRealm.write {
            localRealm.add(task)
        }
    }
    
    func loadFromRealm() {
        firstLoadData = localRealm.objects(ChatRealmData.self)
        if let data = firstLoadData {
            firstLoadData = data.where{
                $0.to.equals(uid)
            }
        }
    }
    
    private func checkLastMessage(completion: @escaping (String) -> Void) {
        if let firstLoadData = firstLoadData {
            if firstLoadData.count > 0 {
                getChatHistory(date: firstLoadData.last!.createdAt, completion: completion)
            }else {
                getChatHistory(date: "2000-01-01T00:00:00.000Z",completion: completion)
            }
        }
    }
    
    private func getChatHistory(date: String, completion: @escaping (String) -> Void) {
        guard let idToken = UserDefaults.standard.string(forKey: UserDefaults.myKey.idToken.rawValue) else { return }
        HomeApiService.getChatHistory(idToken: idToken, otherUid: uid, date: date) { error, statusCode, chatData in
            if statusCode == 200 {
                if let chatData = chatData {
                    for chat in chatData.payload {
                        self.addChatToRealm(chat: chat.chat, createdAt: chat.createdAt, to: chat.to, from: chat.from)
                    }
                    
                    self.loadFromRealm()
                }
            }else {
                switch error! {
                    
                case .firebaseTokenError(errorContent: let errorContent):
                    completion(errorContent)
                case .serverError(errorContent: let errorContent):
                    completion(errorContent)
                case .clientError(errorContent: let errorContent):
                    completion(errorContent)
                case .alreadyWithdrawl(errorContent: let errorContent):
                    completion(errorContent)
                }
            }
        }
        
    }
}
