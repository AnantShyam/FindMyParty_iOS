//
//  partyinfoViewController.swift
//  FindMyParty
//
//  Created by Anant Shyam on 11/21/21.
//

import UIKit
import CoreLocation
import JGProgressHUD
import Alamofire
import SwiftyJSON
import Spring


class partyinfoViewController: UIViewController {
    
    var party = PartyStruct()
    var currentLocation = CLLocationCoordinate2D()
    var logo = SpringImageView()
    var distanceMeasure = Double()
    
    var hostLabel = UILabel()
    
    var timeLabel = UILabel()
    var timePrompt = UILabel()
    
    var distancePrompt = UILabel()
    var distanceLabel = UILabel()
    
    var partyImg = SpringImageView()
    
    var themeLabel = UILabel()
    var themePrompt = UILabel()
    
    var attendeesPrompt = UILabel()
    var attendeesLabel = UILabel()
    
    var rsvpBtn = SpringButton()
    
    var flag = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.refreshAttendees()
        
        view.backgroundColor = .white
        
        logo.animation = "squeezeLeft"
        partyImg.animation = "squeezeRight"
        rsvpBtn.animation = "squeezeLeft"
        logo.animate()
        partyImg.animate()
        rsvpBtn.animate()
        
        
        logo.image = UIImage(named: "logotext")
        logo.contentMode = .scaleAspectFit
        logo.clipsToBounds = true
        logo.layer.cornerRadius = 5
        logo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logo)
        
        hostLabel.translatesAutoresizingMaskIntoConstraints = false
        hostLabel.text = party.name! + "'s party!"
        hostLabel.font = UIFont(name: "Avenir Next Heavy", size: 24)
        hostLabel.textColor = .black
        view.addSubview(hostLabel)
        
        partyImg.translatesAutoresizingMaskIntoConstraints = false
        partyImg.image = UIImage(systemName: "task")
        partyImg.tintColor = .black
        partyImg.load(url: URL(string:party.photoURL!)!)
        partyImg.borderColor = .purple
        partyImg.borderWidth = 3
        partyImg.cornerRadius = 10
        partyImg.contentMode = UIView.ContentMode.scaleAspectFill
        partyImg.layer.masksToBounds = true
        partyImg.adjustsImageSizeForAccessibilityContentSizeCategory = true
        view.addSubview(partyImg)
        
        distancePrompt.translatesAutoresizingMaskIntoConstraints = false
        distancePrompt.text = "Distance from you"
        distancePrompt.textColor = .purple
        distancePrompt.font = UIFont(name: "Avenir Next Demi Bold", size: 20)
        view.addSubview(distancePrompt)
        
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceMeasure = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude).distance(from: CLLocation(latitude: party.coords!.latitude, longitude: party.coords!.longitude))
        let distanceStr = distanceMeasure.kmFormatted
        distanceLabel.text = distanceStr + "m away"
        distanceLabel.font = UIFont(name: "Avenir Next Medium", size: 20)
        distanceLabel.textColor = .black
        view.addSubview(distanceLabel)
        
        timePrompt.translatesAutoresizingMaskIntoConstraints = false
        timePrompt.text = "Date and time"
        timePrompt.textColor = .purple
        timePrompt.font = UIFont(name: "Avenir Next Demi Bold", size: 20)
        view.addSubview(timePrompt)
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.text = party.time!
        timeLabel.textColor = .black
        timeLabel.font = UIFont(name: "Avenir Next Medium", size: 20)
        view.addSubview(timeLabel)
        
        themePrompt.translatesAutoresizingMaskIntoConstraints = false
        themePrompt.text = "Theme"
        themePrompt.textColor = .purple
        themePrompt.font = UIFont(name: "Avenir Next Demi Bold", size: 20)
        view.addSubview(themePrompt)
        
        themeLabel.translatesAutoresizingMaskIntoConstraints = false
        themeLabel.text = party.theme!
        themeLabel.textColor = .black
        themeLabel.font = UIFont(name: "Avenir Next Medium", size: 20)
        view.addSubview(themeLabel)
        
        attendeesPrompt.translatesAutoresizingMaskIntoConstraints = false
        attendeesPrompt.text = "Attendees"
        attendeesPrompt.textColor = .purple
        attendeesPrompt.font = UIFont(name: "Avenir Next Demi Bold", size: 20)
        view.addSubview(attendeesPrompt)
        
        attendeesLabel.translatesAutoresizingMaskIntoConstraints = false
        attendeesLabel.text = String(party.count!)
        attendeesLabel.textColor = .black
        attendeesLabel.font = UIFont(name: "Avenir Next Medium", size: 20)
        view.addSubview(attendeesLabel)
        
        rsvpBtn.translatesAutoresizingMaskIntoConstraints = false
        rsvpBtn.backgroundColor = .purple
        rsvpBtn.setTitle("RSVP 💪🏻", for: .normal)
        rsvpBtn.titleLabel?.font = UIFont(name: "Avenir Next Demi Bold", size: 20)
        rsvpBtn.cornerRadius = 10
  
        view.addSubview(rsvpBtn)
        if flag{
            rsvpBtn.isHidden = true
        }
        rsvpBtn.addTarget(self, action: #selector(rsvpAction), for: .touchDown)
       
        setUpConstraints()
        
    }
    func refreshAttendees(){
        let hud = JGProgressHUD.init()
        hud.show(in: self.view)
        let idString = String(self.party.id!)
        let endpoint =  "https://findmypartyhackchallenge-e2u4urpvoa-uc.a.run.app/api/party/"+idString
        AF.request(endpoint).validate().responseData() { response in
            hud.dismiss()
            if(response.response?.statusCode==200){
                let resJSON = JSON(response.value as Any)
                self.party.count = resJSON["attendees"].arrayValue.count
                self.attendeesLabel.text = String(resJSON["attendees"].arrayValue.count)
            }else{
                print(response.error?.errorDescription)
                showAlert(msg: "You may be facing connectivity issues.")
            }
            let jsonResp = JSON(response.value as Any)
            print(jsonResp)
        }
    }
    
    @objc func rsvpAction(){
        let hud = JGProgressHUD.init()
        hud.show(in: self.view)
        var endpoint =  "https://findmypartyhackchallenge-e2u4urpvoa-uc.a.run.app/api/user/" + String(globalUser.id) + "/parties/"
        AF.request(endpoint).validate().responseData() { response in
            hud.dismiss()
            if(response.response?.statusCode==200){
                let jsonResp = JSON(response.value as Any).arrayValue
                for party1 in jsonResp{
                    print("user has already joined " + party1["id"].stringValue)
                    print("this party is " + String(self.party.id!))
                    if(party1["id"].intValue == self.party.id!){
                        showAlert(msg: "You've already signed up!")
                        return
                    }
                }
                let params = ID(user_id: globalUser.id)
                print(params.user_id)
                let idString = String(self.party.id!)
                endpoint =  "https://findmypartyhackchallenge-e2u4urpvoa-uc.a.run.app/api/party/"+idString+"/attend/"
                print(endpoint)
                AF.request(endpoint, method: .post, parameters: params,encoder: JSONParameterEncoder.default).validate().responseData() { response in
                    hud.dismiss()
                    if(response.response?.statusCode==200){
                        showSuccess(msg: "Successfully signed up")
                    }else{
                        print(response.error?.errorDescription)
                        showAlert(msg: "You may be facing connectivity issues.")
                    }
                    let jsonResp = JSON(response.value as Any)
                    print(jsonResp)
                }
            }
            
            else {
                print(response.error?.errorDescription)
                showAlert(msg: "You may be facing connectivity issues.")
            }
        }
        struct ID:Encodable{
            var user_id:Int
        }
        

        
    }
    
    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant: 10),
            logo.bottomAnchor.constraint(equalTo:logo.topAnchor, constant: 75),
            logo.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            logo.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
        NSLayoutConstraint.activate([
            hostLabel.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 30),
            hostLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            hostLabel.bottomAnchor.constraint(equalTo: hostLabel.topAnchor, constant: 30)
        ])
        NSLayoutConstraint.activate([
            partyImg.topAnchor.constraint(equalTo: hostLabel.bottomAnchor, constant: 30),
            partyImg.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            partyImg.widthAnchor.constraint(equalToConstant: 250),
            partyImg.bottomAnchor.constraint(equalTo: partyImg.topAnchor, constant: 120)
        ])
        NSLayoutConstraint.activate([
            distancePrompt.topAnchor.constraint(equalTo: partyImg.bottomAnchor, constant: 30),
            distancePrompt.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            distancePrompt.bottomAnchor.constraint(equalTo: distanceLabel.topAnchor, constant: 30)
        ])

        NSLayoutConstraint.activate([
            distanceLabel.topAnchor.constraint(equalTo: partyImg.bottomAnchor, constant: 30),
            distanceLabel.leadingAnchor.constraint(equalTo: distancePrompt.trailingAnchor, constant: 30),
            distanceLabel.bottomAnchor.constraint(equalTo: distanceLabel.topAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            timePrompt.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 30),
            timePrompt.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            timePrompt.bottomAnchor.constraint(equalTo: timePrompt.topAnchor, constant: 30)
        ])

        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 30),
            timeLabel.leadingAnchor.constraint(equalTo: timePrompt.trailingAnchor, constant: 30),
            timeLabel.bottomAnchor.constraint(equalTo: timeLabel.topAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            themePrompt.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 30),
            themePrompt.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            themePrompt.bottomAnchor.constraint(equalTo: themePrompt.topAnchor, constant: 30)
        ])

        NSLayoutConstraint.activate([
            themeLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 30),
            themeLabel.leadingAnchor.constraint(equalTo: themePrompt.trailingAnchor, constant: 30),
            themeLabel.bottomAnchor.constraint(equalTo: themeLabel.topAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            attendeesPrompt.topAnchor.constraint(equalTo: themeLabel.bottomAnchor, constant: 30),
            attendeesPrompt.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            attendeesPrompt.bottomAnchor.constraint(equalTo: attendeesPrompt.topAnchor, constant: 30)
        ])

        NSLayoutConstraint.activate([
            attendeesLabel.topAnchor.constraint(equalTo: themeLabel.bottomAnchor, constant: 30),
            attendeesLabel.leadingAnchor.constraint(equalTo: attendeesPrompt.trailingAnchor, constant: 30),
            attendeesLabel.bottomAnchor.constraint(equalTo: attendeesLabel.topAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            rsvpBtn.topAnchor.constraint(equalTo: attendeesLabel.bottomAnchor, constant: 30),
            rsvpBtn.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            rsvpBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            rsvpBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            rsvpBtn.heightAnchor.constraint(equalToConstant: 75)
        ])

    }

}


   
