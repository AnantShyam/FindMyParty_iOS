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
import SwiftyJSON

struct PartyStruct {
    var name: String?
    var time: String?
    var photoURL: String?
    var count: Int?
}

class PartyMarker:UIView{
    @IBAction func rsvpTouched(_ sender: Any) {
        print("heheh haas dele rinkiya ke papa")
    }
    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var partyImgView: UIImageView!
    @IBOutlet weak var dateLbl: UILabel!
    
    private var name:String
    private var date:String
    private var photoURL:String
    private var count:Int
    
    init(frame:CGRect,name:String, time:String, photoURL:String, attendeeCount:Int){
        self.name = name
        self.date = time
        self.photoURL = photoURL
        self.count = attendeeCount
        super.init(frame: frame)
        self.setUpView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpView(){
//        nameLbl.text = self.name
//        dateLbl.text = date
//        partyImgView.load(url: URL(string:photoURL)!)
//        countLbl.text = "\(String(self.count)) 🙋🏻‍♂️"
    }
    class func instanceFromNib() -> UIView {
            return UINib(nibName: "PartyMarkerInfoView", bundle: nil).instantiate(withOwner: self, options: nil).first as! UIView
        }
}

class mapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate{
    private var mapView = GMSMapView()
    private var profilePic = UIImageView()
    private let defaultPic = "https://cdn3.iconfinder.com/data/icons/essential-rounded/64/Rounded-31-512.png"
    private var toTable = UIButton()
    private var toProf = UIButton()
    private let locationManager = CLLocationManager()
    private var coords:CLLocationCoordinate2D!
    private let hud = JGProgressHUD.init()
    private let apiURL = "http://10.48.103.166:5000/api/"
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
        mapView.delegate = self
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
        AF.request(apiURL+"parties/", method: .get).response() { response in
            if(response.error != nil){
                self.hud.dismiss()
                showAlert(msg: "You appear to be offline, check your internet connectivity and retry.")
            }else{
                let jsonResp = JSON(response.value as Any)
                let parties = jsonResp["parties"]
                var index = 0
                for party in parties{
                    let innerParty = party.1
                    print(innerParty)
                    let date = innerParty["dateTime"].stringValue
                    let photoURL = innerParty["photoURL"].stringValue
                    let host = innerParty["host"].stringValue
                    let attendeesCount = innerParty["attendees"].stringValue
                    let loc = innerParty["location"].stringValue
                    let position = self.parseLocation(locString: loc)
                    let marker = GMSMarker()
                    let partyData = PartyStruct(name: host, time: date, photoURL: photoURL, count: 1)
                    marker.userData = partyData
                    marker.position = position
                    marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)
                    marker.zIndex = Int32(index)
                    marker.map = self.mapView
                    index+=1
                }
            }
        }
    }
    
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        if let place = marker.userData as? PartyStruct {
                 marker.tracksInfoWindowChanges = true
                 let height: CGFloat = 100
            var infoWindow = loadNiB()
            infoWindow = PartyMarker(frame: CGRect(x: 0, y: 0, width: 200, height: height), name: place.name!, time: place.time!, photoURL: place.photoURL!, attendeeCount: place.count!)
                 infoWindow.tag = 5555
            return infoWindow
             }
             return nil
         }
    func loadNiB() -> PartyMarker {
        let infoWindow = PartyMarker.instanceFromNib() as! PartyMarker
        return infoWindow
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print("marker was tapped")
        return true
    }
    func parseLocation(locString: String) -> CLLocationCoordinate2D{
        let separators = CharacterSet(charactersIn: ", ")
        let arr = locString.components(separatedBy: separators)
        print(arr)
        let lat = Double(arr[0])!
        let lng = Double(arr[2])!
        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
   
}
    
    


