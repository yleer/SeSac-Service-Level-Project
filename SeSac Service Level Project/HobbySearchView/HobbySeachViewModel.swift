//
//  HobbySeachViewModel.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/30.
//

import Foundation

class HobbySeachViewModel {
    
    var myInterestHobbies: [String] = ["dd"] {
        didSet{
            if requestParameter != nil {
//                requestParameter!.hf = myInterestHobbies
            }
        }
    }
    
    lazy var requestParameter: FindRequestParameter? = nil
    
    
    func newSearchKeywords(keyWords: String) {
        let a = keyWords.components(separatedBy: " ")
        let _ = a.map { keyWord in
            if !myInterestHobbies.contains(keyWord) && keyWord != ""{
                myInterestHobbies.append(keyWord)
            }
        }
    }
}
