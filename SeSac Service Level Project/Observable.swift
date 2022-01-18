//
//  Observable.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/18.
//

import Foundation

class Observalble<T> {
    
    init(_ value: T) {
        self.value = value
    }
    
    var value: T {
        didSet{
            listner?(value)
        }
    }
    
    private var listner: ( (T)-> Void )?
    
    func bind(_ closure: @escaping (T) -> Void ) {
        closure(value)
        listner = closure
    }
    
}
