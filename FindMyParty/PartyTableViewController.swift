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
    let cellHeight: CGFloat = 200
    var parties: [Party] = []
    var titles = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Parties"
        view.backgroundColor = .white
        
//        Create Dummy Users
        let Mark = AppUser(name: "Mark B", email: "mark@cornell.edu", photoURL: "www")
        let Daniel = AppUser(name: "Daniel B", email: "daniel@cornell.edu", photoURL: "www")
        let Brad = AppUser(name: "Brad O", email: "brad@cornell.edu", photoURL: "www")
        let Anant = AppUser(name: "Anant S", email: "anant@cornell.edu", photoURL: "www")
        let Neil = AppUser(name: "Neil G", email: "neil@cornell.edu", photoURL: "www")
        let Logan = AppUser(name: "Logan P", email: "logan@cornell.edu", photoURL: "www")

//        Create Dummy Parties
        let Church315 = Party(host: Mark, location: "315 Church Street")
        let Beakman412 = Party(host: Daniel, location: "412 Beakman Avenue")
        let Cook212 = Party(host: Brad, location: "212 Cook Street")
        let Loma705 = Party(host: Anant, location: "705 Loma Boulevard")
        let Thurston423 = Party(host: Neil, location: "423 Thurston Avenue")
        let Eddy555 = Party(host: Logan, location: "555 Eddy Street")

        parties = [Church315, Beakman412, Cook212, Loma705, Thurston423, Eddy555]
        
//        Initialize Table View
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
        
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return indexPath.row*20
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let party = parties[indexPath.row]
//        if let part = tableView.cellForRow(at: indexPath) as? PartyTableViewCell {
//            let vc = PartyTableViewController()
//            present(vc, animated: true, completion: nil)
//        }
//
//    }
//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? PartyTableViewCell {
            let party = parties[indexPath.row]
            cell.configure(party: party)
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

extension PartyTableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("hello")
        let party = parties[indexPath.row]
        let vc = partyinfoViewController()
        present(vc, animated: true, completion: nil)
       
    }
}

