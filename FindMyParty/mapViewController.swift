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
import Spring
import SwiftyJSON




class mapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate{
    private var mapView = GMSMapView()
    private var toTable = UIButton()
    private var toProf = UIButton()
    private var addParty = UIButton()
    private let locationManager = CLLocationManager()
    private var coords:CLLocationCoordinate2D!
    private let hud = JGProgressHUD.init()
    private let apiURL = "https://findmyparty-wj6gklp34a-ue.a.run.app/api/"
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
        
        self.addParty.backgroundColor = .purple
        self.addParty.frame = CGRect(x: 5*UIScreen.main.bounds.width/100, y: self.view.frame.height-400, width: 70, height: 70)
        self.addParty.borderColor = .white
        self.addParty.borderWidth = 2
        self.addParty.cornerRadius = 35
        self.addParty.setTitle("+", for: .normal)
        self.addParty.addTarget(self, action: #selector(addPartyButtonPressed), for: .touchUpInside)
        self.mapView.addSubview(self.addParty)
        
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
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
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
            refreshMap()
        }
        func refreshMap(){
            print(coords.latitude,coords.longitude)
            let cam = GMSCameraPosition.camera(withLatitude: coords.latitude, longitude:coords.longitude, zoom: 16.0)
            mapView.camera = cam
            self.getAllParties()
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
    func getAllParties(){
        AF.request(apiURL+"parties/", method: .get).response() {response in
            self.hud.dismiss()
            if(response.error != nil){
                showAlert(msg: "You appear to be offline, check your internet connectivity and retry.")
            }else{
                let jsonResp = JSON(response.value as Any)
                let parties = jsonResp["parties"]
                for party in parties{
                    let innerParty = party.1
                    print(innerParty)
                    let date = innerParty["dateTime"].stringValue
                    let photoURL = innerParty["photoURL"].stringValue
                    let host = innerParty["host"].stringValue
                    let attendeesCount = innerParty["attendees"].stringValue.count
                    let loc = innerParty["location"].stringValue
                    print(loc)
                    let position = self.parseLocation(locString: loc)
                    let marker = GMSMarker()
                    let partyData = PartyStruct(name: host, time: date, photoURL: photoURL, count: attendeesCount)
                    print(partyData)
                    marker.userData = partyData
                    marker.position = position
                    print(marker.position)
                    print("added overlay")
                }
            }
        }
    }
    
    

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let place = marker.userData as? PartyStruct {
            let partyVC = partyinfoViewController()
            partyVC.party = place
            present(partyVC, animated: true)
        }
        return true
    }
    func parseLocation(locString: String) -> CLLocationCoordinate2D{
        let separators = CharacterSet(charactersIn: ", ")
        let arr = locString.components(separatedBy: separators)
        let lat = Double(arr[0])
        let lng = Double(arr[2])
        return CLLocationCoordinate2D(latitude: lat!, longitude: lng!)
    }
    
    
    @objc func addPartyButtonPressed()
    {
        let vc = profileViewController()
        present(vc, animated: true, completion: nil)
    }
   
}
    
    


