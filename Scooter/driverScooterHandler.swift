//
//  driverScooterHandler.swift
//  Scooter
//
//  Created by Sherif on 10/13/17.
//  Copyright © 2017 Nour El Zafarany. All rights reserved.
//

import Foundation
import Foundation
import FirebaseDatabase

protocol driverScooterController: class {
    func acceptUber(lat: Double, long: Double , userLocName : String , destLocName : String , destLat : Double , destLon : Double , userid : String , requestID : String);
}

class driverScooterHandler {
    private static let _instance = driverScooterHandler()
    
    //Weak se utiliza para indicar que esta variable no sera instanciada mientras no la necesitemos
    weak var delegate: driverScooterController?
    
    var rider = ""
    var driver = ""
    var driver_id = ""
    
    
    static var Instance: driverScooterHandler {
        return _instance
    }
    
    func observeMessageForDriver(){
        //  RIDER REQUESTED AN UBER
        DBProvider.Instance.requestRef.observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                if let latitude = data[Constants.LATITUDE] as? Double {
                    if let longitude = data[Constants.LONGITUDE] as? Double {
                        //Inform the driver VC the Request
                        if let userLocName = data[Constants.currentUserLocationName] as? String {
                            if let destLocName = data[Constants.currentDestLocationName] as? String {
                                if let destLatitude = data[Constants.destLatitude] as? Double {
                                    if let destLongitude = data[Constants.destLongitude] as? Double {
                                        if let userID = data[Constants.pUid] as? String {
                                            if let requestid = data[Constants.randomRequestID] as? String {
                                                                                            self.delegate?.acceptUber(lat: latitude, long: longitude , userLocName: userLocName , destLocName: destLocName , destLat: destLatitude , destLon: destLongitude, userid: userID, requestID: requestid)
                                            }
                                        }
                                        
                                    }
                                }
   
                            }
                        }
                    }
                }
            }
            
        }
        
        //observeMessageForDriver
    }
    
    
    
}

