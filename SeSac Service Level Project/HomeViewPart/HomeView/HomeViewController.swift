//
//  HomeViewController.swift
//  SeSac Service Level Project
//
//  Created by Yundong Lee on 2022/01/26.
//

import UIKit
import Toast
import Parchment
import MapKit

class HomeViewController: UIViewController {
    
    let mainView = HomeView()
    let viewModel = HomeViewModel()
    
    var friendsAnnotations: [SeSacAnnotation] = []
    
    lazy var defaultCoordinate = CLLocationCoordinate2D(latitude: viewModel.defaultCoordinate.0, longitude: viewModel.defaultCoordinate.1)
    let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007)
    
    let locationManager = CLLocationManager()
    
    override func loadView() {
        super.loadView()
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        mainView.mapView.delegate = self
        // 현재 유저에 맞게 위치 설정.
        locationManager.requestWhenInUseAuthorization()
        addTargets()
        FireBaseService.getIdToken {
            if let idToken = UserDefaults.standard.string(forKey: UserDefaults.myKey.idToken.rawValue) {
                print(idToken)
                HomeApiService.myQueueState(idToken: idToken) { err, int in
                    print("helo")
                }
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        updateCurrentUserState()
        FireBaseService.getIdToken {
            if let idToken = UserDefaults.standard.string(forKey: UserDefaults.myKey.idToken.rawValue) {
                ApiService.getUserInfo(idToken: idToken) { error, statusCode in
                    if error == nil {
                        if statusCode == 200 {
                            return
                        }
                    }else {
                        if statusCode == 401 {
                            self.view.makeToast("나중에 다시 시도해 주세요")
                        }else if statusCode == 500 {
                            self.view.makeToast("서버 에러")
                        }else if statusCode == 501 {
                            self.view.makeToast("사용자 에러")
                        }
                    }
                }
                
            }
        }
    }
    
    var initial = true
    
    private func updateCurrentUserState() {
        viewModel.checkCurrentState()
        
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
//            self.viewModel.defaultCoordinate = defaultCoordinate
        @unknown default:
            print("not coverd yet")
        }
        
        mainView.mapView.removeAnnotations(self.friendsAnnotations)
        
        viewModel.getNeighborHobbies {
            //            self.friendsAnnotations = []
            for friend in self.viewModel.nearFriends {
                var annotation = SeSacAnnotation(discipline: "0", coordinate: CLLocationCoordinate2D(latitude: friend.lat, longitude: friend.long), image2: UIImage(named: ImageNames.AppPurchaseViewController.img)!)
                
                
                if friend.sesac == 0 {
                    annotation = SeSacAnnotation(discipline: "1", coordinate: CLLocationCoordinate2D(latitude: friend.lat, longitude: friend.long), image2: UIImage(named: ImageNames.AppPurchaseViewController.img)!)
                }else if friend.sesac == 1 {
                    annotation = SeSacAnnotation(discipline: "2", coordinate: CLLocationCoordinate2D(latitude: friend.lat, longitude: friend.long), image2: UIImage(named: ImageNames.AppPurchaseViewController.img1)!)
                }else if friend.sesac == 2 {
                    annotation = SeSacAnnotation(discipline: "3", coordinate: CLLocationCoordinate2D(latitude: friend.lat, longitude: friend.long), image2: UIImage(named: ImageNames.AppPurchaseViewController.img2)!)
                }else if friend.sesac == 3 {
                    annotation = SeSacAnnotation(discipline: "4", coordinate: CLLocationCoordinate2D(latitude: friend.lat, longitude: friend.long), image2: UIImage(named: ImageNames.AppPurchaseViewController.img3)!)
                }else if friend.sesac ==  4{
                    annotation = SeSacAnnotation(discipline: "5", coordinate: CLLocationCoordinate2D(latitude: friend.lat, longitude: friend.long), image2: UIImage(named: ImageNames.AppPurchaseViewController.img4)!)
                }
                
                
                
                self.friendsAnnotations.append(annotation)
            }
            self.mainView.mapView.addAnnotations(self.friendsAnnotations)
        }
    }
    
    
    
    func addTargets() {
        mainView.allButton.addTarget(self, action: #selector(genderButtonClicked), for: .touchUpInside)
        mainView.maleButton.addTarget(self, action: #selector(genderButtonClicked), for: .touchUpInside)
        mainView.femaleButton.addTarget(self, action: #selector(genderButtonClicked), for: .touchUpInside)
        mainView.currentLocationButton.addTarget(self, action: #selector(findMyPlaceButtonClciked), for: .touchUpInside)
        mainView.bottomFloatingButton.addTarget(self, action: #selector(touchedFloatingButton), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleCancelPush),
                                               name: .cancelPush,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleReqeustPush),
                                               name: .requestPush,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleAcceptPush),
                                               name: .acceptPush,
                                               object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleChatPush),
                                               name: .chatPush,
                                               object: nil)
    }
    
    
    @objc func handleCancelPush() {}
    @objc func handleChatPush() {
        let userState = UserDefaults.standard.integer(forKey: UserDefaults.myKey.CurrentUserState.rawValue)
        if userState == 0 || userState == 1 {
            print("skip")
        }else if userState == 2 {
            let vc = ChattingViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @objc func handleAcceptPush() {
        let userState = UserDefaults.standard.integer(forKey: UserDefaults.myKey.CurrentUserState.rawValue)
        if userState == 0 || userState == 2 {
            print("skip")
        }else if userState == 1 {
            let vc = ChattingViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    @objc func handleReqeustPush() {
        let userState = UserDefaults.standard.integer(forKey: UserDefaults.myKey.CurrentUserState.rawValue)
        if userState == 0 || userState == 2 {
            print("skip")
        }else if userState == 1 {
            let vc = NearUserPageMenuController()
            updateDataToUserInfo()
            
            vc.isSecond = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func updateDataToUserInfo() {
        let par = FindRequestParameter(type: 2, region: UserDefaults.standard.integer(forKey: "region"), lat: UserDefaults.standard.double(forKey: "lat"), long: UserDefaults.standard.double(forKey: "long"), hf: [])
        UserInfo.current.onqueueParameter = par
    }
    
    @objc func touchedFloatingButton() {
        
        let status = locationManager.authorizationStatus
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            if UserInfo.current.user!.gender != -1 {
                switch viewModel.currentUserState {
                case .basic:
                    let vc = HobbySearchViewController()
                    
                    // 이 부분 singleton으로 처리하자 귀찮다 계속 오기.
                    let parameter = makeCurrentInfo()
                    vc.viewModel.requestParameter = parameter
                    UserInfo.current.onqueueParameter = parameter
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                case .waiting:
                    let vc = NearUserPageMenuController()
                    
                    updateDataToUserInfo()
                    self.navigationController?.pushViewController(vc, animated: true)
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
        let region = Int(String(Int((mainView.mapView.centerCoordinate.latitude + 90) * 100)) + String(Int((mainView.mapView.centerCoordinate.longitude + 180) * 100)))!
        
        
        UserDefaults.standard.set(region, forKey: "region")
        UserDefaults.standard.set(mainView.mapView.centerCoordinate.latitude, forKey: "lat")
        UserDefaults.standard.set(mainView.mapView.centerCoordinate.longitude, forKey: "long")
        let par = FindRequestParameter(type: 2, region: region, lat: mainView.mapView.centerCoordinate.latitude, long: mainView.mapView.centerCoordinate.longitude, hf: [])
        UserInfo.current.onqueueParameter = par
        
        return par
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
    
    
    private func createAnnotation(data: FromQueueDB) {
        
        if data.sesac == 0 {
            let annotation = SeSacAnnotation(discipline: "1", coordinate: CLLocationCoordinate2D(latitude: data.lat, longitude: data.long), image2: UIImage(named: ImageNames.AppPurchaseViewController.img)!)
            
            self.friendsAnnotations.append(annotation)
        }else if data.sesac == 1 {
            let annotation = SeSacAnnotation(discipline: "2", coordinate: CLLocationCoordinate2D(latitude: data.lat, longitude: data.long), image2: UIImage(named: ImageNames.AppPurchaseViewController.img1)!)
            self.friendsAnnotations.append(annotation)
        }else if data.sesac == 2 {
            let annotation = SeSacAnnotation(discipline: "3", coordinate: CLLocationCoordinate2D(latitude: data.lat, longitude: data.long), image2: UIImage(named: ImageNames.AppPurchaseViewController.img2)!)
            self.friendsAnnotations.append(annotation)
        }else if data.sesac == 3 {
            let annotation = SeSacAnnotation(discipline: "4", coordinate: CLLocationCoordinate2D(latitude: data.lat, longitude: data.long), image2: UIImage(named: ImageNames.AppPurchaseViewController.img3)!)
            self.friendsAnnotations.append(annotation)
        }else if data.sesac == 4 {
            let annotation = SeSacAnnotation(discipline: "5", coordinate: CLLocationCoordinate2D(latitude: data.lat, longitude: data.long), image2: UIImage(named: ImageNames.AppPurchaseViewController.img4)!)
            self.friendsAnnotations.append(annotation)
        }
    }
    
    
    @objc func genderButtonClicked(_ sender: UIButton) {
        
        mainView.mapView.removeAnnotations(friendsAnnotations)
        self.friendsAnnotations = []
        viewModel.getNeighborHobbies {
            if let title = sender.titleLabel?.text{
                if title == "전체" {
                    self.mainView.selected = .all
                    for friend in self.viewModel.nearFriends {
                        self.createAnnotation(data: friend)
                    }
                    self.mainView.mapView.addAnnotations(self.friendsAnnotations)
                }else if title == "남자"{
                    self.mainView.selected = .male
                    for friend in self.viewModel.maleFriends {
                        self.createAnnotation(data: friend)
                    }
                    self.mainView.mapView.addAnnotations(self.friendsAnnotations)
                }else {
                    self.mainView.selected = .female
                    for friend in self.viewModel.femaleFriends {
                        self.createAnnotation(data: friend)
                    }
                    self.mainView.mapView.addAnnotations(self.friendsAnnotations)
                }
            }
        }
    }
}



extension HomeViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard let annotation = annotation as? SeSacAnnotation else {
            let view =  MKPinAnnotationView(annotation: annotation, reuseIdentifier: "SeSacAn1notation")
            view.isDraggable = true
            view.pinTintColor = .red
            view.image = UIImage(named: "Draggable")
            return view
        }
        
        let view =  MKPinAnnotationView(annotation: annotation, reuseIdentifier: "SeSacAn1notation")
        if annotation.discipline == "1" {
            view.image = resizeImage(originalImage: UIImage(named: ImageNames.AppPurchaseViewController.img))
        }else if annotation.discipline == "2"{
            view.image = resizeImage(originalImage: UIImage(named: ImageNames.AppPurchaseViewController.img1))
        }else if annotation.discipline == "3"{
            view.image = resizeImage(originalImage: UIImage(named: ImageNames.AppPurchaseViewController.img2))
        }else if annotation.discipline == "4"{
            view.image = resizeImage(originalImage: UIImage(named: ImageNames.AppPurchaseViewController.img3))
        }else if annotation.discipline == "5"{
            view.image = resizeImage(originalImage: UIImage(named: ImageNames.AppPurchaseViewController.img4))
        }
        return view
    }
    
    private func resizeImage(originalImage: UIImage?) -> UIImage? {
        let pinImage = originalImage
        let size = CGSize(width: 80, height: 80)
        UIGraphicsBeginImageContext(size)
        
        pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        return resizedImage
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        
        if (newState == MKAnnotationView.DragState.ending){
            let droppedAt = view.annotation?.coordinate
            view.setDragState(.none, animated: true)
            view.image = UIImage(named: "Draggable")
        }
        if (newState == .canceling )
        {
            view.setDragState(.none, animated: true)
            view.image = UIImage(named: "Draggable")
        }
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        viewModel.defaultCoordinate = (Double(mapView.centerCoordinate.latitude), Double(mapView.centerCoordinate.longitude))
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
            if initial {
                initial = false
            }
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
