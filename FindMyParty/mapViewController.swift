//
//  mapViewController.swift
//  FindMyParty
//
//  Created by Nirbhay Singh on 19/11/21.
//

import UIKit
import GoogleMaps
import Alamofire
import SPPermissions
import JGProgressHUD
class mapViewController: UIViewController, CLLocationManagerDelegate{
    private var mapView = GMSMapView()
    private var tabBarCnt = UITabBarController()
    private var profilePic = UIImageView()
    private let defaultPic = "https://cdn3.iconfinder.com/data/icons/essential-rounded/64/Rounded-31-512.png"
    private var toTable = UIButton()
    private let locationManager = CLLocationManager()
    private var coords:CLLocationCoordinate2D!
    private let hud = JGProgressHUD.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpMap()
        self.setUpUI()
        
    }
    func setUpUI(){
        self.toTable.backgroundColor = .purple
        NSLayoutConstraint.activate([
            self.toTable.bottomAnchor.constraint(equalTo:
            self.mapView.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            self.toTable.heightAnchor.constraint(equalToConstant: 50)
        ])
        self.mapView.addSubview(self.toTable)
        
        
    }
    func setUpTabBarController(){
        self.tabBarCnt.tabBar.tintColor = UIColor.purple
        
    }
    func setUpMap(){
        self.mapView = GMSMapView(frame: self.view.bounds)
        self.mapView.isMyLocationEnabled = true
        self.mapView.setMinZoom(5, maxZoom: 30)
        self.view.addSubview(self.mapView)
        do {
            mapView.mapStyle = try GMSMapStyle(jsonString: mapStyle)
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        self.setUpLocation()
    }
    func setUpLocation(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            hud.show(in: self.view,animated: true)
            locationManager.startUpdatingLocation()
        }
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            print("called")
            let location:CLLocation = locations[0]
            coords = location.coordinate
            print(coords.longitude)
            locationManager.stopUpdatingLocation()
            hud.dismiss()
            refreshMap()
        }
        func refreshMap(){
            print(coords.latitude,coords.longitude)
            let cam = GMSCameraPosition.camera(withLatitude: coords.latitude, longitude:coords.longitude, zoom: 16.0)
            mapView.camera = cam
        }
}
