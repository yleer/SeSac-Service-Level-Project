//
//  RecivedRequestViewModel.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/05.
//

import Foundation

class ReceivedRequestViewModel {
    var queueDB: [FromQueueDB] = []
    
    func onqueueCall(completion: @escaping () -> Void) {
        
        let region = UserInfo.current.onqueueParameter?.region
        let lat = UserInfo.current.onqueueParameter?.lat
        let long = UserInfo.current.onqueueParameter?.long
        FireBaseService.getIdToken {
            if let idToken = UserDefaults.standard.string(forKey: "idToken"), let region = region, let lat = lat, let long = long {
                HomeApiService.onqueue(idToken: idToken, region: region, lat: lat, long: long) { error, statusCode, data in
                    if let data = data {
                        self.queueDB = data.fromQueueDBRequested
                        
                    }
                    completion()
                }
            }
        }
    }
    
    var numberOfRowsInSection: Int  {
        return queueDB.count * 3
    }
    
    private let sectiontitleLabels = ["좋은 매너", "정확한 시간 약속", "빠른 응답", "친절한 성격", "능숙한 취미 실력", "유익한 시간"]
    
    func cellForItemAt(indexPath: IndexPath) -> String {
        return sectiontitleLabels[indexPath.row]
    }
}
