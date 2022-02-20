//
//  SeSacPurchasViewModel.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/19.
//

import Foundation
struct SeSacData {
    let sesacImageNames = [
        ImageNames.AppPurchaseViewController.img,
        ImageNames.AppPurchaseViewController.img1,
        ImageNames.AppPurchaseViewController.img2,
        ImageNames.AppPurchaseViewController.img3,
        ImageNames.AppPurchaseViewController.img4
    ]
    
    let sesacTitles = [
        "기본 새싹",
        "튼튼 새싹",
        "민트 새싹",
        "퍼플 새싹",
        "골드 새싹"
    ]

    let sesacSubTitles = [
        "새싹을 대표하는 기본 식물입니다. 다른 새싹들과 함께 하는 것을 좋아합니다.",
        "잎이 하나 더 자라나고 튼트해진 새나라의 새싹으로 같이 있으면 즐거워집니다.",
        "호불호의 대명사! 상쾌한 향이 나서 허브가 대중화된 지역에서 많이 자랍니다.",
        "감정을 편안하게 쉬도록 하며 슬프고 우울한 감정을 진정시켜주는 멋진 새싹입니다.",
        "화려하고 멋있는 삶을 살며 돈과 인생을 플렉스 하는 자유분방한 새싹입니다."
    ]
    
    let prices = [
        "0",
        "1,200",
        "2,500",
        "2,500",
        "2,500"
    ]
}


class SeSacPurchasViewModel {
    
    let sessacInfo = SeSacData()
    
    var purchasedList = UserInfo.current.user?.sesacCollection
    
    var numberOfRowAt: Int {
        sessacInfo.sesacImageNames.count
    }
    
    func setPriceLabel(item: Int) -> (String, ButtonState) {
        guard let list = purchasedList else { return ("", .cancel)}
        if list.contains(item) {
            return ("보유중", .inActive)
        }else {
            return (sessacInfo.prices[item], .fill)
        }
    }
    
    
}
