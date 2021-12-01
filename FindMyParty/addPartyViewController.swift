//
//  addPartyViewController.swift
//  FindMyParty
//
//  Created by Anant Shyam on 11/29/21.
//

import UIKit
import Spring
import GoogleMaps
import Firebase
import Alamofire
import JGProgressHUD
import SwiftyJSON
class addPartyViewController: UIViewController, GMSMapViewDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    var datePicker = UIDatePicker()
    var dateLabel = UILabel()
    var logo = SpringImageView()
    var padding = 50
    var addpartybutton = UIButton()
    let mapPrompt = UILabel()
    var themeTf = UITextField()
    var userLoc = CLLocationCoordinate2D()
    var viewForMap = UIView()
    var photoPicker = UIButton()
    let mapView = GMSMapView()
    var imgData:Data!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
        imagePicker.delegate = self
        self.hideKeyboardWhenTappedAround()
        
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
        dateLabel.font = UIFont(name: "Avenir Next Demi Bold", size: 20)
        dateLabel.text = "Choose a date and time. "
        dateLabel.textColor = .purple
        view.addSubview(dateLabel)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.frame = CGRect(x: 30, y: logo.image!.size.height, width: self.view.frame.width-60, height: 100)
        datePicker.contentHorizontalAlignment = .left
        datePicker.timeZone = NSTimeZone.local
        view.addSubview(datePicker)
        
        addpartybutton.backgroundColor = .purple
        addpartybutton.frame = CGRect(x: 15*UIScreen.main.bounds.width/20, y: self.view.frame.height-175, width: 70, height: 70)
        addpartybutton.borderColor = .white
        addpartybutton.borderWidth = 2
        addpartybutton.cornerRadius = 35
        addpartybutton.setImage(UIImage(systemName: "plus"), for: .normal)
        addpartybutton.addTarget(self, action: #selector(addPartyButtonPressed), for: .touchUpInside)
        addpartybutton.imageView?.tintColor = .white
        view.addSubview(addpartybutton)
        
        themeTf.translatesAutoresizingMaskIntoConstraints = false
        themeTf.textColor = .black
        themeTf.placeholder = "Enter a theme here"
        themeTf.borderStyle = .roundedRect
        themeTf.borderColor = .purple
        self.view.addSubview(themeTf)
        
        
        mapPrompt.text = "Select a location."
        mapPrompt.translatesAutoresizingMaskIntoConstraints = false
        mapPrompt.textColor = .purple
        mapPrompt.font = UIFont(name: "Avenir Next Demi Bold", size: 20)
        self.view.addSubview(mapPrompt)
        
        let cam = GMSCameraPosition.camera(withTarget: userLoc, zoom: 16)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.camera = cam
        mapView.isMyLocationEnabled = true
        mapView.setMinZoom(5, maxZoom: 30)
        do {
            mapView.mapStyle = try GMSMapStyle(jsonString: mapStyle)
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        mapView.layer.cornerRadius = 15
        let marker = GMSMarker(position: userLoc)
        marker.title = "Party location"
        marker.isDraggable = true
        marker.map = mapView
        self.view.addSubview(mapView)
        mapView.delegate = self
        

        photoPicker.translatesAutoresizingMaskIntoConstraints = false
        photoPicker.backgroundColor = .purple
        photoPicker.setTitle("Choose a photo 📸", for: .normal)
        photoPicker.titleLabel?.font = UIFont(name: "Avenir Next Demi Bold", size: 20)
        photoPicker.cornerRadius = 10
        view.addSubview(photoPicker)
        photoPicker.addTarget(self, action: #selector(uploadPic), for: .touchDown)
        
        
        setUpConstraints()
    }
    
    @objc func uploadPic(){
        print("in upload pic")
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                let img = pickedImage.jpeg(.low)
                self.imgData = img
                print(pickedImage.size)
                self.imagePicker.dismiss(animated: true, completion: nil)
            }
        }
    
    func setUpConstraints(){
        
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant: 10),
            logo.bottomAnchor.constraint(equalTo:logo.topAnchor, constant: 75),
            logo.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            logo.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 0),
            dateLabel.heightAnchor.constraint(equalToConstant: 30),            dateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            dateLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30)
        ])
        
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 15),
            datePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            datePicker.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            themeTf.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 15),
            themeTf.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            themeTf.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            themeTf.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            themeTf.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 15),
            themeTf.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            themeTf.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            themeTf.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            mapPrompt.topAnchor.constraint(equalTo: themeTf.bottomAnchor, constant: 15),
            mapPrompt.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            mapPrompt.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            mapPrompt.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: mapPrompt.bottomAnchor, constant: 15),
            mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            mapView.heightAnchor.constraint(equalToConstant: 175)
        ])
        NSLayoutConstraint.activate([
            photoPicker.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 15),
            photoPicker.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            photoPicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            photoPicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            photoPicker.heightAnchor.constraint(equalToConstant: 75)
        ])


    }
    
    @objc func addPartyButtonPressed() {
        let date = datePicker.date
        let dformatter = DateFormatter()
        dformatter.dateFormat = "MM-dd-yyyy HH:mm"
        let datestr = dformatter.string(from: date)
        
        if !(checkValidDate(date: date)){
            showAlert(msg: "That looks like an invalid date lmao")
            return
        }
        
        if(self.themeTf.text==""){
            showAlert(msg: "Bro you need a theme bro")
            return
        }
        
        if(self.imgData==nil){
            showAlert(msg: "That image looks sus. Please select an image.")
            return
        }
        struct PartyParams:Encodable{
            var host:String
            var location: String
            var photoURL:String
            var dateTime:String
            var theme:String
            
        }
        
        let hud = JGProgressHUD.init()
        hud.show(in: self.view)
        var downloadURL = ""
        //upload image to firebase
        let storage = Storage.storage()
        let storageRef = storage.reference().child("party-imgs").child(NSUUID().uuidString)
        _ = storageRef.putData(self.imgData, metadata: nil) { (metadata, error) in
            if(error != nil){
                showAlert(msg: error!.localizedDescription)
                self.resetFields()
                hud.dismiss()
            }else{
                storageRef.downloadURL { (url, error) in
                    if(error != nil){
                        showAlert(msg: error!.localizedDescription)
                        hud.dismiss()
                        self.resetFields()
                    }else if(url != nil){
                        print("URL fetched with success.\n")
                        downloadURL = url!.absoluteString
                        let locString = String(self.userLoc.latitude) + ", " + String(self.userLoc.longitude)
                        let newParty = PartyParams(host: globalUser.name, location: locString, photoURL: downloadURL, dateTime: datestr, theme: self.themeTf.text!)
                        let endpoint = "http://10.48.56.164:5000/api/parties/host/"
                        AF.request(endpoint, method: .post, parameters: newParty,encoder: JSONParameterEncoder.default).validate().responseData() { response in
                                let statusCode = response.response?.statusCode
                            if(statusCode==201){
                                hud.dismiss()
                                showSuccess(msg: "Your party's live!")
                            }
                            else{
                                hud.dismiss()
                                self.resetFields()
                                showAlert(msg: "You may be facing connectivity issues.")
                            }
                        }
                    }
                }
            }
        }
    }
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        self.userLoc = marker.position
        print("Marker moved to \(userLoc as Any)")
    }
    
    func checkValidDate(date:Date)->Bool{
        return (Date()<date)
    }
    func resetFields()
    {
        self.themeTf.text = ""
        self.imgData = nil
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        let vc = mapViewController()
        vc.getAllParties()
    }
}
