//
//  HomeViewModel.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/29.
//

import Foundation
import SwiftUI

enum UserState {
    case basic
    case waiting
    case matched
}

class HomeViewModel {
    var currentUserState = UserState.basic
    
    var defaultCoordinate: (Double,Double) = (37.51818789942772, 126.88541765534976)
    var nearFriends: [FromQueueDB] = []
    var maleFriends: [FromQueueDB] = []
    var femaleFriends: [FromQueueDB] = []
    
    var region: Int  {
        let region = Int(String(Int((defaultCoordinate.0 + 90) * 100)) + String(Int((defaultCoordinate.1 + 180) * 100)))!
        return region
    }
    
    init() {
        checkCurrentState()
    }
    
    func checkCurrentState() {
        let stateNum = UserDefaults.standard.integer(forKey: UserDefaults.myKey.CurrentUserState.rawValue)
        if stateNum == 0 {
            currentUserState = .basic
        }else if stateNum == 1 {
            currentUserState = .waiting
        }else if stateNum == 2 {
            currentUserState = .matched
        }
    }
    
    
    
    
    // MARK: 현재 상태에 맞는 플롯팅 버튼 이미지 설정.
    func checkCurrentStateImage() -> String {
        switch currentUserState {
        case .basic:
            return ImageNames.HomeViewController.main_status_button
        case .waiting:
            return ImageNames.HomeViewController.main_status_button1
        case .matched:
            return ImageNames.HomeViewController.main_status_button2
        }
    }
    
    func getNeighborHobbies(completion: @escaping () -> Void) {
        if let idToken = UserDefaults.standard.string(forKey: UserDefaults.myKey.idToken.rawValue) {
            
            HomeApiService.onqueue(idToken: idToken, region: region , lat: defaultCoordinate.0, long: defaultCoordinate.1 ) { error, statusCode, data in
                guard let data = data else {
                    print("no data from onque in home view", statusCode)
                    return
                }
                self.nearFriends = data.fromQueueDB + data.fromQueueDBRequested
                
                self.femaleFriends = []
                self.maleFriends = []
                for friend in self.nearFriends {
                    if friend.gender == 0 {
                        self.femaleFriends.append(friend)
                    }else if friend.gender == 1 {
                        self.maleFriends.append(friend)
                    }
                }
               
                completion()
            }
        }
    }
}
