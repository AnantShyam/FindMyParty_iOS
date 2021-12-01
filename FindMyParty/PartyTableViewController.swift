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
    private let apiURL =  "https://findmypartyhck1.herokuapp.com/api/"
    var parties: [PartyStruct] = []
    var titles = UILabel()
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
        if let part = tableView.cellForRow(at: indexPath) as? PartyTableViewCell {
            let vc = PartyTableViewController()
            
            present(vc, animated: true, completion: nil)
        }

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
                    if(Date()>absoluteDate!){ //only add future parties to map lmao im a genius
                        let party = PartyStruct(name: host, time: date, photoURL: photoURL, count: attendeesCount, theme: theme, coords: self.parseLocation(locString: loc), id: id)
                        self.parties.append(party)
                    }
                    
                }
            }
        }
        print(self.parties)
    }
//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? PartyTableViewCell {
            let party = parties[indexPath.row]
//            cell.configure(party: party)
            cell.selectionStyle = .none
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let party = parties[indexPath.row]
//        print("hello")
//        let vc = partyinfoViewController()
//        navigationController?.pushViewController(vc, animated: true)
//    }

    func parseLocation(locString: String) -> CLLocationCoordinate2D{
        let separators = CharacterSet(charactersIn: ", ")
        let arr = locString.components(separatedBy: separators)
        let lat = Double(arr[0])
        let lng = Double(arr[2])
        return CLLocationCoordinate2D(latitude: lat!, longitude: lng!)
    }
    

    
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

