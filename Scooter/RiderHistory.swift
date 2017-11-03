//
//  RiderHistory.swift
//  Scooter
//
//  Created by Sherif on 10/30/17.
//  Copyright © 2017 Nour El Zafarany. All rights reserved.
//

import UIKit
import MapKit
import Foundation
import FirebaseAuth
import FirebaseDatabase


class RiderHistory : UIViewController {
    
    var titlesArray = [String] ()
    @IBOutlet weak var tripCost: UILabel!
    @IBOutlet weak var tripState: UILabel!
    @IBOutlet weak var historyMap: MKMapView!
    @IBOutlet weak var myDestLocation: UILabel!
    @IBOutlet weak var driverFullName: UILabel!
    @IBOutlet weak var driverRide: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getRiderHistory()
    }
    
    
    func getRiderHistory(){
        let userID = Auth.auth().currentUser!.uid
        let ref = Database.database().reference()
        ref.child(Constants.passengerTrip).child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let key = snap.key
                //let value = snap.value
                //print("key = \(key)  value = \(value!)")
                self.titlesArray.append(key)
                //print(self.titlesArray)
                
            }
            for trips in self.titlesArray {
                let trip_id = trips
                //print (trip_id)
                ref.child(Constants.TRIP).child(trip_id).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    let driverID = value?[Constants.dUid] as? String ?? "Not Found"
                    let tripcost = value?[Constants.tripCost] as? Double ?? 0
                    self.tripCost.text = String(tripcost)
                    let tripstatus = value?[Constants.tripState] as? String ?? "Not Found"
                    if tripstatus == "Completed" {
                        self.tripState.text = "Success"
                    }
                    else if tripstatus == "Canceled" {
                        self.tripState.text = "Canceled"
                    }
                    ref.child(Constants.TRIP).child(trip_id).child(Constants.directionDetails).observeSingleEvent(of: .value, with: { (snapshot) in
                        let value4 = snapshot.value as? NSDictionary
                        let mydestlocname = value4?[Constants.destAddress] as? String ?? "Not Found"
                        self.myDestLocation.text = mydestlocname
                        //print(mydestlocname)
                    })
                    ref.child(Constants.TRIP).child(trip_id).child(Constants.directionDetails).child(Constants.destLocation).observeSingleEvent(of: .value, with: { (snapshot) in
                        let value5 = snapshot.value as? NSDictionary
                        self.historyMap.delegate = self as? MKMapViewDelegate
                        let mydestloclat = value5?[Constants.LATITUDE] as? Double ?? 0
                        let mydestloclon = value5?[Constants.LONGITUDE] as? Double ?? 0
                        //print(mydestloclat)
                        //print(mydestloclon)
                        let loc = CLLocationCoordinate2D(latitude: mydestloclat, longitude: mydestloclon)
                        let region = MKCoordinateRegion(center: loc, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
                        
                        self.historyMap.setRegion(region, animated: false)
                        
                        self.historyMap.removeAnnotations(self.historyMap.annotations)
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = loc
                        self.historyMap.addAnnotation(annotation)
                        //self.historyMap.showsUserLocation = true
                    })
                    ref.child(Constants.DRIVERS).child(driverID).observeSingleEvent(of: .value, with: { (snapshot) in
                        let value2 = snapshot.value as? NSDictionary
                        let driverFName = value2?[Constants.dFirstName] as? String ?? "Not Found"
                        let driverLName = value2?[Constants.dLastName] as? String ?? "Not Found"
                        let driverName = driverFName + " " + driverLName
                        self.driverFullName.text = driverName
                        
                        //print(driverFName)
                        ref.child(Constants.DRIVERS).child(driverID).child(Constants.scooterModel).observeSingleEvent(of: .value, with: { (snapshot) in
                            let value3 = snapshot.value as? NSDictionary
                            let driverScooter = value3?[Constants.sBrandName] as? String ?? "Not Found"
                            self.driverRide.text = driverScooter
                        })
                    })
                }
                    
                )}
        })
        
        

    }
    
}
