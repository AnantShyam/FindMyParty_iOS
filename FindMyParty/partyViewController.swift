//
//  partyViewController.swift
//  FindMyParty
//
//  Created by Nirbhay Singh on 20/11/21.
//

import UIKit

class partyViewController: UIViewController {
    var party = PartyStruct()
    
    private var logoImg = UIImageView(image: UIImage(named: "logotext"))
    private var partyImg = UIImageView()
    
    private var hostPrompt = UILabel()
    private var hostLbl = UILabel()
    
    private var datePrompt = UILabel()
    private var dateLbl = UILabel()
    
    private var countPrompt = UILabel()
    private var countLbl = UILabel()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setUpUI()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
   
    func setUpUI()
    {
        self.disableAutoTranslation()
//        self.activateConstraints()
        self.view.addSubview(logoImg)
        
        
    }
    func disableAutoTranslation(){
        self.logoImg.translatesAutoresizingMaskIntoConstraints = false
        self.partyImg.translatesAutoresizingMaskIntoConstraints = false
        self.hostPrompt.translatesAutoresizingMaskIntoConstraints = false
        self.hostLbl.translatesAutoresizingMaskIntoConstraints = false
        self.datePrompt.translatesAutoresizingMaskIntoConstraints = false
        self.dateLbl.translatesAutoresizingMaskIntoConstraints = false
        self.countPrompt.translatesAutoresizingMaskIntoConstraints = false
        self.countLbl.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func activateConstraints(){
        NSLayoutConstraint.activate([
//            logoImg.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            logoImg.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
}

