//
//  DriverHistory.swift
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

class DriverHistory: UIViewController {
    
    
    var titlesArray = [String] ()

    
    @IBOutlet weak var totalEarnings: UILabel!
    
    @IBOutlet weak var spentTime: UILabel!
    
    @IBOutlet weak var tripState: UILabel!
    @IBOutlet weak var tripCost: UILabel!
    @IBOutlet weak var passengerName: UILabel!
    @IBOutlet weak var completedTrips: UILabel!
    @IBOutlet weak var passengerDestLoc: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tripCost.text = "hi"
        getDriverHistory()
        
    }

    
    func getDriverHistory() -> Void{

    let userID = Auth.auth().currentUser!.uid
            let ref = Database.database().reference()
            ref.child(Constants.driverTrip).child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
    
                for child in snapshot.children {
                    let snap = child as! DataSnapshot
                    let key = snap.key
                    //let value = snap.value
                    //print("key = \(key)  value = \(value!)")
                    self.titlesArray.append(key)
                    //print(self.titlesArray)
    
                }
                var totalEarnings: Double = 0
                for trips in self.titlesArray {
                    let trip_id = trips
                    ref.child(Constants.TRIP).child(trip_id).observeSingleEvent(of: .value, with: { (snapshot) in
                        let value = snapshot.value as? NSDictionary
                        let passengerID = value?[Constants.pUid] as? String ?? "Not Found"
                        let tripcost = value?[Constants.tripCost] as? Double ?? 0
                        print(trip_id)
                        print(tripcost)
                        self.tripCost.text = String(tripcost)
                        totalEarnings += tripcost
                        self.totalEarnings.text = String(totalEarnings)
                        let tripstatus = value?[Constants.tripState] as? String ?? "Not Found"
                        var completedTrips = 0
                        if tripstatus == "Completed"{
                            completedTrips += 1
                            self.tripState.text = "Success"
                        }
                        else if tripstatus == "Canceled" {
                            self.tripState.text = "Canceled"
                        }
                        self.completedTrips.text = String(completedTrips)
                        ref.child(Constants.TRIP).child(trip_id).child(Constants.directionDetails).observeSingleEvent(of: .value, with: { (snapshot) in
                            let value4 = snapshot.value as? NSDictionary
                            let mydestlocname = value4?[Constants.destAddress] as? String ?? "Not Found"
                            self.passengerDestLoc.text = mydestlocname
                            print (mydestlocname)
                        })
                        ref.child(Constants.RIDERS).child(passengerID).observeSingleEvent(of: .value, with: { (snapshot) in
                            let value2 = snapshot.value as? NSDictionary
                            let riderFName = value2?[Constants.pFirstName] as? String ?? "Not Found"
                            let riderLName = value2?[Constants.pLastName] as? String ?? "Not Found"
                            let riderName = riderFName + " " + riderLName
                            self.passengerName.text = riderName
                            print (riderName)
                        })
                        ref.child(Constants.DRIVERS).child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
                            let value3 = snapshot.value as? NSDictionary
                            let spentTime = value3?[Constants.spentTime] as? Int ?? 0
                            let spentTimeInMins = round(Double(spentTime/60))
                            self.spentTime.text = "\(spentTimeInMins) Mins"
                        })
                    })
                }
                
                
            })
    // self.performSegue(withIdentifier: "driverEarnings", sender: self)
}
}
