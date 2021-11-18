//
//  PartyTableViewCell.swift
//  FindMyParty
//
//  Created by Anant Shyam on 11/18/21.
//

import UIKit

class PartyTableViewCell: UITableViewCell {

    
    var hostlabel = UILabel()
    var locationlabel = UILabel()
    var attendeecount = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        hostlabel.font = .systemFont(ofSize: 14)
        hostlabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hostlabel)
        
        locationlabel.font = .systemFont(ofSize: 14)
        locationlabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(locationlabel)
        
        setUpConstraints()
        
    }
    
    func configure(party: Party) {
        hostlabel.text = party.host.name
        locationlabel.text = party.location
        attendeecount.text = String(party.attendees.count)
        
    }
    
    func setUpConstraints() {
        let padding: CGFloat = 8
        let labelHeight: CGFloat = 20
        
        NSLayoutConstraint.activate([
            hostlabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            hostlabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            hostlabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])
        
        NSLayoutConstraint.activate([
            locationlabel.leadingAnchor.constraint(equalTo: hostlabel.leadingAnchor),
            locationlabel.topAnchor.constraint(equalTo: hostlabel.bottomAnchor),
            locationlabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


}
