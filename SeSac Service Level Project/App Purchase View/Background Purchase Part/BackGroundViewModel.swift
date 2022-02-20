//
//  BackGroundViewModel.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/19.
//

import Foundation

struct BackGroundData {
    let backgroundImageNames = [
        ImageNames.AppPurchaseViewController.background1,
        ImageNames.AppPurchaseViewController.background2,
        ImageNames.AppPurchaseViewController.background3,
        ImageNames.AppPurchaseViewController.background4,
        ImageNames.AppPurchaseViewController.background5,
        ImageNames.AppPurchaseViewController.background6,
        ImageNames.AppPurchaseViewController.background7,
        ImageNames.AppPurchaseViewController.background8,
    ]
    
    let backgroundTitles = [
        "하늘공원",
        "씨티 뷰",
        "밤의 산책로",
        "낮의 산책로",
        "연극 무대",
        "라틴 거실",
        "홈트방",
        "뮤지션 작업실"
    ]

    let backgroundSubTitles = [
        "새싹들을 많이 마주치는 매력적인 하늘 공원입니다",
        "창밖으로 보이는 도시 야경이 아름다운 공간입니다",
        "어둡지만 무섭지 않은 조용한 산책로입니다",
        "즐겁고 가볍게 걸을 수 있는 산책로입니다",
        "연극의 주인공이 되어 연기를 펼칠 수 있는 무대입니다",
        "모노톤의 따스한 감성의 거실로 편하게 쉴 수 있는 공간입니다",
        "집에서 운동을 할 수 있도록 기구를 갖춘 방입니다",
        "여러가지 음악 작업을 할 수 있는 작업실입니다"
    ]
    
    let prices = [
        "0",
        "1,200",
        "1,200",
        "1,200",
        "2,500",
        "2,500",
        "2,500",
        "2,500",
        "2,500"
    ]
}

class BackGroundViewModel {
    
    let backGroundInfo = BackGroundData()
    
    var numberOfRowAt: Int {
        backGroundInfo.backgroundImageNames.count
    }
}
