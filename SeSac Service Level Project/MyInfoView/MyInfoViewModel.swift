//
//  MyInfoViewModel.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/24.
//

import Foundation

class MyInfoViewModel {
    
    private let imageNames = [
        ImageNames.MyInfoSettingCell.myInfoSettingCellNotice,
        ImageNames.MyInfoSettingCell.myInfoSettingCellFaq,
        ImageNames.MyInfoSettingCell.myInfoSettingCellQna,
        ImageNames.MyInfoSettingCell.myInfoSettingCellAlarm,
        ImageNames.MyInfoSettingCell.myInfoSettingCellPermit
    ]
    
    private let labelNames = ["공지사항", "자주 묻는 질문", "1:1 문의", "알림 설정", "이용약관"]
    
    var numberOfRowInSection: Int {
        return imageNames.count + 1
    }
    
    func cellForRowAt(cellForRowAt indexPath: IndexPath) -> (String, String) {
        if indexPath.row == 0 {
            return (ImageNames.MyInfoTableViewCell.myInfoTableViewCellUser, "사용자입니다")
        }else {
            return (imageNames[indexPath.row - 1], labelNames[indexPath.row - 1])
        }
    }
    
}


