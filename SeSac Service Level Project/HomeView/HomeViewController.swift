//
//  HomeViewController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/26.
//

import UIKit
import MapKit

class HomeViewController: UIViewController {
    
    let mainView = HomeView()
    let locationManager = CLLocationManager()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        mainView.mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        let span = MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007)
        let center = CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734)
        mainView.mapView.region = MKCoordinateRegion(center: center, span: span)
        
        let a1 = SeSacAnnotation(discipline: "kiki", coordinate: center)
        let a2 = MKPointAnnotation()
        let a3 = MKMarkerAnnotationView()
//        MKdrag
        a3.coordinateSpace
        a2.coordinate = center
        
        mainView.mapView.addAnnotation(a2)
    }
    
}

extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("mark selected")
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? SeSacAnnotation else {
          return nil
        }
        // 3
        let identifier = "artwork"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(
          withIdentifier: identifier) as? MKMarkerAnnotationView {
          dequeuedView.annotation = annotation
          view = dequeuedView
        } else {
          // 5
          view = MKMarkerAnnotationView(
            annotation: annotation,
            reuseIdentifier: identifier)
//          view.canShowCallout = true
//          view.calloutOffset = CGPoint(x: -5, y: 5)
//          view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            let a = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            a.isDraggable = true
        return a
        }
        let a = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        a.isDraggable = true
        
//        a.annotation?.setCoordinate(<#T##CLLocationCoordinate2D#>)
    return a
        view.isDraggable = true
        return view
        
        
      }

    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        print("ASdffads")
        switch newState {
            case .starting:
                view.dragState = .dragging
            case .ending, .canceling:
                view.dragState = .none
            default: break
        }
    }
}

extension HomeViewController: CLLocationManagerDelegate {

    // 위치 허용하면 업데이트 된 위치( 현재 위치)로 지도 cetner 설정.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("updating")
        if let coordinate = locations.last?.coordinate{
            let span = MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007)
            let region = MKCoordinateRegion(center: coordinate, span: span)
            let newPin = MKAnnotationView(annotation: nil, reuseIdentifier: "")
                
//            MKAnnotation(
            newPin.isDraggable = true
            mainView.mapView.setRegion(region, animated: true)
//            mainView.mapView.addAnnotation(newPin)
            
        }else{
            print("not good")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error : getting location from user.")
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkCLAuthStatus()
    }
    // 14 미만
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkCLAuthStatus()
    }
    
    func checkCLAuthStatus() {
        let authStatus : CLAuthorizationStatus
        if #available(iOS 14.0, *){
            authStatus = locationManager.authorizationStatus // IOS 14이상 가능
        }else{
            authStatus = CLLocationManager.authorizationStatus() // IOS 14이상 미만
        }
        
        if CLLocationManager.locationServicesEnabled(){
            checkCurrentLocationAuth(authStatus)
        }else{
            print("Location service blocked. Go to setting and enable it.")
        }
    }
    
    func checkCurrentLocationAuth(_ status : CLAuthorizationStatus){
        switch status {
        case .notDetermined:
            locationManager.startUpdatingLocation()
            locationManager.requestWhenInUseAuthorization()
            print("not determined")
        case .restricted, .denied:
            print("denied , 설정으로 유도")
            let alertVC = UIAlertController(title: "위치 권한이 거부되었습니다.", message: "정확한 서비스를 위하여 위치 권한을 허용해주세요.", preferredStyle: .alert)
            
            let goToSetting = UIAlertAction(title: "설정으로", style: .default) { _ in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }

                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)")
                        })
                    }
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            alertVC.addAction(cancelAction)
            alertVC.addAction(goToSetting)
            self.present(alertVC, animated: true, completion: nil)
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            print("always")
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        @unknown default:
            print("default")
        }
    }
}
