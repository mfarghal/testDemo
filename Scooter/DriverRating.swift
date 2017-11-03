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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDriverRating()
    }
    
    @IBOutlet weak var Rating: CosmosView!
    
    @IBOutlet weak var StarRating: CosmosView!
    
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
                print(trip_id)
                
                ref.child(Constants.TRIP).child(trip_id).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let tripstatus = value?[Constants.tripState] as? String ?? "Not Found"
                    print(tripstatus)
                    let triprated = value?[Constants.tripRated] as? Bool ?? false
                    print(triprated)
                    if tripstatus == "Completed" && triprated == true {
                        ratingcounter += 1
                        let triprate = value?[Constants.tripRate] as? Double ?? 0
                        print(triprate)
                        totalTripRate += triprate
                        print(totalTripRate)
                    }
                    let avgRating:Double = totalTripRate/Double(ratingcounter)
                    print(totalTripRate)
                    print(ratingcounter)
                    print(avgRating)
                    if (ratingcounter != 0) {
                        //let ratings = CosmosView()
                        print(ratingcounter)
                        self.Rating!.settings.updateOnTouch = false
                        self.Rating!.rating = avgRating
                        self.Rating!.text = String(avgRating)
                        //ratings.rating = 1.0
                        //self.starRating.rating = avgRating
                        //self.starRating.text = String(avgRating)
                        print(avgRating)
                    }
                    else{
                        print(ratingcounter)
                        self.Rating!.settings.updateOnTouch = false
                        self.Rating!.rating = 0
                        self.Rating!.text = "0"
                        //ratings.rating = 1.0
                        //self.starRating.rating = avgRating
                        //self.starRating.text = String(avgRating)
                        print(avgRating)                //self.StarRating.rating = ratings.rating
                    }

                    
                })
                    
                }
            
            //self.starRating.settings.updateOnTouch = false
          
            
        })
        // self.performSegue(withIdentifier: "driverRatings", sender: self)
    }
}
