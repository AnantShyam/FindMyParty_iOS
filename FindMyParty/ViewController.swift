//
//  ViewController.swift
//  FindMyParty
//
//  Created by Anant Shyam on 11/15/21.
//
var globalUser = AppUser(name: "", email: "", photoURL: "", id: 0)
import UIKit
import Spring
import Firebase
import GoogleSignIn
import JGProgressHUD
import SwiftyJSON
import Alamofire
import CoreLocation

class ViewController: UIViewController{
    private var logo = SpringImageView()
    private var discoball = SpringImageView()
    private var GIDBtn = GIDSignInButton()
    private var nextButton = UIButton()
    
    let apiURL = "http://10.48.103.166:5000/api/"
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
        if (Auth.auth().currentUser != nil)
        {
            print("called")
            self.fetchUserData(email: (Auth.auth().currentUser?.email)!)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.setUpConstraints()
    }
    func setUpUI(){
        view.backgroundColor = .white
        logo.image = UIImage(named: "logotext")
        logo.contentMode = .scaleAspectFit
        logo.clipsToBounds = true
        logo.layer.cornerRadius = 5
        logo.animation = "squeezeRight"
        logo.force = 3.0
        logo.duration = 1.5
        logo.animate()
        logo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logo)
        discoball.image = UIImage(named: "discoball")
        discoball.contentMode = .scaleAspectFit
        discoball.clipsToBounds = true
        discoball.layer.cornerRadius = 5
        discoball.translatesAutoresizingMaskIntoConstraints = false
        discoball.animation = "wobble"
        discoball.force = 3.0
        discoball.duration = 1.5
        discoball.animate()
        view.addSubview(discoball)
        GIDBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(GIDBtn)
        GIDBtn.addTarget(self, action: #selector(signIn), for: .touchDown)
    }
    struct User:Codable{
        let email:String
        let name:String
        let photoURL:String
    }
    
    struct Email:Codable{
        let email:String
    }
    
    @objc func signIn(){
        let hud = JGProgressHUD.init()
        hud.show(in: self.view, animated: true)
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            hud.dismiss(animated: true)
            showAlert(msg: "An error occured while signing you in.")
            return
        }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
        if error != nil {
            hud.dismiss(animated: true)
            showAlert(msg: "An error occured while signing you in. \(error?.localizedDescription)")
            return
          }
          guard let authentication = user?.authentication, let idToken = authentication.idToken
          else
          {
            hud.dismiss(animated: true)
            showAlert(msg: "An error occured while signing you in.")
            return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,accessToken: authentication.accessToken)
            Auth.auth().signIn(with: credential) { authResult, error in
                if error != nil{
                    hud.dismiss(animated: true)
                    showAlert(msg: "An error occured while signing you in. \(String(describing: error?.localizedDescription) )")
                }else{
                    let user = Auth.auth().currentUser
                    let email = user?.email
                    let name = user?.displayName
                    let photoURl = user?.photoURL?.absoluteString
                    globalUser.email = email ?? ""
                    globalUser.name = name ?? ""
                    globalUser.photoURL = photoURl ?? ""
                    let params = User(email: globalUser.email, name: globalUser.name, photoURL: globalUser.photoURL)
                    let authURL = self.apiURL + "users/"
                    AF.request(authURL, method: .post, parameters: params,encoder: JSONParameterEncoder.default).validate().responseData() { response in
                        let jsonResp = JSON(response.value) 
                        globalUser.id = Int(jsonResp["id"].stringValue)!
                        hud.dismiss(animated: true)
                        showSuccess(msg: "You've been signed up!")
                        let mapVC = mapViewController()
                        self.navigationController?.pushViewController(mapVC, animated: true)
                        }
                    }
                }
            }
        }
    
    
    
    func fetchUserData(email:String){
        let hud = JGProgressHUD.init()
        hud.show(in: self.view)
        let authFetchURL = self.apiURL + "user/email/"
        let params = Email(email: (Auth.auth().currentUser?.email)!)
        AF.request(authFetchURL, method: .post, parameters: params,encoder: JSONParameterEncoder.default).validate().responseData() { [self] response in
            hud.dismiss()
            let jsonResp = JSON(response.value as Any)
            globalUser.name = jsonResp["name"].stringValue
            globalUser.photoURL = jsonResp["photoURL"].stringValue
            let parties = jsonResp["parties"].arrayValue
            print("Parties \(parties)")
            for party in parties{
                let loc = self.parseLocation(locString: party["location"].rawValue as! String)
                let party1 = PartyStruct(name: party["host"].rawValue as! String, time: party["dateTime"].rawValue as! String, photoURL: party["photoURL"].rawValue as! String, count: 0, theme: party["theme"].rawValue as! String, coords: loc, id: party["id"].rawValue as! Int)
                globalUser.parties.append(party1)
            }
            globalUser.email = jsonResp["email"].stringValue
            globalUser.id = Int(jsonResp["id"].stringValue)!
            let mapVC = mapViewController()
            self.navigationController?.pushViewController(mapVC, animated: true)
        }
    }
    func parseLocation(locString: String) -> CLLocationCoordinate2D{
        let separators = CharacterSet(charactersIn: ", ")
        let arr = locString.components(separatedBy: separators)
        let lat = Double(arr[0])
        let lng = Double(arr[2])
        return CLLocationCoordinate2D(latitude: lat!, longitude: lng!)
    }
    

    
    func setUpConstraints() {
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant: 10),
            logo.bottomAnchor.constraint(equalTo:logo.topAnchor, constant: 100),
            logo.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            logo.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
        NSLayoutConstraint.activate([
            discoball.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 0),
            discoball.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            discoball.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            discoball.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
        NSLayoutConstraint.activate([
            GIDBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100)
        ])
        NSLayoutConstraint.activate([
            GIDBtn.heightAnchor.constraint(equalToConstant: 75),
            GIDBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant:30),
            GIDBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
    }
    

}

