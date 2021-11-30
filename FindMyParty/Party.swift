//
//  Party.swift
//  FindMyParty
//
//  Created by Anant Shyam on 11/18/21.
//

import Foundation

class Party {
    var host: AppUser
    var location: String
    var attendees: [AppUser]
    var date: String
    
    init (host: AppUser, location: String, date: String){
        self.host = host
        self.location = location
        self.attendees = []
        self.date = date
    }
    
}


struct PartyStruct {
    var name: String?
    var time: String?
    var photoURL: String?
    var count: Int?
}
