//
//  HomeViewController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/26.
//

import UIKit
import Toast
import MapKit

class HomeViewController: UIViewController {
    
    let mainView = HomeView()
    let viewModel = HomeViewModel()
    var friendsAnnotations: [MKPointAnnotation] = []
    var draggableAnnotation = MKPointAnnotation()
  
    lazy var defaultCoordinate = CLLocationCoordinate2D(latitude: viewModel.defaultCoordinate.0, longitude: viewModel.defaultCoordinate.1) 
    let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007)
    
    let locationManager = CLLocationManager()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        if let token = UserDefaults.standard.string(forKey: "idtoken"){
            print("saaa")
            ApiService.getUserInfo(idToken: token) { _, _ in
                print("saaa")
            }
        }
        
        locationManager.delegate = self
        mainView.mapView.delegate = self
        
        // 현재 유저에 맞게 위치 설정.
        locationManager.requestWhenInUseAuthorization()
        addTargets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCurrentUserState()
    }
    
    private func updateCurrentUserState() {
        
        viewModel.checkCurrentUserState()
        mainView.bottomFloatingButton.setImage(UIImage(named: viewModel.checkCurrentStateImage()), for: .normal)
        
        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            mainView.mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: defaultCoordinate.latitude, longitude: defaultCoordinate.longitude), latitudinalMeters: 700, longitudinalMeters: 700), animated: false)
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            locationManager.startUpdatingLocation()
            mainView.mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: defaultCoordinate.latitude, longitude: defaultCoordinate.longitude), latitudinalMeters: 700, longitudinalMeters: 700), animated: false)
            mainView.mapView.removeAnnotation(draggableAnnotation)
            draggableAnnotation.coordinate = defaultCoordinate
            mainView.mapView.addAnnotation(draggableAnnotation)
        @unknown default:
            print("not coverd yet")
        }
        
        viewModel.getNeighborHobbies {
            self.friendsAnnotations = []
            for friend in self.viewModel.nearFriends {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: friend.lat, longitude: friend.long)
                self.friendsAnnotations.append(annotation)
            }
            print(self.viewModel.nearFriends)
            
            let a1 = CLLocationCoordinate2D(latitude:  37.50530512029964, longitude: 126.99848526587533)
            let a2 = CLLocationCoordinate2D(latitude: 37.499176838581135, longitude: 126.98415154111608)
            let a3 = CLLocationCoordinate2D(latitude: 37.5015430958333, longitude: 126.97769278193901)
            let a11 = MKPointAnnotation()
            a11.coordinate = a1
            
            let a22 = MKPointAnnotation()
            a22.coordinate = a2
            
            let a33 = MKPointAnnotation()
            a33.coordinate = a3
            
            self.mainView.mapView.addAnnotations(self.friendsAnnotations)
            self.mainView.mapView.addAnnotations([a11,a22,a33])
        }
    }
   
    
    
    func addTargets() {
        mainView.allButton.addTarget(self, action: #selector(genderButtonClicked), for: .touchUpInside)
        mainView.maleButton.addTarget(self, action: #selector(genderButtonClicked), for: .touchUpInside)
        mainView.femaleButton.addTarget(self, action: #selector(genderButtonClicked), for: .touchUpInside)
        mainView.currentLocationButton.addTarget(self, action: #selector(findMyPlaceButtonClciked), for: .touchUpInside)
        
        mainView.bottomFloatingButton.addTarget(self, action: #selector(touchedFloatingButton), for: .touchUpInside)
    }
    
    @objc func touchedFloatingButton() {
        
        let status = locationManager.authorizationStatus
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            if UserInfo.current.user?.gender != -1 {
                switch viewModel.currentUserState {
                case .basic:
                    let vc = HobbySearchViewController()
                    vc.viewModel.requestParameter = makeCurrentInfo()
                    self.navigationController?.pushViewController(vc, animated: true)
                case .waiting:
                    print("waiting")
                case .matched:
                    self.navigationController?.pushViewController(ChattingViewController(), animated: true)
                }
            }else {
                self.view.makeToast("성별을 설정해주세요")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    let viewCont = MyInfoViewController()
                    viewCont.getInfo()
                    self.navigationController?.pushViewController(viewCont, animated: false)
                }
            }

        }else {
            self.view.makeToast("위치 권한을 허용해주세요")
        }
       
    }
    
    // MARK: 기본 상태일때 취미 검색화면으로 넘어갈때 정보 넘겨주는 것
    private func makeCurrentInfo() -> FindRequestParameter {
        
        let region = Int(String(Int((draggableAnnotation.coordinate.latitude + 90) * 100)) + String(Int((draggableAnnotation.coordinate.longitude + 180) * 100)))!
        return FindRequestParameter(type: 2, region: region, lat: draggableAnnotation.coordinate.latitude, long: draggableAnnotation.coordinate.longitude, hf: [])
    }
    
    
    @objc func findMyPlaceButtonClciked() {
        updateCurrentUserState()
        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            let alertVC = UIAlertController(title: "위치권한이 거부되어 있습니다", message: "위치권한을 허용해주세요", preferredStyle: .alert)
            let cancelButton = UIAlertAction(title: "확인", style: .cancel, handler: {_ in
                print("denied , 설정으로 유도")
                
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)")
                    })
                }
                
            })
            alertVC.addAction(cancelButton)
            present(alertVC, animated: true, completion: nil)
        case .authorizedAlways, .authorizedWhenInUse, .authorized:
            print("hello")
            
            locationManager.startUpdatingLocation()
            
        @unknown default:
            print("not coverd yet")
        }
    }
    
    
    @objc func genderButtonClicked(_ sender: UIButton) {
        updateCurrentUserState()
        if let title = sender.titleLabel?.text{
            if title == "전체" {
                mainView.selected = .all
                mainView.mapView.removeAnnotations(friendsAnnotations)
                self.friendsAnnotations = []
                for friend in viewModel.nearFriends {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: friend.lat, longitude: friend.long)
                    self.friendsAnnotations.append(annotation)
                }
            }else if title == "남자"{
                mainView.selected = .male
                mainView.mapView.removeAnnotations(friendsAnnotations)
                self.friendsAnnotations = []
                for friend in viewModel.nearFriends {
                    if friend.gender == 1 {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2D(latitude: friend.lat, longitude: friend.long)
                        self.friendsAnnotations.append(annotation)
                    }
                }
                
            }else {
                mainView.selected = .female
                mainView.mapView.removeAnnotations(friendsAnnotations)
                self.friendsAnnotations = []
                for friend in viewModel.nearFriends {
                    if friend.gender == 0 {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2D(latitude: friend.lat, longitude: friend.long)
                        self.friendsAnnotations.append(annotation)
                    }
                }
            }
        }
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

        print(draggableAnnotation.coordinate)
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
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        updateCurrentUserState()
    }
    
}

extension HomeViewController: CLLocationManagerDelegate {

    // 위치 허용하면 업데이트 된 위치( 현재 위치)로 지도 cetner 설정.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("updating")
        if let coordinate = locations.last?.coordinate{
            defaultCoordinate = coordinate
            updateCurrentUserState()
            viewModel.defaultCoordinate = (Double(coordinate.latitude) , Double(coordinate.longitude))
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
        updateCurrentUserState()
    }
    // 14 미만
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkCLAuthStatus()
        updateCurrentUserState()
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
