//
//  profileViewController.swift
//  FindMyParty
//
//  Created by Anant Shyam on 11/19/21.
//

import UIKit
import Alamofire
import JGProgressHUD
import SwiftyJSON
import CoreLocation

class profileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    

    var userImage = UIImageView()
    var nameLabel = UILabel()
    var emailLabel = UILabel()
    var partiesAttended = UILabel()
    var imageWidth = 0
    var tableView = UITableView()
    let reuseIdentifier = "partyCellReuse"
    let cellHeight: CGFloat = 200
    var parties: [PartyStruct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        userImage.backgroundColor = .purple
        userImage.translatesAutoresizingMaskIntoConstraints = false
        print(globalUser.photoURL)
        userImage.image = UIImage(systemName: "person")
        userImage.load(url: URL(string: globalUser.photoURL)!)
        userImage.tintColor = .white
       
        userImage.borderColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userImage)
        nameLabel.text = globalUser.name
        let nameArr = globalUser.name.components(separatedBy: " ")
        var nameStr = ""
        for x in nameArr{
            nameStr += x.capitalizingFirstLetter() + " "
        }
        nameLabel.text = nameStr
        nameLabel.font = UIFont(name: "Avenir Next Heavy", size: 22)
        nameLabel.textColor = .purple
        view.addSubview(nameLabel)
        
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PartyTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        
        self.activateConstraints()
        self.getUserParties()
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillLayoutSubviews() {
        userImage.roundedImage()
    }
    func activateConstraints(){
        NSLayoutConstraint.activate([
            userImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            userImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            userImage.widthAnchor.constraint(equalToConstant: 90),
            userImage.heightAnchor.constraint(equalToConstant: 90)
        ])
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: userImage.topAnchor, constant: 30+userImage.layer.bounds.height/2),
            nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            nameLabel.trailingAnchor.constraint(equalTo: userImage.leadingAnchor, constant: -30),
            nameLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func getUserParties()
    {
        print(globalUser.id)
        print("called getuserparties")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let hud = JGProgressHUD.init()
        hud.show(in: self.view)
        let endpoint =  "https://findmypartyhck1.herokuapp.com/api/user/" + String(globalUser.id) + "/parties/"
        AF.request(endpoint).validate().responseData() { response in
            hud.dismiss()
                if(response.response?.statusCode==200){
                    let jsonResp = JSON(response.data).arrayValue
                    for party in jsonResp
                    {
                        let name = party["host"].stringValue
                        let location = party["location"].stringValue
                        let photoURL = party["photoURL"].stringValue
                        let dateTime = party["dateTime"].stringValue
                        let theme = party["theme"].stringValue
                        print(name,location,photoURL)
                        let absoluteDate = dateFormatter.date(from: dateTime)
                        if (Date()<absoluteDate!){
                            let newParty = PartyStruct(name: name, time: dateTime, photoURL: photoURL, count: 0, theme: theme, coords: self.parseLocation(locString: location), id: 0)
                            print(newParty.time)
                            self.parties.append(newParty)
                        }
                    }
                    print(self.parties)
                    //populate user view here
                    if(self.parties.count==0){
                        //addlabel
                    }else{
                        
                    }
                }
            else{
                hud.dismiss()
                showAlert(msg: "You seem to have connectivity issues.")
            }
        }
    }
    func parseLocation(locString: String) -> CLLocationCoordinate2D{
        let separators = CharacterSet(charactersIn: ", ")
        let arr = locString.components(separatedBy: separators)
        let lat = Double(arr[0])
        let lng = Double(arr[2])
        return CLLocationCoordinate2D(latitude: lat!, longitude: lng!)
    }
}





extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}
