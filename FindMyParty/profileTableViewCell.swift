//
//  profileTableViewCell.swift
//  FindMyParty
//
//  Created by Anant Shyam on 12/1/21.
//

import UIKit
import MapKit
import CoreLocation
class profileTableViewCell: UITableViewCell {
    var hostLabel = UILabel()
    var timeLabel = UILabel()
    var locationButton = UIButton()
    var partyImg = UIImageView()
    var userLoc = CLLocationCoordinate2D()
    var party=PartyStruct()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        hostLabel.font = UIFont(name: "Avenir Next Heavy", size: 18)
        hostLabel.textColor = .purple
        hostLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(hostLabel)
        
        timeLabel.font = UIFont(name: "Avenir Next Medium", size: 14)
        timeLabel.textColor = .purple
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timeLabel)
        
        partyImg.backgroundColor = .purple
        partyImg.translatesAutoresizingMaskIntoConstraints = false
        print(globalUser.photoURL)
        partyImg.image = UIImage(systemName: "person")
        //userImage.load(url: URL(string: globalUser.photoURL)!)
        partyImg.tintColor = .white
        contentView.addSubview(partyImg)
        
        locationButton.backgroundColor = .purple
        locationButton.cornerRadius = 10
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        locationButton.setTitle("Open in Maps", for: .normal)
        locationButton.titleLabel?.font = UIFont(name: "Avenir Next Medium", size: 14)
        locationButton.setTitleColor(.white, for: .normal)
        contentView.addSubview(locationButton)
        
        self.locationButton.addTarget(self, action: #selector(openInMaps), for: .touchUpInside)
        setUpConstraints()
        partyImg.roundedImage()
    }
    
    @objc func openInMaps(){
        let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: self.userLoc.latitude, longitude: self.userLoc.longitude)))
                source.name = "You"
        let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: self.party.coords!.latitude, longitude: self.party.coords!.longitude)))
        destination.name = self.party.name! + "'s party"
        MKMapItem.openMaps(with: [source, destination], launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        
    }
    
    func configure(party: Party) {
        hostLabel.text = "Hosted by : " + party.host.name
    }
    
    func setUpConstraints() {
        let padding: CGFloat = 8
        let labelHeight: CGFloat = 20
        
        NSLayoutConstraint.activate([
            hostLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            hostLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            hostLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: hostLabel.leadingAnchor),
            timeLabel.topAnchor.constraint(equalTo: hostLabel.bottomAnchor),
            timeLabel.heightAnchor.constraint(equalToConstant: labelHeight)
        ])
        
        NSLayoutConstraint.activate([
            partyImg.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            partyImg.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            partyImg.heightAnchor.constraint(equalToConstant: 80 ),
            partyImg.widthAnchor.constraint(equalToConstant: 80)
        ])
        NSLayoutConstraint.activate([
            locationButton.leadingAnchor.constraint(equalTo: hostLabel.leadingAnchor),
            locationButton.trailingAnchor.constraint(equalTo: hostLabel.trailingAnchor),
            locationButton.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 10),
            locationButton.heightAnchor.constraint(equalToConstant: 30)
            
        ])
        
    }
    
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
    
