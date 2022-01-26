//
//  MyInfoViewModel.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/24.
//

import Foundation

class MyInfoViewModel {
    
    private let cellDatas = [
        (ImageNames.MyInfoSettingCell.myInfoSettingCellNotice,"공지사항"),
        (ImageNames.MyInfoSettingCell.myInfoSettingCellFaq,"자주 묻는 질문"),
        (ImageNames.MyInfoSettingCell.myInfoSettingCellQna,"1:1 문의"),
        (ImageNames.MyInfoSettingCell.myInfoSettingCellAlarm,"알림 설정"),
        (ImageNames.MyInfoSettingCell.myInfoSettingCellPermit,"이용약관")
    ]
    
    var numberOfRowInSection: Int {
        return cellDatas.count + 1
    }
    
    func cellForRowAt(cellForRowAt indexPath: IndexPath) -> (String, String) {
        if indexPath.row == 0 {
            return (ImageNames.MyInfoTableViewCell.myInfoTableViewCellUser, "사용자입니다")
        }else {
            return cellDatas[indexPath.row - 1]
        }
    }
    
    var heightForRowAt: Int {
        return 72
    }
}


