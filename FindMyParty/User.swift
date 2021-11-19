//
//  User.swift
//  FindMyParty
//
//  Created by Anant Shyam on 11/18/21.
//

import Foundation
import UIKit

class AppUser{
    var name: String
    var email: String
    var partiesHosted: [Party]
    var photoURL:String
    
    init (name:String, email: String, photoURL:String){
        self.name = name
        self.email = email
        self.photoURL = photoURL
        self.partiesHosted = []

    }
}
