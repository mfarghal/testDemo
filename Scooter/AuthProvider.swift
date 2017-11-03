//
//  AuthProvider.swift
//  Scooter
//
//  Created by Nour El Zafarany on 9/30/17.
//  Copyright © 2017 Nour El Zafarany. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

typealias LoginHandler = (_ msg: String?) -> Void

struct LoginErrorCode {
    static let INVALID_EMAIL = "Invalid Email Adress, Please Provide A Real Email Adress"
    static let WRONG_PASSWORD = "Wrong Password, Please Enter The Correct Password"
    static let PROBLEM_CONNECTING = "Problem Connecting To Database, Please Try Later"
    static let USER_NOT_FOUND = "User Not Found, Please Register"
    static let EMAIL_ALREADY_IN_USE = "Email Already In User, Please Use Another Email"
    static let WEAK_PASSWORD = "Password Should Be At Least 6 Characters Long"
}

protocol InformingDelegate {
    func valueChanged() -> String
}

class AuthProvider : SignUPVC {
    private static let _instance = AuthProvider();
    
    var delegate: InformingDelegate?
    
    var val : SignUPVC = SignUPVC()
    
    var isWhat : String?
    
    
    func callFromOtherClass() {
        //value = self.delegate?.valueChanged()
        isWhat = val.valueChanged()
    }
    
    func getRider()-> String{
        isWhat = val.valueChanged()
        return isWhat!
    }

    
    static var Instance: AuthProvider {
        return _instance
    }
    
    func login(withEmail: String, password: String, loginHandler: LoginHandler?){
        
        Auth.auth().signIn(withEmail: withEmail, password: password, completion: { (user, error) in
            
            if error != nil {
                self.handleErrors(err: error as! NSError, loginHandler: loginHandler)
            }else{
                loginHandler?(nil);
//                let userID = Auth.auth().currentUser!.uid
//                let rootRef = Database.database().reference()
//                let ridersRef = rootRef.child(byAppendingPath: "Passenger")
//                ridersRef.queryOrdered(byChild: "pUid").queryEqual(toValue: userID).observe(.value, with: { snapshot in
//                    //let isRider = true
//
//                    if (snapshot.value is NSNull) {
//                        print("Not a Passenger")
//                        self.isRider = self.setRider(false)
//                        self.isRider = false
//                        print(self.getRider())
//                    } else {
//                        print("He is a Passenger")
//                        self.isRider = self.setRider(true)
//                        self.isRider = true
//                        print(self.getRider())
//                    }   
//                })

            }
            
            
        })
    }//Login Func
    
    private var isRider : Bool = true
    
    func setRider(_ isRider:Bool) -> Bool {
        //SignUPVC.va
        self.isRider = isRider
        return isRider
    }
    
//    func getRider()-> Bool{
//        return self.isRider
//    }
    
    func logOut() -> Bool{
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                return true
            } catch {
                return false
            }
        }
        
        return true
    }//Logout Func
    
    
    func signUp(withEmail:String,password : String, firstname : String , lastname : String , mobilenumber : String, loginHandler:LoginHandler?){
        Auth.auth().createUser(withEmail: withEmail, password: password, completion: { (user, error) in
            
            //let isRiderOrDriver = self.getRider()
            
            if error != nil {
                self.handleErrors(err: error as! NSError , loginHandler: loginHandler)
            } else{
                if user?.uid != nil {
                    //Store user to database
                    DBProvider.Instance.saveUser(withID: user! .uid, email: withEmail, firstname : firstname , lastname : lastname , mobilenumber : mobilenumber,pUid : user!.uid)
                    
                    //login the user
                    self.login(withEmail: withEmail, password: password, loginHandler: loginHandler)

                }
                
            }
            
        })
    }//signUp function
    
    func signUpDriver(withEmail:String,password : String, firstname : String , lastname : String , mobilenumber : String, imageUrl : String , expiryDate : String , issuedDate : String , licenseNumber : String , validVeichleType : String, loginHandler:LoginHandler?){
        Auth.auth().createUser(withEmail: withEmail, password: password, completion: { (user, error) in
            
            //let isRiderOrDriver = self.getRider()
            
            if error != nil {
                self.handleErrors(err: error as! NSError , loginHandler: loginHandler)
            } else{
                if user?.uid != nil {
                    //Store user to database
                    DBProvider.Instance.saveDriver(withID: user! .uid, email: withEmail, imageUrl: "", firstname: firstname, lastname: lastname, mobilenumber: mobilenumber, approved: false, available: false, cash: "-1", lastOnline: "", expiryDate: expiryDate, issuedDate: issuedDate, licenseNumber: licenseNumber, validVeichleType: validVeichleType, nTrips: 0, numRate: "", online: false, rate: 0, sBrandName: "", sColor: "", sModelName: "", sYear: 2000, spentTime: 0, startDate: "")
                    
                    //login the user
                    self.login(withEmail: withEmail, password: password, loginHandler: loginHandler)
                    
                }
                
            }
            
        })
    }//signUp function
    
    private func handleErrors(err: NSError, loginHandler: LoginHandler?){
        if let errCode = AuthErrorCode(rawValue: err.code){
            switch errCode {
            case .wrongPassword:
                loginHandler?(LoginErrorCode.WRONG_PASSWORD)
                break
                
            case .invalidEmail:
                loginHandler?(LoginErrorCode.INVALID_EMAIL)
                break
                
            case .userNotFound:
                loginHandler?(LoginErrorCode.USER_NOT_FOUND)
                break
                
            case .emailAlreadyInUse:
                loginHandler?(LoginErrorCode.EMAIL_ALREADY_IN_USE)
                break
                
            case .weakPassword:
                loginHandler?(LoginErrorCode.WEAK_PASSWORD)
                break
                
            default:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING)
                print("Error Encontrado: \(errCode.rawValue.description)")
                break
            }
        }
    } //handlErrors Func
    
    
    
    
}//Class

