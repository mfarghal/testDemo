//
//  DBProvider.swift
//  Scooter
//
//  Created by Nour El Zafarany on 10/1/17.
//  Copyright © 2017 Nour El Zafarany. All rights reserved.
//

import Foundation
import FirebaseDatabase


class DBProvider :SignUPVC{
    
    private static let _instance = DBProvider()
    
    var val : SignUPVC = SignUPVC()
    
    var globalTripID : String?
    
    func getRider()-> String{
        isWhat = val.valueChanged()
        return isWhat!
    }

    
    var isWhat : String?

    
    static var Instance: DBProvider {
        return _instance
    }
    
    var dbRef: DatabaseReference{
        return Database.database().reference()
    }
    
    var riderRef: DatabaseReference{
        return dbRef.child(Constants.RIDERS)
    }
    
    var driverRef: DatabaseReference{
        return dbRef.child(Constants.DRIVERS)
    }
    
    // request reference
    var requestRef: DatabaseReference {
        return dbRef.child(Constants.UBER_REQUEST)
    }
    
    // request accepted
    var requestAcceptedRef: DatabaseReference{
        return dbRef.child(Constants.UBER_ACCEPTED)
    }
    
    // trip reference
    var tripRef: DatabaseReference {
        return dbRef.child(Constants.TRIP)
    }
    
    // passenger trip reference
    var passengerTripRef: DatabaseReference {
        return dbRef.child(Constants.passengerTrip)
    }
    
    
    // driver trip reference
    var driverTripRef: DatabaseReference {
        return dbRef.child(Constants.driverTrip)
    }

    
    func saveUser(withID: String, email: String, firstname : String , lastname : String , mobilenumber : String , pUid : String){
        
        
        let data: Dictionary<String,Any> = [Constants.pEMAIL: email, Constants.pFirstName : firstname , Constants.pLastName : lastname , Constants.pMobileNumber : mobilenumber , Constants.pUid : withID]
            riderRef.child(withID).setValue(data)
            print("Created Passenger Successfully")
        
    }
    
    func saveDriver(withID: String, email: String, imageUrl : String ,firstname : String , lastname : String , mobilenumber : String , approved : Bool, available : Bool , cash : String , lastOnline : String , expiryDate : String , issuedDate : String , licenseNumber : String , validVeichleType : String , nTrips : Int , numRate : String , online : Bool , rate : Int , sBrandName : String , sColor : String , sModelName : String , sYear : Int , spentTime : Int , startDate : String ){
        
        
        let data: Dictionary<String,Any> = [Constants.APPROVED : approved, Constants.AVAILABLE : available , Constants.CASH : cash , Constants.dEMAIL : email , Constants.dImageUrl : imageUrl , Constants.dLastName : lastname , Constants.dMobileNumber : mobilenumber , Constants.LASTONLINE : lastOnline , Constants.nTrips : nTrips , Constants.numRate : numRate , Constants.online : online , Constants.rate : rate , Constants.spentTime : spentTime , Constants.startDate : startDate ]
        
        let licenseModelData : Dictionary<String,Any> = [Constants.EXPIRYDATE : expiryDate , Constants.ISSUEDDATE : issuedDate , Constants.LICENSENUMBER : licenseNumber , Constants.VALIDVEICHLE : validVeichleType]
        
        let scooterModelData : Dictionary<String,Any> = [Constants.sBrandName : sBrandName , Constants.sColor : sColor , Constants.sModelName : sModelName , Constants.sYear : sYear]
        
        driverRef.child(withID).setValue(data)
        driverRef.child(withID).child(Constants.licenseModel).setValue(licenseModelData)
        driverRef.child(withID).child(Constants.scooterModel).setValue(scooterModelData)
        print("Created Driver Successfully")
        
    }
    
    func setStartTrip(cashColl : Bool , dArrDuration : String , dID : String , endtime : String , pID : String , starttime : String , tripcost : Int , triprate : Int , triprated : Bool ,tripreview : String , tripstate : String , destAdd : String , destLat : Double , destLon : Double , pickupAdd : String , pickupLat : Double , pickupLon : Double , tDuration : String , tDistance : String){
        
        let data: Dictionary<String, Any> = [Constants.cashCollected : cashColl , Constants.dArriveDuration : dArrDuration , Constants.dUid : dID , Constants.endTime : endtime , Constants.pUid : pID , Constants.startTime : starttime , Constants.tripCost : tripcost , Constants.tripRate : triprate , Constants.tripRated : triprated , Constants.tripReview : tripreview , Constants.tripState : tripstate]
        
        DBProvider.Instance.tripRef.childByAutoId().setValue(data)
        
        let directionDetails : Dictionary<String , Any> = [Constants.destAddress : destAdd , Constants.pickupAddress : pickupAdd , Constants.tDistance : tDistance , Constants.tDuration : tDuration ]
        
        let trip_id = DBProvider.Instance.tripRef.key
        
        self.globalTripID = trip_id
        
        let tripuid : Dictionary<String , Any> = [Constants.tripUid : trip_id]
        
        DBProvider.Instance.tripRef.child(trip_id).setValue(tripuid)
        
        DBProvider.Instance.tripRef.child(trip_id).child(Constants.directionDetails).setValue(directionDetails)
        
        let destLocation : Dictionary<String ,Any> = [Constants.LATITUDE : destLat , Constants.LONGITUDE : destLon]
        
        DBProvider.Instance.tripRef.child(trip_id).child(Constants.destLocation).setValue(destLocation)
        
        let pickupLocation : Dictionary<String , Any> = [Constants.LATITUDE : pickupLat , Constants.LONGITUDE : pickupLon]
        
        DBProvider.Instance.tripRef.child(trip_id).child(Constants.pickupLocation).setValue(pickupLocation)
    
        let passTripData : Dictionary<String ,Any> = [trip_id : triprated]
        
        DBProvider.Instance.passengerTripRef.child(pID).setValue(passTripData)
        
        let driverTripData : Dictionary<String ,Any> = [trip_id : triprated]
        
        DBProvider.Instance.driverTripRef.child(dID).setValue(driverTripData)
        
    }
    
    func updateCompleteTrip(cashColl : Bool ,endTime : String , tripcost : Int , tripstate : String , tDuration : String , tDistance : String){
        DBProvider.Instance.tripRef.child(self.globalTripID!).updateChildValues([Constants.cashCollected: cashColl , Constants.endTime : endTime , Constants.tripCost : tripcost , Constants.tripState : tripstate , Constants.tDuration : tDuration ,Constants.tDistance : tDistance])
        
    }
    
    func updateDriverRating(triprate : Double , triprated : Bool ,tripreview : String){
        DBProvider.Instance.tripRef.child(self.globalTripID!).updateChildValues([Constants.tripRate : triprate , Constants.tripRated : triprated ,Constants.tripReview : tripreview])
        
    }
    

    
}//Class
