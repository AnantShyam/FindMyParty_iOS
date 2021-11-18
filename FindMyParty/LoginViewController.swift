//
//  LoginViewController.swift
//  FindMyParty
//
//  Created by Anant Shyam on 11/17/21.
//

import UIKit
import Spring

class LoginViewController: UIViewController {

    let screenSize: CGRect = UIScreen.main.bounds
  
    
    private var logo = SpringImageView()
    private var email = UITextField()
    private var password = UITextField()
    private var loginButton = UIButton()
    private var signUpButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        email.translatesAutoresizingMaskIntoConstraints = false
        email.placeholder = "Enter Email"
        email.borderStyle = .roundedRect
        email.textAlignment = .left
        view.addSubview(email)
        
        password.translatesAutoresizingMaskIntoConstraints = false
        password.placeholder = "Enter Password"
        password.borderStyle = .roundedRect
        password.textAlignment = .left
        view.addSubview(password)

        loginButton.tintColor = UIColor.purple
        loginButton.setTitleColor(.systemBlue, for: .normal)
        loginButton.layer.borderWidth = 30
        loginButton.layer.borderColor = UIColor.systemBlue.cgColor
        loginButton.layer.cornerRadius = 10
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        view.addSubview(loginButton)

        
        signUpButton.tintColor = UIColor.purple
        signUpButton.setTitleColor(.systemBlue, for: .normal)
        signUpButton.layer.borderWidth = 30
        signUpButton.layer.borderColor = UIColor.systemBlue.cgColor
        signUpButton.layer.cornerRadius = 10
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        view.addSubview(signUpButton)
        
        setUpConstraints()
 
    }
    
    @objc func loginButtonTapped(){
        let vc = LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func signUpButtonTapped(){
        let vc = LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func setUpConstraints() {
//
        print(screenSize.width)
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant: 10),
            logo.bottomAnchor.constraint(equalTo:logo.topAnchor, constant: 100),
            logo.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            logo.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
//
//
        NSLayoutConstraint.activate([
            email.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 100),
            email.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            email.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)

        ])
        
        NSLayoutConstraint.activate([
            password.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 20),
            password.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            password.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])

        NSLayoutConstraint.activate([
            
            loginButton.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 20),
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -50),
//            loginButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -195),

        ])
        
        NSLayoutConstraint.activate([

            signUpButton.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 20),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 50),
        ])

        
    }
    
}
