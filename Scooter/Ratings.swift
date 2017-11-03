//
//  Ratings.swift
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

class Ratings: UIViewController {
    var titlesArray = [String] ()

    

@IBOutlet weak var starRating: CosmosView!
func getDriverRating() -> Void{
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
                var ratingcounter = 0
                var totalTripRate : Double = 0
                for trips in self.titlesArray {
                    let trip_id = trips
                    ref.child(Constants.TRIP).child(trip_id).observeSingleEvent(of: .value, with: { (snapshot) in
                        let value = snapshot.value as? NSDictionary
                        let tripstatus = value?[Constants.tripState] as? String ?? "Not Found"
                        let triprated = value?[Constants.tripRated] as? Bool ?? false
                        if tripstatus == "Completed" && triprated == true {
                            ratingcounter += 1
                            let triprate = value?[Constants.tripRate] as? Double ?? 0
                            totalTripRate += triprate
                        }
                    })
                }
                //self.starRating.settings.updateOnTouch = false
                let avgRating:Double = totalTripRate/Double(ratingcounter)
                if (ratingcounter != 0) {
                    //self.starRating.rating = avgRating
                    //self.starRating.text = String(avgRating)
                    print(avgRating)
                }
                else{
                    self.starRating.rating = 1.0
                    //self.starRating.text = String(1)
                }

            })
   // self.performSegue(withIdentifier: "driverRatings", sender: self)
}
}
