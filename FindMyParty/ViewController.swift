//
//  ViewController.swift
//  FindMyParty
//
//  Created by Anant Shyam on 11/15/21.
//

import UIKit
import Spring


class ViewController: UIViewController {
    
    private var logo = SpringImageView()
    private var discoball = SpringImageView()
    
    private var nextButton = UIButton()
    

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
        
        let btnImg:UIImage=UIImage(systemName: "arrow.right.circle.fill")!
        nextButton.tintColor = UIColor.purple
        nextButton.frame = CGRect(x: 100,y: 100,width: 100, height: 50)
        nextButton.setImage(btnImg, for: .normal)

//        nextButton.setTitleColor(.systemBlue, for: .normal)
//        nextButton.layer.borderWidth = 4
//        nextButton.layer.borderColor = UIColor.systemBlue.cgColor
//        nextButton.layer.cornerRadius = 10
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(nextButtontapped), for: .touchUpInside)
        view.addSubview(nextButton)
        
        
        setUpConstraints()
        

        // Do any additional setup after loading the view.
    }
    
    @objc func nextButtontapped(){
        let vc = LoginViewController()
        navigationController?.pushViewController(vc, animated: true)
        
            
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

            nextButton.topAnchor.constraint(equalTo: discoball.bottomAnchor, constant: 20),
            nextButton.heightAnchor.constraint(equalToConstant: 25),
            nextButton.trailingAnchor.constraint(equalTo: discoball.trailingAnchor, constant: -20)
            

        ])

        
    }
    

}

