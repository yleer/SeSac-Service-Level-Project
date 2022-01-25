//
//  MyPageUpdateData.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/25.
//

import Foundation

struct MyPageUpdateData: Codable{
    var searchable: Int
    var ageMin: Int
    var ageMax: Int
    var gender: Int
    var hobby: String
}
