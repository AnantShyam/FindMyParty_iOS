//
//  User.swift
//  FindMyParty
//
//  Created by Anant Shyam on 11/18/21.
//

import Foundation
import UIKit

class User{
    var name: String
    var email: String
    var partiesHosted: [Party]
//    var photo = UIImage()
    
    init (name:String, email: String){
        self.name = name
        self.email = email
//        self.photo = photo
        self.partiesHosted = []
        
    }
}
