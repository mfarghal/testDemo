//
//  ScooterHandler.swift
//  Scooter
//
//  Created by Nour El Zafarany on 10/1/17.
//  Copyright © 2017 Nour El Zafarany. All rights reserved.
//
import Foundation
import FirebaseAuth
import FirebaseDatabase

protocol UberController: class {
    func canCallUber(delegateCalled: Bool)
}

protocol GetDriverID: class {
    func getDriverID(driverID : String)
}


class UberHandler {
    private static let _instance = UberHandler()
    
    weak var delegate: UberController?
    weak var driverDelegate : GetDriverID?
    
    
    var rider = ""
    var driver = ""
    var rider_id = ""
    var request_id = ""
    var driverID = ""
    
    
    static var Instance: UberHandler {
        return _instance
    }
 
    
    func observeMessagesForRider(){
        //RIDER REQUESTED UBER
        DBProvider.Instance.requestRef.observe(DataEventType.childAdded) { (snapshot: DataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.NAME] as? String {
                    if name == self.rider{
                        self.rider_id = snapshot.key
                        self.delegate?.canCallUber(delegateCalled: true)
                        print("The Value Is \(self.rider_id)")
                    }
                }
            }
        }
        
        //RIDER CANCELED UBER
        DBProvider.Instance.requestRef.observe(DataEventType.childRemoved ) { (snapshot: DataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.NAME] as? String {
                    if name == self.rider{
                        self.delegate?.canCallUber(delegateCalled: false)
                    }
                }
            }
        }
        
        DBProvider.Instance.requestAcceptedRef.observe(DataEventType.childAdded) {(snapshot: DataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary{
                if let reqID = data[Constants.randomRequestID] as? String {
                    if reqID == self.request_id {
                        self.driverID = snapshot.key
                        self.driverDelegate?.getDriverID(driverID: self.driverID)
                    }
                }
            }
        }
        
    }//observeMessagesForRider
    
    func requestUber(latitude: Double, longitude: Double , userLocationName : String , destLocationName : String , destLatitude : Double , destLongitude : Double){
        
        let userID = Auth.auth().currentUser!.uid
        let data: Dictionary<String, Any> = [Constants.NAME: rider, Constants.LATITUDE: latitude, Constants.LONGITUDE: longitude ,Constants.currentUserLocationName : userLocationName , Constants.currentDestLocationName : destLocationName , Constants.destLatitude : destLatitude , Constants.destLongitude : destLongitude , Constants.pUid : userID]
        
        DBProvider.Instance.requestRef.childByAutoId().setValue(data)
        
        request_id = DBProvider.Instance.requestRef.key
        
        let data2 : Dictionary<String, Any> = [Constants.randomRequestID : request_id]
        
        DBProvider.Instance.requestRef.child(request_id).setValue(data2)
        
        
    }// Request Uber
    
    func cancelUber(){
        DBProvider.Instance.requestRef.child(rider_id).removeValue()
    }// Cancel Uber
    
    
}// Class
