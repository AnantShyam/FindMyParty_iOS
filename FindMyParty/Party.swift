//
//  Party.swift
//  FindMyParty
//
//  Created by Anant Shyam on 11/18/21.
//

import Foundation

class Party {
    var host: User
    var location: String
    var attendees: [User]
    
    init (host: User, location: String){
        self.host = host
        self.location = location
        self.attendees = []
    }
    
}
