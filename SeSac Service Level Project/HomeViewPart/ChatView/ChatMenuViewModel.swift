//
//  ChatMenuViewModel.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/11.
//

import Foundation

class ChatMenuViewModel {
    
    let reviewLists = ["좋은 매너", "정확한 약속 시간","빠른 응답","친절한 성격","능숙한 취미 실력", "유익한 시간"]
    
    let reportLists = ["불법/사기", "불편한언행", "노쇼", "선정성", "인신공격", "기타"]
    
    func cellForItemAt(indexPath: IndexPath, type: MenuType) -> String {
        switch type {
        case .report:
            return reportLists[indexPath.item]
        case .review:
            return reviewLists[indexPath.item]
        }
    }
    
    var selectedItems = [0,0,0,0,0,0]
}
