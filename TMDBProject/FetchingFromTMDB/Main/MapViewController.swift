//
//  MapViewController.swift
//  TMDBProject
//
//  Created by Junhee Yoon on 2022/08/11.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let theaters = TheaterList()
    
    // MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNaviUI()
        locationManager.delegate = self
        mapView.delegate = self
    }
    
    
    // MARK: - Selectors
    
    @objc func filterFunction() {
        
        let theaterKindsAlert = UIAlertController(title: "영화관 선택", message: "영화관 브랜드를 선택하세요.", preferredStyle: .actionSheet)
        
        let myLocation = UIAlertAction(title: "나의 위치", style: .default) { _ in
            
            self.removeAnnotations()
            guard let coordinates = self.locationManager.location?.coordinate else { return }
            self.setRegionAndAnnotation(center: coordinates, annoTitle: "현재 위치")
            
        }
        
        let megaBox = UIAlertAction(title: "메가박스", style: .default) { _ in
            
            self.removeAnnotations()
            
            let region1 = MKCoordinateRegion(center: self.setCoordinates(latitude: self.theaters.mapAnnotations[0].latitude, longitude: self.theaters.mapAnnotations[0].longitude), latitudinalMeters: 2000, longitudinalMeters: 2000)
            
            let region2 = MKCoordinateRegion(center: self.setCoordinates(latitude: self.theaters.mapAnnotations[1].latitude, longitude: self.theaters.mapAnnotations[1].longitude), latitudinalMeters: 2000, longitudinalMeters: 2000)
            
            self.mapView.setRegion(region1, animated: true)
            
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = region1.center
            annotation.title = self.theaters.mapAnnotations[0].location
            self.mapView.addAnnotation(annotation)
            
            let annotation2 = MKPointAnnotation()
            annotation2.coordinate = region2.center
            annotation2.title = self.theaters.mapAnnotations[1].location
            self.mapView.addAnnotation(annotation2)
            
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            
        }
        let lotteCinema = UIAlertAction(title: "롯데시네마", style: .default) { _ in
            
            self.removeAnnotations()
            
            self.setRegionAndAnnotation(center: self.setCoordinates(latitude: self.theaters.mapAnnotations[2].latitude, longitude: self.theaters.mapAnnotations[2].longitude), annoTitle: self.theaters.mapAnnotations[2].location)
            
            self.setRegionAndAnnotation(center: self.setCoordinates(latitude: self.theaters.mapAnnotations[3].latitude, longitude: self.theaters.mapAnnotations[3].longitude), annoTitle: self.theaters.mapAnnotations[3].location)
           
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            
        }
        
        let cgv = UIAlertAction(title: self.theaters.mapAnnotations[4].location, style: .default) { _ in
            
            self.removeAnnotations()
            
            self.setRegionAndAnnotation(center: self.setCoordinates(latitude: self.theaters.mapAnnotations[4].latitude, longitude: self.theaters.mapAnnotations[4].longitude), annoTitle: self.theaters.mapAnnotations[4].location)
            
            self.setRegionAndAnnotation(center: self.setCoordinates(latitude: self.theaters.mapAnnotations[5].latitude, longitude: self.theaters.mapAnnotations[5].longitude), annoTitle: self.theaters.mapAnnotations[5].location)
           
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            
        }
        let all = UIAlertAction(title: "전체보기", style: .default) { _ in
            
            self.removeAnnotations()
            
            self.theaters.mapAnnotations.forEach {
                self.setRegionAndAnnotation(center: self.setCoordinates(latitude: $0.latitude, longitude: $0.longitude), annoTitle: $0.location)
            }
            
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
        

        
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        theaterKindsAlert.addAction(myLocation)
        theaterKindsAlert.addAction(megaBox)
        theaterKindsAlert.addAction(lotteCinema)
        theaterKindsAlert.addAction(cgv)
        theaterKindsAlert.addAction(all)
        theaterKindsAlert.addAction(cancel)
        
        present(theaterKindsAlert, animated: true, completion: nil)
        
    }
    
    
    // MARK: - Helper Functions
    
    func configureNaviUI() {
        
        let barAppearance = UINavigationBarAppearance()
        barAppearance.backgroundColor = .systemBackground
        navigationItem.scrollEdgeAppearance = barAppearance
        
        navigationItem.title = "Theaters"
        self.navigationController?.navigationBar.tintColor = UIColor.systemBlue
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue]
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "mappin.and.ellipse"), style: .plain, target: self, action: #selector(filterFunction))
        
    }
    
    func setCoordinates(latitude: CLLocationDegrees?, longitude: CLLocationDegrees?) -> CLLocationCoordinate2D {
        if latitude == nil || longitude == nil {
            return CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270)
        } else {
            guard let latitude = latitude else { return CLLocationCoordinate2D() }
            guard let longitude = longitude else { return CLLocationCoordinate2D() }
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    func setRegionAndAnnotation(center: CLLocationCoordinate2D, annoTitle: String) {
        
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        
        mapView.setRegion(region, animated: true)
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = annoTitle
        
        mapView.addAnnotation(annotation)
        
    }
    
    func removeAnnotations() {
        mapView.annotations.forEach { (annotation) in
            if let annotation = annotation as? MKPointAnnotation {
                mapView.removeAnnotation(annotation)
            }
        }
    }
    
}


// MARK: - Authorizations

extension MapViewController {
    
    func checkUserDeviceLocationServiceAuthorization() {
        
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        if CLLocationManager.locationServicesEnabled() {
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("위치 서비스가 꺼져 있습니다.")
        }
    }
    
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        
        switch authorizationStatus {
        case .notDetermined:
            print("NOT Determined")
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            
        case .restricted, .denied:
            print("Denied, 아이폰 설정으로 유도")
            setRegionAndAnnotation(center: setCoordinates(latitude: nil, longitude: nil), annoTitle: "새싹 캠퍼스")
            
            
        case .authorizedWhenInUse:
            print("When In Use")
            locationManager.startUpdatingLocation()
        default:
            print("Default")
        }
    }
    
}


// MARK: - Extension: MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print(#function)
//        locationManager.startUpdatingLocation()
    }
    
}


// MARK: - Extension: CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function, locations)
        
        if let coordinate = locations.last?.coordinate {
            
            print(coordinate)
            setRegionAndAnnotation(center: coordinate, annoTitle: "내 위치")
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
        
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserDeviceLocationServiceAuthorization()
    }


}
