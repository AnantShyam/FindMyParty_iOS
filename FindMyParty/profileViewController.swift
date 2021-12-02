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
import Firebase
class profileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
   
    
    

    var userImage = UIImageView()
    var nameLabel = UILabel()
    var emailLabel = UILabel()
    var partiesAttended = UILabel()
    var imageWidth = 0
    var tableView = UITableView()
    let reuseIdentifier = "partyCellReuse"
    let cellHeight: CGFloat = 110
    var userLoc = CLLocationCoordinate2D()
    lazy var parties: [PartyStruct] = []
    let signOutBtn = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
//        parties.append(newParty)
//        parties.append(newParty2)
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = CGRect(x: 20, y: 200, width: UIScreen.main.bounds.width-40, height: UIScreen.main.bounds.height - 300)
        tableView.register(PartyTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
//        tableView.backgroundColor = .red
        view.addSubview(tableView)
        self.activateConstraints()
        self.getUserParties()
        
        self.signOutBtn.frame = CGRect(x: self.view.layer.bounds.width-90, y: self.view.layer.bounds.height-150, width: 60, height: 60)
        self.signOutBtn.setImage(UIImage(systemName: "arrow.turn.up.left"), for: .normal)
        self.signOutBtn.tintColor = .white
        self.signOutBtn.backgroundColor = .purple
        self.signOutBtn.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        self.view.addSubview(self.signOutBtn)
        
        
        // Do any additional setup after loading the view.
    }
    @objc func signOut(){
        let auth = Firebase.Auth.auth()
        do{
            try auth.signOut()
            let vc = ViewController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
        catch{
            print("err")
        }
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
                if(response.response?.statusCode==200){
                    let jsonResp = JSON(response.data).arrayValue
                    for party in jsonResp
                    {
                        let name = party["host"].stringValue
                        let location = party["location"].stringValue
                        let photoURL = party["photoURL"].stringValue
                        let dateTime = party["dateTime"].stringValue
                        let theme = party["theme"].stringValue
                        print("newPartyDetails=")
                        print(name,location,photoURL)
                        let absoluteDate = dateFormatter.date(from: dateTime)
                        if (Date()<absoluteDate!){
                            let newParty = PartyStruct(name: name, time: dateTime, photoURL: photoURL, count: 0, theme: theme, coords: self.parseLocation(locString: location), id: 0)
                            print("newParty=")
                            print(newParty)
                            self.parties.append(newParty)                            
                            DispatchQueue.main.async{
                                self.tableView.reloadData()
                            }
                        }
                    }
                    print("self.parties=")
                    
                    hud.dismiss()
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of parties: " + String(self.parties.count))
        return self.parties.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (self.parties.count != 0){
            print("in here")
            let party = self.parties[indexPath.row]
            print(party)
            let cell = profileTableViewCell()
            cell.hostLabel.text = party.name! + "'s party"
            cell.partyImg.load(url: URL(string: party.photoURL!)!)
            cell.timeLabel.text = party.time
            cell.party = party
            cell.partyImg.roundedImage()
            cell.userLoc = self.userLoc
            return cell
        }
        else{
            print("data is nil")
            return UITableViewCell()
        }
        
      
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let party = parties[indexPath.row]
        let vc = partyinfoViewController()
        vc.party = party
        vc.flag = true
        print(vc.party)
        print("Clicked")
        present(vc, animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
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
