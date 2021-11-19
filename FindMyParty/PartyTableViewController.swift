//
//  PartyTableViewController.swift
//  FindMyParty
//
//  Created by Anant Shyam on 11/18/21.
//

import UIKit
 

class PartyTableViewController: UIViewController, UITableViewDataSource{

    var tableView = UITableView()
    let reuseIdentifier = "partyCellReuse"
    let cellHeight: CGFloat = 50
    var parties: [Party] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Parties"
        view.backgroundColor = .white
        
////        Create Dummy Users
//        let Mark = AppUser(name: "Mark B", email: "mark@cornell.edu")
//        let Daniel = AppUser(name: "Danie B", email: "daniel@cornell.edu")
//
////        Create Dummy Parties
//        let Church315 = Party(host: Mark, location: "315 Church Street")
//        let Beakman412 = Party(host: Daniel, location: "412 Beakman Avenue")
//
//        parties = [Church315, Beakman412]
        
//        Initialize Table View
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.register(
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let party = parties[indexPath.row]
//        if let part = tableView.cellForRow(at: indexPath) as? PartyTableViewCell {
//            let vc = PartyTableViewController()
//            present(vc, animated: true, completion: nil)
//        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    

}


