//
//  profileViewController.swift
//  FindMyParty
//
//  Created by Anant Shyam on 11/19/21.
//

import UIKit

class profileViewController: UIViewController {

    var userImage = UIImageView()
    var nameLabel = UILabel()
    var emailLabel = UILabel()
    var partiesAttended = UILabel()
    var imageWidth = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        userImage.backgroundColor = .purple
        let fileUrl = URL(string: globalUser.photoURL)
        userImage.load(url: fileUrl!)
        userImage.frame = CGRect(x: UIScreen.main.bounds.width/2, y: 60, width: 120, height: 120)
        userImage.borderColor = .white
        userImage.borderWidth = 20
        userImage.cornerRadius = 175
//        userImage.clipsToBounds = true

 
        view.addSubview(userImage)
        
        
        // Do any additional setup after loading the view.
    }
}

extension UIImageView {
    func loads(url: URL, images: UIImageView) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                        images.image = image
                    }
                }
            }
        }
    }
}
