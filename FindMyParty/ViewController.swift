//
//  ViewController.swift
//  FindMyParty
//
//  Created by Anant Shyam on 11/15/21.
//

import UIKit
import Spring
import Firebase
import GoogleSignIn
import JGProgressHUD

class ViewController: UIViewController{
    private var logo = SpringImageView()
    private var discoball = SpringImageView()
    private var GIDBtn = GIDSignInButton()
    private var nextButton = UIButton()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
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
    @objc func signIn(){
        let hud = JGProgressHUD.init()
        hud.show(in: self.view, animated: true)
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        // Start the sign in flow!
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
                    showAlert(msg: "An error occured while signing you in. \(String(describing: error?.localizedDescription) ?? "Check your internet connection.")")
                }
            }

        }
        hud.dismiss(animated: true)
        let user = Auth.auth().currentUser
        let email = user?.email
        let name = user?.displayName
        let photoURl = user?.photoURL
        print (email,name, photoURl)
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

