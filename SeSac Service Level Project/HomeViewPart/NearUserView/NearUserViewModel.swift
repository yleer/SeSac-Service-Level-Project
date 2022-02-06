//
//  NearUserViewModel.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/05.
//

import Foundation

class NearUserViewModel {
    
    var queueDB: [FromQueueDB] = []
    
    func onqueueCall(compeltion: @escaping () -> Void) {
        
        let region = UserInfo.current.onqueueParameter?.region
        let lat = UserInfo.current.onqueueParameter?.lat
        let long = UserInfo.current.onqueueParameter?.long
        FireBaseService.getIdToken {
            if let idToken = UserDefaults.standard.string(forKey: "idToken"), let region = region, let lat = lat, let long = long {
                HomeApiService.onqueue(idToken: idToken, region: region, lat: lat, long: long) { error, statusCode, data in
                    if let data = data {
                        self.queueDB = data.fromQueueDB
                    }
                    compeltion()
                }
            }
        }
    }
    
    var numberOfRowsInSection: Int  {
        return queueDB.count * 3
    }
}
