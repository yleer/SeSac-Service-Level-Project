//
//  BirthViewModel.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/20.
//

import Foundation

class BirthViewModel {
    
    var bornYear: Observalble<String> = Observalble("")
    var bornMonth: Observalble<String> = Observalble("")
    var bornDay: Observalble<String> = Observalble("")
    
    var bornDate: Observalble<Date> = Observalble(Date()){
        didSet{
            oldEnough()
        }
    }
    
    var allowed = false{
        didSet{
            if allowed {
                
                UserDefaults.standard.set("\(bornDate.value)", forKey: UserDefaults.myKey.age.rawValue)
            }
        }
    }
    
    
    func updateDate() -> ButtonState {
        let bornDateString = "\(bornDate.value)"

        bornYear.value = bornDateString.substring(from: 0, to: 3)
        bornMonth.value = bornDateString.substring(from: 5, to: 6)
        bornDay.value = bornDateString.substring(from: 8, to: 9)
        oldEnough()
        return .fill
    }
    
    
    func oldEnough()  {
        let today = Date()
        let days = Calendar(identifier: .japanese).numberOfDaysBetween(bornDate.value, and: today)
        let age = Float(days) / 365
        if age <= 17{
            print(age)
            allowed = false
        }else{
            print(age)
            allowed = true
        }
    }


    func checkForPreiousData() -> Date? {
        if let dateString = UserDefaults.standard.string(forKey: UserDefaults.myKey.age.rawValue) {
            bornYear.value = dateString.substring(from: 0, to: 3)
            bornMonth.value = dateString.substring(from: 5, to: 6)
            bornDay.value = dateString.substring(from: 8, to: 9)
            bornDate.value = dateString.substring(from: 0, to: 9).toDate()!
            return dateString.substring(from: 0, to: 9).toDate()
        }
        return nil
    }
    
}

extension String {
    func substring(from: Int, to: Int) -> String {
        guard from < count, to >= 0, to - from >= 0 else {
            return ""
        }
        
        // Index 값 획득
        let startIndex = index(self.startIndex, offsetBy: from)
        let endIndex = index(self.startIndex, offsetBy: to + 1) // '+1'이 있는 이유: endIndex는 문자열의 마지막 그 다음을 가리키기 때문
        
        // 파싱
        return String(self[startIndex ..< endIndex])
    }
}
