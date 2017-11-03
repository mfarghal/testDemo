//
//  DriverAccount.swift
//  Scooter
//
//  Created by Sherif on 10/30/17.
//  Copyright © 2017 Nour El Zafarany. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class DriverAccount: UIViewController {
    
 
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var driverName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDriverNameAndPic()
    }
    
    
    func getDriverNameAndPic(){
        
        let userID = Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        
        ref.child(Constants.DRIVERS).child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                                    let value = snapshot.value as? NSDictionary
                                    let dFName = value?[Constants.dFirstName] as? String ?? ""
                                    let dLName = value?[Constants.dLastName] as? String ?? ""
                                    let imageURL = value?[Constants.dImageUrl] as? String ?? ""
                                    self.driverName.text = "\(dFName) \(dLName)"
                                    
            
                                    print("textcontent is \(imageURL)")
            //var image: UIImage = UIImage(named: "11m.png")!
            self.imageView.image = UIImage(named : "11m.png")
            self.imageView.layer.borderWidth = 1.0
            self.imageView.layer.masksToBounds = false
            self.imageView.layer.borderColor = UIColor.white.cgColor
            self.imageView.layer.cornerRadius = self.imageView.frame.size.width/2
            self.imageView.clipsToBounds = true

            


            })
        
    }
    
    
    @IBAction func logOut(_ sender: UIButton) {
        if AuthProvider.Instance.logOut() {
            //dismiss(animated: true, completion: nil) //Remove VC
            self.performSegue(withIdentifier: "logoutToMainScreen", sender: self)
        }else{
            uberRequest(title: "Could Not Logout", message: "We Could Not Logout At The Moment, Please Try Again Later", requestAlive: false)
        }
    }
    
    
    private func uberRequest(title: String, message: String, requestAlive: Bool){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if requestAlive {
            let accept = UIAlertAction(title: "Accept", style: .default, handler: { (alertAction: UIAlertAction) in
                
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            
            alert.addAction(accept)
            alert.addAction(cancel)
            
        }else {
            let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(ok)
        }
        
        
        present(alert,animated: true, completion: nil)
    }


}
