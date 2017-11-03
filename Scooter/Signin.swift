//
//  Signin.swift
//  Scooter
//
//  Created by Nour El Zafarany on 9/29/17.
//  Copyright © 2017 Nour El Zafarany. All rights reserved.
//
import UIKit
import FirebaseAuth
import FirebaseDatabase


class SignInVC: UIViewController {
    
    private let RIDER_SEGUE = "SignUPVC"
    
    var globalPuid : String?
    
    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        // Do any additional setup after loading the view.
    }
    var walahyMaRider = true
    var aywaRider = true
    var isRider : Bool = true
    func checkMeletAboh() -> Bool {
        let userID = Auth.auth().currentUser!.uid
        //var walahyMaRider = true
        let rootRef = Database.database().reference()
        let ridersRef = rootRef.child(byAppendingPath: "Passenger")
        ridersRef.queryOrdered(byChild: "pUid").queryEqual(toValue: userID).observe(.value, with: { snapshot in
            //let isRider = true
            if (snapshot.value is NSNull) {
                print("Not a Passenger")
                //self.isRider = self.setRider(false)
                self.walahyMaRider = true
                self.aywaRider = false
                self.isRider = false
                //return self.isRider
                //print(self.isRider)
                //return false
            } else {
                print("He is a Passenger")
                //self.isRider = self.setRider(true)
                self.walahyMaRider = false
                self.aywaRider = true
                self.isRider = true
                //print(self.isRider)
            }
            //return self.isRider
        })
        //print (self.isRider)
        print (self.walahyMaRider)
        return self.walahyMaRider
    }
    //print("Not a Passenger")
    @IBAction func login(_ sender: Any) {
        
        if emailTextField.text != "" && passwordTextField.text != "" {
            AuthProvider.Instance.login(withEmail: emailTextField.text!, password: passwordTextField.text!, loginHandler: { (message) in
                if message != nil{
                    self.alertTheUser(title: "Problem With Authentication", message: message!)
                }
                else{
                    //print(AuthProvider().setRider(false))
                    //print(AuthProvider().getRider())
                    //print(self.checkMeletAboh())
                    let userID = Auth.auth().currentUser!.uid
                    print (userID)

                    
                    //var walahyMaRider = true
                    let rootRef = Database.database().reference()
                    let ridersRef = rootRef.child(byAppendingPath: "Passenger")
                    ridersRef.queryOrdered(byChild: "pUid").queryEqual(toValue: userID).observe(.value, with: { snapshot in
                        //let isRider = true
                        if (snapshot.value is NSNull) {
                            print("Not a Passenger")
                            //self.isRider = self.setRider(false)
                            self.walahyMaRider = true
                            self.aywaRider = false
                            self.isRider = false
                            if self.walahyMaRider == false{
                                let globalInstance = Global()
                                globalInstance.setPUID(pUID: userID)
                                UberHandler.Instance.rider = self.emailTextField.text!
                                self.emailTextField.text = ""
                                self.passwordTextField.text = ""
                                self.performSegue(withIdentifier: "RiderVC", sender: self)
                            }
                            else{
                                let globalInstance = Global()
                                print(userID)
                                globalInstance.setDUID(dUID: userID)
                                driverScooterHandler.Instance.driver = self.emailTextField.text!
                                self.emailTextField.text = ""
                                self.passwordTextField.text = ""
                                self.performSegue(withIdentifier: "DriverVC", sender: self)
                            }

                            //return self.isRider
                            //print(self.isRider)
                            //return false
                        } else {
                            print("He is a Passenger")
                            //self.isRider = self.setRider(true)
                            self.walahyMaRider = false
                            self.aywaRider = true
                            self.isRider = true
                            if self.walahyMaRider == false{
                                UberHandler.Instance.rider = self.emailTextField.text!
                                self.emailTextField.text = ""
                                self.passwordTextField.text = ""
                                self.performSegue(withIdentifier: "RiderVC", sender: self)
                            }
                            else{
                                driverScooterHandler.Instance.driver = self.emailTextField.text!
                                self.emailTextField.text = ""
                                self.passwordTextField.text = ""
                                self.performSegue(withIdentifier: "DriverVC", sender: self)
                            }

                            //print(self.isRider)
                        }
                        //return self.isRider
                    })

                    //self.walahyMaRider = self.checkMeletAboh()
                }
            })
        }
        else {
            
            alertTheUser(title: "Email And Password Are Required", message: "Please enter email and password")
        }
        
    }
    
    
    private func alertTheUser(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert,animated: true, completion: nil)
    }
    
    
}
