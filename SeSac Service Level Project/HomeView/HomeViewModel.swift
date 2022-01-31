//
//  HomeViewModel.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/29.
//

import Foundation

enum UserState {
    case basic
    case waiting
    case matched
}

class HomeViewModel {
    
    var currentUserState = UserState.basic
    var defaultCoordinate: (Double,Double) = (37.51818789942772, 126.88541765534976)
    var nearFriends: [FromQueueDB] = []
    
    var region: Int  {
        let region = Int(String(Int((defaultCoordinate.0 + 90) * 100)) + String(Int((defaultCoordinate.1 + 180) * 100)))!
        return region
    }
    
    init() {
        checkCurrentUserState()
    }
    
    private func checkCurrentUserState() {
        let stateNum = UserDefaults.standard.integer(forKey: "CurrentUserState")
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
        if let idToken = UserDefaults.standard.string(forKey: "idToken") {
            
            ApiService.onqueue(idToken: idToken, region: region , lat: defaultCoordinate.0, long: defaultCoordinate.1 ) { error, statusCode, data in
                guard let data = data else { return }
                self.nearFriends = data.fromQueueDB + data.fromQueueDBRequested
                
            }
        }
    }
}