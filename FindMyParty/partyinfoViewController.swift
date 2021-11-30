//
//  partyinfoViewController.swift
//  FindMyParty
//
//  Created by Anant Shyam on 11/21/21.
//

import UIKit

class partyinfoViewController: UIViewController {
    var party = PartyStruct()
    var logo = UIImageView()
    var discoball = UIImageView()
    
    var hostlabel = UILabel()
    var timinglabel = UILabel()
    var locationlabel = UILabel()
    
    var rsvp = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(party.name)
        
        view.backgroundColor = .white
        logo.image = UIImage(named: "logotext")
        logo.contentMode = .scaleAspectFit
        logo.clipsToBounds = true
        logo.layer.cornerRadius = 5
        logo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logo)
        
        hostlabel.translatesAutoresizingMaskIntoConstraints = false
        hostlabel.font = UIFont.systemFont(ofSize: 18)
        hostlabel.text = "Hosted by: "
        //hostlabel.text = "Hosted by:  " + party.name!
        hostlabel.textColor = .black
        view.addSubview(hostlabel)
        
        timinglabel.translatesAutoresizingMaskIntoConstraints = false
        timinglabel.font = UIFont.systemFont(ofSize: 18)
        timinglabel.text = "On: "
        //timinglabel.text = "On " + party.time!
        timinglabel.textColor = .black
        view.addSubview(timinglabel)
        
//        locationlabel.translatesAutoresizingMaskIntoConstraints = false
//        locationlabel.font = UIFont.systemFont(ofSize: 18)
//        locationlabel.text = "At " + party.
//        locationlabel.textColor = .black
//        view.addSubview(locationlabel)
//
        rsvp.backgroundColor = .purple
        self.rsvp.frame = CGRect(x: 5*UIScreen.main.bounds.width/100, y: self.view.frame.height-400, width: 70, height: 70)
        self.rsvp.borderColor = .white
        self.rsvp.borderWidth = 2
        self.rsvp.cornerRadius = 35
        self.rsvp.setTitle("RSVP", for: .normal)
        view.addSubview(rsvp)
        
        
//        discoball.image = UIImage(named: "discoball")
//        discoball.contentMode = .scaleAspectFit
//        discoball.clipsToBounds = true
//        discoball.layer.cornerRadius = 5
//        discoball.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(discoball)
        
        setUpConstraints()
        
        
        // Do any additional setup after loading the view.
    }
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant: 10),
            logo.bottomAnchor.constraint(equalTo:logo.topAnchor, constant: 75),//100
            logo.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            logo.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
        NSLayoutConstraint.activate([
            hostlabel.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 0),
//            hostlabel.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor, constant: -350),
            hostlabel.bottomAnchor.constraint(equalTo:logo.topAnchor, constant: 150),
            hostlabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            hostlabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
        NSLayoutConstraint.activate([
            timinglabel.topAnchor.constraint(equalTo: hostlabel.bottomAnchor, constant: 50),
//            timinglabel.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            timinglabel.bottomAnchor.constraint(equalTo: hostlabel.topAnchor, constant: 150),
            timinglabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            timinglabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
        
        
        NSLayoutConstraint.activate([
            locationlabel.topAnchor.constraint(equalTo: timinglabel.bottomAnchor, constant: 50),
            locationlabel.bottomAnchor.constraint(equalTo: timinglabel.topAnchor, constant: 100),//100
            locationlabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            locationlabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
        
        
//        NSLayoutConstraint.activate([
//            rsvp.topAnchor.constraint(equalTo: timinglabel.bottomAnchor, constant: 10)
//        ])
//        NSLayoutConstraint.activate([
//            rsvp.heightAnchor.constraint(equalToConstant: 75),
//            rsvp.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant:30),
//            rsvp.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
//        ])
        
        
        
        
//        NSLayoutConstraint.activate([
//            rsvp.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
//        ])
//        NSLayoutConstraint.activate([
//            rsvp.heightAnchor.constraint(equalToConstant: 75),
//            rsvp.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant:30),
//            rsvp.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
//        ])
        
        
        
        
//        NSLayoutConstraint.activate([
//            locationlabel.topAnchor.constraint(equalTo: timinglabel.bottomAnchor, constant: 50),
        
        
        
//            locationlabel.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
//            locationlabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
//            locationlabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
//        ])
        
    }

}


   
