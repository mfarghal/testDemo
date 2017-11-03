//
//  SignUP.swift
//  Scooter
//
//  Created by Nour El Zafarany on 10/5/17.
//  Copyright © 2017 Nour El Zafarany. All rights reserved.
//

import UIKit

class SignUPVC: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate,InformingDelegate {
    
    private let RIDER_SEGUE = "RiderVC"
    private let Driver_SEGUE = "DriverVC"
    
    @IBOutlet weak var FirstName: UITextField!
    @IBOutlet weak var LastName: UITextField!
    @IBOutlet weak var EmailText: UITextField!
    @IBOutlet weak var MobileNumber: UITextField!
    @IBOutlet weak var EmailPassword: UITextField!
    @IBOutlet weak var Choose: UIPickerView!

    @IBOutlet weak var SubmitSignup: UIButton!
    
    
    var valueSelected = ""
    let usertype = [" ","Passenger","Driver"]
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return usertype[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return usertype.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //valueSelected = usertype[row] as String
        if self.Choose.selectedRow(inComponent: 0) == 1{
            valueSelected = "Passenger"
        }
        else if self.Choose.selectedRow(inComponent: 0) == 2{
            valueSelected = "Driver"
        }
        else  if self.Choose.selectedRow(inComponent: 0) == 0{
            valueSelected = ""
        }
    }
    
    func valueChanged() -> String {
        return valueSelected
    }

//    var secondVC : AuthProvider = AuthProvider()
//    secondVC.delegate = self
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signUp(_ sender: Any) {
        
    if EmailText.text != "" && EmailPassword.text != "" && FirstName.text != "" && LastName.text != "" && MobileNumber.text != "" && valueSelected=="Passenger"
        {
            AuthProvider.Instance.signUp(withEmail: EmailText.text! ,password: EmailPassword.text!, firstname : FirstName.text!, lastname: LastName.text! , mobilenumber: MobileNumber.text!  , loginHandler: { (message) in
            
            if message != nil {
                self.alertTheUser(title: "Problem With Creating A New Passenger", message: message!)
            } else{
                self.performSegue(withIdentifier: self.RIDER_SEGUE, sender: nil)
                print("Created User Completed")
            }
            
        })
    }
        else if EmailText.text != "" && EmailPassword.text != "" && FirstName.text != "" && LastName.text != "" && MobileNumber.text != "" && valueSelected=="Driver" {
            
        AuthProvider.Instance.signUpDriver(withEmail: EmailText.text!, password: EmailPassword.text!, firstname: FirstName.text!, lastname: LastName.text!, mobilenumber: MobileNumber.text!, imageUrl: "", expiryDate: "", issuedDate: "", licenseNumber: "", validVeichleType: "", loginHandler: { (message) in
            
                if message != nil {
                    self.alertTheUser(title: "Problem With Creating A New Driver", message: message!)
                } else{
                    self.performSegue(withIdentifier: self.Driver_SEGUE, sender: nil)
                    print("Created User Completed")
                }
                
            })}
    else{
        if valueSelected == "" {
            self.alertTheUser(title: "Problem With Creating A New Passenger", message: "Please Choose A Type")
        }
        else{
        alertTheUser(title: "Email And Password Are Required", message: "Please enter email and password")
        }
    }
    
}

    
    private func alertTheUser(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert,animated: true, completion: nil)
    }
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
