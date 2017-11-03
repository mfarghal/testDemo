////
////  RideData.swift
////  Scooter
////
////  Created by Sherif on 10/11/17.
////  Copyright © 2017 Nour El Zafarany. All rights reserved.
////
//
//import Foundation
//import MapKit
//
//// Model to hold the coordinates and the associated address
//class RideData {
//    fileprivate var coordinates : CLLocationCoordinate2D!
//    fileprivate var address : String = " "
//    fileprivate var currentRideStatus: RideStatus = RideStatus.NEW
//    fileprivate var objectId : String!
//    fileprivate var riderUserId : String?
//    fileprivate var riderName : String?
//    fileprivate var riderImage : UIImage?
//    fileprivate var destinationAddress : String?
//    fileprivate var destinationCoordinates : CLLocationCoordinate2D?
//    
//    func getCoordinates() -> CLLocationCoordinate2D {
//        return coordinates
//    }
//    
//    func setCoordinates(_ inputCoordinates:CLLocationCoordinate2D) -> Void {
//        self.coordinates = inputCoordinates
//    }
//    
//    func getAddress() -> String {
//        return address
//    }
//    
//    func setAddress(_ inputAddress:String) -> Void {
//        self.address = inputAddress
//    }
//    
//    func getCurrentRideStatus() -> RideStatus {
//        return self.currentRideStatus
//    }
//    
//    func setCurrentRideStatus(_ rideStatus:RideStatus) -> Void {
//        self.currentRideStatus = rideStatus
//    }
//    
//    func getObjectId() -> String {
//        return self.objectId
//    }
//    
//    func setObjectId(_ savedObjectId:String) -> Void {
//        self.objectId = savedObjectId
//    }
//    
//    func getRiderUserId() -> String? {
//        return self.riderUserId
//    }
//    
//    func setRiderUserId(_ userId:String) -> Void {
//        self.riderUserId = userId
//    }
//    
//    func getRiderName() -> String? {
//        return self.riderName
//    }
//    
//    func setRiderName(_ userName:String) -> Void {
//        self.riderName = userName
//    }
//    
//    func getRiderImage() -> UIImage? {
//        return self.riderImage
//    }
//    
//    func setRiderImage(_ savedRiderImage:UIImage) -> Void {
//        self.riderImage = savedRiderImage
//    }
//    
//    func getDestinationCoordinates() -> CLLocationCoordinate2D? {
//        return destinationCoordinates
//    }
//    
//    func setDestinationCoordinates(_ inputCoordinates:CLLocationCoordinate2D) -> Void {
//        self.destinationCoordinates = inputCoordinates
//    }
//    
//    func getDestinationAddress() -> String? {
//        return destinationAddress
//    }
//    
//    func setDestinationAddress(_ inputAddress:String) -> Void {
//        self.destinationAddress = inputAddress
//    }
//}
//
//enum RideStatus : String {
//    case NEW = "New"
//    case REQUESTED = "Requested"
//    case ACCEPTED = "Accepted"
//    case CANCELLED = "Cancelled"
//    case COMPLETED = "Completed"
//    case STARTED = "Started"
//}
