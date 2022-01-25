//
//  ManageViewModel.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/25.
//

import Foundation

class ManageViewModel {
    
    
    var updatedData: Observalble<MyPageUpdateData> = Observalble(MyPageUpdateData(searchable: UserInfo.current.user?.searchable ?? 0, ageMin: UserInfo.current.user?.ageMin ?? 0, ageMax: UserInfo.current.user?.ageMax ?? 100, gender: UserInfo.current.user?.gender ?? 0, hobby: UserInfo.current.user?.hobby ?? ""))
    
    var open = false
    
    var numberOfRowInSection: Int {
        return 7
    }
    
    
    func heightForRowAt(indexPath: IndexPath) -> Float {
        if indexPath.row == 0 {
            return 194
        }else if indexPath.row == 1 {
            if open {
                return 300
            }else {
                return 65
            }
        }else if indexPath.row == 5 {
            return 120
        }else {
            return 65
        }
    }
    
    
    
    let sectiontitleLabels = ["좋은 매너", "정확한 시간 약속", "빠른 응답", "친절한 성격", "능숙한 취미 실력", "유익한 시간"]
    
    func cellForItemAt(indexPath: IndexPath) -> String {
        return sectiontitleLabels[indexPath.row]
        
    }
    
}
