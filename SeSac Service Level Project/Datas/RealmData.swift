//
//  RealmData.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/14.
//

import Foundation
import RealmSwift

class ChatRealmData: Object {
    @Persisted var to: String
    @Persisted var from: String
    @Persisted var message: String
    @Persisted var createdAt: String
    
    convenience init(to: String,from: String, message: String, createdAt: String) {
           self.init()
            self.to = to
        self.from = from
            self.message = message
            self.createdAt = createdAt
       }
}
