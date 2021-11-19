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
    private var profilePic = UIImageView()
    private let defaultPic = "https://cdn3.iconfinder.com/data/icons/essential-rounded/64/Rounded-31-512.png"
    private var toTable = UIButton()
    private var toProf = UIButton()
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
        self.toTable.frame = CGRect(x: 5*UIScreen.main.bounds.width/100, y: self.view.frame.height-200, width: 70, height: 70)
        self.toTable.borderColor = .white
        self.toTable.borderWidth = 2
        self.toTable.cornerRadius = 35
        self.toTable.setTitle("🎉", for: .normal)
        self.toTable.addTarget(self, action: #selector(toTableButtonPressed), for: .touchUpInside)
        self.mapView.addSubview(self.toTable)
        
        
        self.toProf.backgroundColor = .purple
        self.toProf.frame = CGRect(x: 5*UIScreen.main.bounds.width/100, y: self.view.frame.height-300, width: 70, height: 70)
        self.toProf.borderColor = .white
        self.toProf.borderWidth = 2
        self.toProf.cornerRadius = 35
        self.toProf.setTitle("😃", for: .normal)
        self.toProf.addTarget(self, action: #selector(toProfButtonPressed), for: .touchUpInside)
        self.mapView.addSubview(self.toProf)
        
        
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
    
    @objc func toTableButtonPressed()
    {
        let vc = PartyTableViewController()
        present(vc, animated: true, completion: nil)
    }
    
    @objc func toProfButtonPressed() {
        print("called")
        let vc = profileViewController()
        present(vc, animated: true, completion: nil)
        
    }
    
    
}
