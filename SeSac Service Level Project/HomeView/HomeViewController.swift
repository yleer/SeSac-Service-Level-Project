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
    let defaultCoordinate = CLLocationCoordinate2D(latitude: 37.51818789942772, longitude: 126.88541765534976)
    let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007)
    let locationManager = CLLocationManager()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    
    private func startingPoint() {
        let status = locationManager.authorizationStatus
        checkCurrentLocationAuth(status)
//        let a1 = MKPointAnnotation()
//        a1.coordinate = center2
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        locationManager.delegate = self
        mainView.mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
    
        let center = CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734)
        let center2 = CLLocationCoordinate2D(latitude: 38.51781936468269, longitude: 126.8864731707474)
        let center3 = CLLocationCoordinate2D(latitude: 38.51781936468079, longitude: 121.8864731707471)
        
        
        
        mainView.mapView.region = MKCoordinateRegion(center: center2, span: defaultSpan)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        
        
        
        
//        let a1 = SeSacAnnotation(discipline: "kiki", coordinate: center2)
        let a1 = MKPointAnnotation()
        a1.coordinate = center2
        let a2 = MKPointAnnotation()
        let a3 = SeSacAnnotation(discipline: nil, coordinate: center3)
        a2.coordinate = center
//        mainView.mapView.addAnnotations([a2,a1,a3])
        
    }
    @objc func addTapped() {
        navigationController?.pushViewController(HobbySearchViewController(), animated: true)
    }
    
}

extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("mark selected", view.isDraggable)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? SeSacAnnotation else {
            print("dd")
            let view =  MKPinAnnotationView(annotation: annotation, reuseIdentifier: "SeSacAn1notation")
            view.isDraggable = true
            view.pinTintColor = .red
          return view
        }
        // 3
    
        var annotationView = self.mainView.mapView.dequeueReusableAnnotationView(withIdentifier: "SeSacAnnotation")
        if annotationView == nil {
            //없으면 하나 만들어 주시고
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "SeSacAnnotation")
            
            annotationView?.isDraggable = true


            let miniButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            miniButton.setImage(UIImage(systemName: "person"), for: .normal)
            miniButton.tintColor = .blue
            annotationView?.rightCalloutAccessoryView = miniButton
            
        } else {
            //있으면 등록된 걸 쓰시면 됩니다.
            annotationView?.annotation = annotation
        }
        print("aa")
        annotationView?.image = UIImage(named: ImageNames.MyInfoTableViewCell.myInfoTableViewCellUser)
        
        return nil
      }

    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {

        if (newState == MKAnnotationView.DragState.ending){
            let droppedAt = view.annotation?.coordinate
            print("dropped at : ", droppedAt?.latitude ?? 0.0, droppedAt?.longitude ?? 0.0);
            view.setDragState(.none, animated: true)
        }
        if (newState == .canceling )
        {
            view.setDragState(.none, animated: true)
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
            mainView.mapView.setRegion(region, animated: true)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mainView.mapView.addAnnotation(annotation)
            locationManager.stopUpdatingLocation()
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
        case .restricted, .denied:
            mainView.mapView.region = MKCoordinateRegion(center: defaultCoordinate, span: defaultSpan)
            let annotation = MKPointAnnotation()
            annotation.coordinate = defaultCoordinate
            mainView.mapView.addAnnotation(annotation)
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            
            
            
        @unknown default:
            print("default")
        }
    }
}
