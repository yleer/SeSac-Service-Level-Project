//
//  ChattingViewModel.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/13.
//

import Foundation

class ChattingViewModel {
    
    func myState(completion: @escaping (APIError?, Int) -> Void ) {
        if let idToken = UserDefaults.standard.string(forKey: UserDefaults.myKey.idToken.rawValue) {
            HomeApiService.myQueueState(idToken: idToken) { error, statusCode in
                completion(error, statusCode)
            }
        }
    }
    
    
    
}
