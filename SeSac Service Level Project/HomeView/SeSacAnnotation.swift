//
//  SeSacAnnotation.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/27.
//

import MapKit
import UIKit

class SeSacAnnotation: NSObject, MKAnnotation {
    let title: String?
    let locationName: String?
    let discipline: String?
    let coordinate: CLLocationCoordinate2D
    
    init(discipline: String?,
                  coordinate: CLLocationCoordinate2D) {
        self.discipline = discipline
        self.coordinate = coordinate
        self.title = "good"
        self.locationName = "123"
        super.init()
    }
    
    
    
    
    
    
}
