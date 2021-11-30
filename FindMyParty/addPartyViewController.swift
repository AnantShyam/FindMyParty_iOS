//
//  addPartyViewController.swift
//  FindMyParty
//
//  Created by Anant Shyam on 11/29/21.
//

import UIKit
import Spring
import Firebase

class addPartyViewController: UIViewController {
    var datePicker = UIDatePicker()
    var dateLabel = UILabel()
    var logo = SpringImageView()
    var padding = 50
    var addpartybutton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        logo.frame = CGRect(x: 30, y: 0, width: self.view.frame.width-60, height: 75)
        logo.image = UIImage(named: "logotext")
        logo.contentMode = .scaleAspectFit
        logo.clipsToBounds = true
        logo.layer.cornerRadius = 5
        logo.animation = "squeezeRight"
        logo.force = 3.0
        logo.duration = 1.5
        logo.animate()
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.backgroundColor = UIColor.white
        view.addSubview(logo)
        
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = UIFont.systemFont(ofSize: 20)
        dateLabel.text = "Choose a date and time: "
        dateLabel.textColor = .purple
        view.addSubview(dateLabel)
        
//        datePicker.frame = CGRect(x: -Int(self.view.frame.width)/2 + padding, y: Int(logo.image!.size.height) - 40, width: Int(self.view.frame.width), height: 50)
        datePicker.frame = CGRect(x: 30, y: logo.image!.size.height, width: self.view.frame.width-60, height: 100)
        datePicker.contentHorizontalAlignment = .left
        datePicker.timeZone = NSTimeZone.local
//        datePicker.backgroundColor = UIColor.green
        view.addSubview(datePicker)
        
        addpartybutton.backgroundColor = .purple
        addpartybutton.frame = CGRect(x: 15*UIScreen.main.bounds.width/20, y: self.view.frame.height-175, width: 70, height: 70)
        addpartybutton.borderColor = .white
        addpartybutton.borderWidth = 2
        addpartybutton.cornerRadius = 35
        addpartybutton.setTitle("Add", for: .normal)
        addpartybutton.addTarget(self, action: #selector(addPartyButtonPressed), for: .touchUpInside)
        view.addSubview(addpartybutton)
        
        setUpConstraints()
    }
    
    func setUpConstraints(){
        
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant: 10),
            logo.bottomAnchor.constraint(equalTo:logo.topAnchor, constant: 100),
            logo.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            logo.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 10),
            dateLabel.bottomAnchor.constraint(equalTo: datePicker.topAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            dateLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 50),
            datePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 100),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])

    }
    
    @objc func addPartyButtonPressed() {
        let date = datePicker.date
        let dformatter = DateFormatter()
        dformatter.dateFormat = "MM-dd-yyyy HH:mm"
        let datestr = dformatter.string(from: date)
//        let user = AppUser(name: globalUser.name, email: globalUser.email, photoURL: globalUser.photoURL)
        let newparty = Party(host: globalUser, location: "Cornell University", date: datestr)
        print(newparty.host.email)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
