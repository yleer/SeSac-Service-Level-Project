//
//  BirthViewModel.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/20.
//

import Foundation

class BirthViewModel {
    
    var bornDate: Observalble<Date> = Observalble(Date()){
        didSet{
            print(bornDate.value)
        }
    }
    var allowed = false
    var bornYear: Observalble<String> = Observalble("")
    var bornMonth: Observalble<String> = Observalble("")
    var bornDay: Observalble<String> = Observalble("")
    
    
    func updateDate() -> ButtonState {
        let bornDateString = "\(bornDate.value)"
        
        let year = bornDateString[0]! + bornDateString[1]! + bornDateString[2]! + bornDateString[3]!
        let month = bornDateString[5]! + bornDateString[6]!
        let day = bornDateString[8]! + bornDateString[9]!
        
        bornYear.value = year
        bornMonth.value = month
        bornDay.value = day
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
}


extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from) // <1>
        let toDate = startOfDay(for: to) // <2>
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>
        
        return numberOfDays.day!
    }
}
