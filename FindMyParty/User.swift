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
    var parties: [PartyStruct]
    var photoURL:String
    var id:Int
    
    init (name:String, email: String, photoURL:String, id:Int){
        self.name = name
        self.email = email
        self.photoURL = photoURL
        self.parties = []
        self.id = id
    }
}
