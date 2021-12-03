//
//  PartyTableViewController.swift
//  FindMyParty
//
//  Created by Anant Shyam on 11/18/21.
//

import UIKit
import Alamofire
import JGProgressHUD
import SwiftyJSON
import CoreLocation
class PartyTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    var tableView = UITableView()
    let reuseIdentifier = "partyCellReuse"
    let cellHeight: CGFloat = 200
    private let apiURL =  "https://findmypartyhackchallenge-e2u4urpvoa-uc.a.run.app/api/"
    var parties: [PartyStruct] = []
    var titles = UILabel()
    var userLoc = CLLocationCoordinate2D()
    var distances:[Double] = []
    let hud = JGProgressHUD.init()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Parties"
        view.backgroundColor = .white
        

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PartyTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        
        titles.font = UIFont.boldSystemFont(ofSize: 25.0)
        titles.text = "Parties"
        titles.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titles)
        
        setupConstraints()
        self.getAllParties()
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let party = parties[indexPath.row]
        let vc = partyinfoViewController()
        vc.party = party
        present(vc, animated: true, completion: nil)
    

    }
    
    func getAllParties(){
        print("in get all parties")
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
                    let attendeesCount = innerParty["attendees"].arrayValue.count
                    let loc = innerParty["location"].stringValue
                    let theme = innerParty["theme"].stringValue
                    let id = Int(innerParty["id"].stringValue)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
                    let absoluteDate = dateFormatter.date(from: date)
                    if(Date()<absoluteDate!){ //only add future parties to map lmao im a genius
                        let party = PartyStruct(name: host, time: date, photoURL: photoURL, count: attendeesCount, theme: theme, coords: self.parseLocation(locString: loc), id: id)
                        self.parties.append(party)
                        let dist = CLLocation(latitude: self.userLoc.latitude, longitude: self.userLoc.longitude
                                                        ).distance(from:CLLocation(latitude: self.parseLocation(locString: loc).latitude, longitude: self.parseLocation(locString: loc).longitude))
                        self.distances.append(dist)
                        DispatchQueue.main.async{
                            self.tableView.reloadData()
                        }
                    }
                    
                }
                self.sortByDistance()
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
            }
        }
       
    }
    func sortByDistance(){
        var ix:[Int]=[]
        let new_distances = self.distances.sorted(by: <)
        for dist in self.distances{
            var index:Int = new_distances.firstIndex(of: dist)!
            ix.append(index)
        }
        var new_parties:[PartyStruct]=[]
        for index in ix{
            new_parties.append(self.parties[index])
        }
        self.parties = new_parties
        
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (self.parties.count != 0){
            let party = self.parties[indexPath.row]
            let cell = profileTableViewCell()
            cell.hostLabel.text = party.name! + "'s party"
            cell.partyImg.load(url: URL(string: party.photoURL!)!)
            var x = party.time
            var y = x!.components(separatedBy: " ")
            var z = y[1].components(separatedBy: ":")
            if Int(z[0])! > 12 {
                z[0] = String(Int(z[0])! - 12)
                x = y[0] + " " + z[0] + ":" + z[1] + " PM"
            }
            else {
                x! = x! + " AM"
            }
            cell.timeLabel.text = x
            cell.party = party
            cell.partyImg.roundedImage()
            cell.userLoc = self.userLoc
            return cell
        }
        else{
            return UITableViewCell()
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let party = parties[indexPath.row]
//        print("hello")
//        let vc = partyinfoViewController()
//        navigationController?.pushViewController(vc, animated: true)
//    }

   
    

    
    func setupConstraints() {
//        Setup the constraints for our views
        
        NSLayoutConstraint.activate([
            titles.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titles.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titles.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: titles.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])

    }
    func parseLocation(locString: String) -> CLLocationCoordinate2D{
        let separators = CharacterSet(charactersIn: ", ")
        let arr = locString.components(separatedBy: separators)
        let lat = Double(arr[0])
        let lng = Double(arr[2])
        return CLLocationCoordinate2D(latitude: lat!, longitude: lng!)
    }


}
//
//extension PartyTableViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //print("hello")
//        let party = parties[indexPath.row]
//        let vc = partyinfoViewController()
//        present(vc, animated: true, completion: nil)
//
//    }
//}

