//
//  InAppBackgroundProducts.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/02/20.
//

import Foundation


public struct BackgroundProducts {
    
    public static let sesac1 = "com.memolease.sesac1.background1"
    public static let sesac2 = "com.memolease.sesac1.background2"
    public static let sesac3 = "com.memolease.sesac1.background3"
    public static let sesac4 = "com.memolease.sesac1.background4"
    public static let sesac5 = "com.memolease.sesac1.background5"
    public static let sesac6 = "com.memolease.sesac1.background6"
    public static let sesac7 = "com.memolease.sesac1.background7"
    
    private static let productIdentifiers: Set<String> = [
        BackgroundProducts.sesac1,
        BackgroundProducts.sesac2,
        BackgroundProducts.sesac3,
        BackgroundProducts.sesac4,
        BackgroundProducts.sesac5,
        BackgroundProducts.sesac6,
        BackgroundProducts.sesac7
    ]

    public static let store = IAPHelper(productIds: BackgroundProducts.productIdentifiers)
}
