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
        self.uid = UserInfo.current.matchedUid
        guard let idToken = UserDefaults.standard.string(forKey: UserDefaults.myKey.idToken.rawValue) else { return }
        HomeApiService.myQueueState(idToken: idToken) { error, statusCode in
            if let error = error {
                switch error {
                case .firebaseTokenError(errorContent: let errorContent):
                    print(errorContent)
                    HomeApiService.myQueueState(idToken: idToken, completion: nil)
                case .serverError(errorContent: let errorContent), .clientError(errorContent: let errorContent), .alreadyWithdrawl(errorContent: let errorContent):
                    print(errorContent)
                }
            }else {
                // 매칭된 상태이기 때문에 201번 코드 무시
                self.uid = UserInfo.current.matchedUid
            }
        }
    }
    
    
    
    // MARK: Realm Part
    
    let localRealm = try! Realm()
    var firstLoadData: Results<ChatRealmData>?
    
    
    func sendChatToServer(message: String, completion: @escaping () -> Void) {
        if let idToken = UserDefaults.standard.string(forKey: UserDefaults.myKey.idToken.rawValue) {
            HomeApiService.sendMessage(idToken: idToken, otherUid: uid, message: message) { error, statusCode, chatData in
                if let chatData = chatData, statusCode == 200 {
                    self.addChatToRealm(chat: chatData.chat, createdAt: chatData.createdAt, to: chatData.to, from: chatData.from, completion: completion)
//                    self.loadFromRealm(completion: completion)
                }
            }
        }
        
    }
    
    func addChatToRealm(chat: String, createdAt: String, to: String, from: String, completion: @escaping () -> Void) {
        let task = ChatRealmData(to: to, from: from, message: chat, createdAt: createdAt)
        try! localRealm.write {
            localRealm.add(task)
        }
        loadFromRealm(completion: completion)
    }
    
    func initalLoadFromRealm(completion: @escaping () -> Void) {
        loadFromRealm(completion: {
            print("hl")
        })
        if firstLoadData?.count == 0  {
            getChatHistory(date: "2000-01-01T00:00:00.000Z", completion: completion)
        }else {
            getChatHistory(date: firstLoadData!.last!.createdAt, completion: completion)
        }
    }
    
    func loadFromRealm(completion: @escaping () -> Void) {
        self.firstLoadData = self.localRealm.objects(ChatRealmData.self)
        if let data = firstLoadData {
            self.firstLoadData = data.where{
                $0.to.equals(self.uid) || $0.to.equals(UserInfo.current.user!.uid)
            }
            print(firstLoadData?.count)
            completion()
        }
        
    }

    
    private func getChatHistory(date: String, completion: @escaping () -> Void) {
        guard let idToken = UserDefaults.standard.string(forKey: UserDefaults.myKey.idToken.rawValue) else { return }
        HomeApiService.getChatHistory(idToken: idToken, otherUid: uid, date: date) { error, statusCode, chatData in
            if statusCode == 200 {
                if let chatData = chatData {
                    for chat in chatData.payload {
                        self.addChatToRealm(chat: chat.chat, createdAt: chat.createdAt, to: chat.to, from: chat.from, completion: completion)
                    }
                    print("shold work happend", statusCode, chatData)
                    
                }
            }else {
                print("some error happend", statusCode)
                switch error! {
                    
                case .firebaseTokenError(errorContent: let errorContent):
                    print("hello")
//                    completion(errorContent)
                case .serverError(errorContent: let errorContent):
                    print("hello")
//                    completion(errorContent)
                case .clientError(errorContent: let errorContent):
                    print("hello")
//                    completion(errorContent)
                case .alreadyWithdrawl(errorContent: let errorContent):
                    print("hello")
//                    completion(errorContent)
                }
            }
        }
        
    }
}
