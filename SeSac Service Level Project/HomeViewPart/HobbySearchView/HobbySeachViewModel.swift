//
//  HobbySeachViewModel.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/30.
//

import Foundation

class HobbySeachViewModel {
    
    lazy var requestParameter: FindRequestParameter! = nil
    
    var allHobbies: [String] = []
    var recommendationHobbies: [String] = []
    var nearByHobbies: [String] = []
    
    
    
    var myInterestHobbies: [String] = [] {
        didSet{
            if requestParameter != nil {
                requestParameter!.hf = myInterestHobbies
                UserInfo.current.onqueueParameter?.hf = myInterestHobbies
            }
        }
    }
    

    func getNeighborHobbies(completion: @escaping () -> Void) {
        if let idToken = UserDefaults.standard.string(forKey: "idToken") {
            ApiService.onqueue(idToken: idToken, region: requestParameter.region, lat: requestParameter.lat, long: requestParameter.long) { error, statusCode, data in
                guard let data = data else { return }
        
                self.recommendationHobbies = data.fromRecommend
                self.nearByHobbies = []
                for b in data.fromQueueDBRequested {
                    self.nearByHobbies += b.hf
                }
                
                for a in data.fromQueueDB {
                    self.nearByHobbies += a.hf
                }
                
                self.allHobbies = self.recommendationHobbies + self.nearByHobbies
                completion()
            }
        }
    }
    
    func newSearchKeywords(keyWords: String) {
        let a = keyWords.components(separatedBy: " ")
        let _ = a.map { keyWord in
            if !myInterestHobbies.contains(keyWord) && keyWord != ""{
                myInterestHobbies.append(keyWord)
            }
        }
    }
}
