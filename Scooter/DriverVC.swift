//
//  DriverVC.swift
//  Scooter
//
//  Created by Sherif on 10/13/17.
//  Copyright © 2017 Nour El Zafarany. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import FirebaseAuth
import FirebaseDatabase

class DriverVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, driverScooterController {
    
    @IBOutlet weak var myMap: MKMapView!
    
    private var locationManager = CLLocationManager()
    private var userLocation: CLLocationCoordinate2D?
    private var riderLocation: CLLocationCoordinate2D?
    var destLocation2D : CLLocationCoordinate2D?
    
    var driverLatLon : CLLocation?
    var riderLatLon : CLLocation?
    var destLatLon : CLLocation?
    
    @IBOutlet weak var mySwitch: UISwitch!
    var destLatitude : CLLocationDegrees?
    var destLongitude : CLLocationDegrees?
    var driverLatitude : CLLocationDegrees?
    var driverLongitude : CLLocationDegrees?
    var pickupLatitude : CLLocationDegrees?
    var pickupLongitude : CLLocationDegrees?
    
    var riderDestLocation : String?
    var destLocName : String?
    var pickupLocName : String?
    var startTime : String?
    var endTime : String?
    var globalPuid : String?
    var pUid : String?
    var reqID : String?
    
    var totalDistance : CLLocationDistance?
    var metersDriven : CLLocationDistance?
    
    var startDate : Double?
    var endDate : NSDate?
    var titlesArray = [String] ()
    
    private var acceptedUber = false
    private var driverCanceledUber = false
    
    
    @IBOutlet weak var switchLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeLocationManager()
 
        self.mySwitch.tintColor = UIColor .red
        self.mySwitch.onTintColor = UIColor .green
        //self.mySwitch.backgroundColor = UIColor .red
        
        if self.mySwitch.isOn == true {
            switchLabel.text = "Online"
        }
        else {
            switchLabel.text = "Offline"
        }
        
        driverScooterHandler.Instance.delegate = self
        driverScooterHandler.Instance.observeMessageForDriver()
        
        
    }
    
    @IBAction func getDriverRating(_ sender:Any){
//        let ratingsInstance = Ratings()
//        ratingsInstance.getDriverRating()
        self.performSegue(withIdentifier: "driverRatings", sender: self)
    }
    
    @IBAction func getDriverHistory(_ sender: Any){
        //let historyInstance = DriverHistory()
        //historyInstance.getDriverHistory()
        self.performSegue(withIdentifier: "driverHistory", sender: self)
    }
    
    @IBAction func backFromHistory(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var totalEarnings: UILabel!
    @IBOutlet weak var spentTime: UILabel!
    @IBOutlet weak var completedTrips: UILabel!
    @IBOutlet weak var passengerName: UILabel!
    @IBOutlet weak var passengerDestLoc: UILabel!
    @IBOutlet weak var tripCost: UILabel!
    @IBOutlet weak var tripState: UILabel!
    
    //@IBAction func getDriverHistory(_ sender: Any) {
//        let userID = Auth.auth().currentUser!.uid
//        let ref = Database.database().reference()
//        ref.child(Constants.driverTrip).child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            for child in snapshot.children {
//                let snap = child as! DataSnapshot
//                let key = snap.key
//                //let value = snap.value
//                //print("key = \(key)  value = \(value!)")
//                self.titlesArray.append(key)
//                //print(self.titlesArray)
//                
//            }
//            var totalEarnings: Double = 0
//            for trips in self.titlesArray {
//                let trip_id = trips
//                ref.child(Constants.TRIP).child(trip_id).observeSingleEvent(of: .value, with: { (snapshot) in
//                    let value = snapshot.value as? NSDictionary
//                    let passengerID = value?[Constants.pUid] as? String ?? "Not Found"
//                    let tripcost = value?[Constants.tripCost] as? Double ?? 0
//                    self.tripCost.text = String(tripcost)
//                    totalEarnings += tripcost
//                    self.totalEarnings.text = String(totalEarnings)
//                    let tripstatus = value?[Constants.tripState] as? String ?? "Not Found"
//                    var completedTrips = 0
//                    if tripstatus == "Completed"{
//                        completedTrips += 1
//                        self.tripState.text = "Success"
//                    }
//                    else if tripstatus == "Canceled" {
//                        self.tripState.text = "Canceled"
//                    }
//                    self.completedTrips.text = String(completedTrips)
//                    ref.child(Constants.TRIP).child(trip_id).child(Constants.directionDetails).observeSingleEvent(of: .value, with: { (snapshot) in
//                        let value4 = snapshot.value as? NSDictionary
//                        let mydestlocname = value4?[Constants.destAddress] as? String ?? "Not Found"
//                        self.passengerDestLoc.text = mydestlocname
//                    })
//                    ref.child(Constants.RIDERS).child(passengerID).observeSingleEvent(of: .value, with: { (snapshot) in
//                        let value2 = snapshot.value as? NSDictionary
//                        let riderFName = value2?[Constants.pFirstName] as? String ?? "Not Found"
//                        let riderLName = value2?[Constants.pLastName] as? String ?? "Not Found"
//                        let riderName = riderFName + " " + riderLName
//                        self.passengerName.text = riderName
//                        print (riderName)
//                    })
//                    ref.child(Constants.DRIVERS).child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
//                        let value3 = snapshot.value as? NSDictionary
//                        let spentTime = value3?[Constants.spentTime] as? Int ?? 0
//                        let spentTimeInMins = round(Double(spentTime/60))
//                        self.spentTime.text = "\(spentTimeInMins) Mins"
//                    })
//                })
//            }
//            
//            
//        })
       // self.performSegue(withIdentifier: "driverEarnings", sender: self)
  // }
    
//    
//    @IBOutlet weak var starRating: CosmosView!
//    @IBAction func getRating(_ sender: Any){
//        let userID = Auth.auth().currentUser!.uid
//        let ref = Database.database().reference()
//        ref.child(Constants.driverTrip).child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
//            
//            for child in snapshot.children {
//                let snap = child as! DataSnapshot
//                let key = snap.key
//                //let value = snap.value
//                //print("key = \(key)  value = \(value!)")
//                self.titlesArray.append(key)
//                //print(self.titlesArray)
//                
//            }
//            var ratingcounter = 0
//            var totalTripRate : Double = 0
//            for trips in self.titlesArray {
//                let trip_id = trips
//                ref.child(Constants.TRIP).child(trip_id).observeSingleEvent(of: .value, with: { (snapshot) in
//                    let value = snapshot.value as? NSDictionary
//                    let tripstatus = value?[Constants.tripState] as? String ?? "Not Found"
//                    let triprated = value?[Constants.tripRated] as? Bool ?? false
//                    if tripstatus == "Completed" && triprated == true {
//                        ratingcounter += 1
//                        let triprate = value?[Constants.tripRate] as? Double ?? 0
//                        totalTripRate += triprate
//                    }
//                })
//            }
//            self.starRating.settings.updateOnTouch = false
//            let avgRating:Double = totalTripRate/Double(ratingcounter)
//            self.starRating.rating = avgRating
//            self.starRating.text = String(avgRating)
//        })
 //self.performSegue(withIdentifier: "driverRatings", sender: self)
 //   }
    
    private func initializeLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //If we have de coordinate from the manager
        if let location = locationManager.location?.coordinate{
            userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)

//            let globalInstance = Global()
//            globalPuid = globalInstance.getDUID()
//            
//            print(globalPuid ?? "Not Read")
            let centre = userLocation!
            
            let getLat: CLLocationDegrees = centre.latitude
            let getLon: CLLocationDegrees = centre.longitude
            
            driverLatLon = CLLocation(latitude: getLat, longitude: getLon)
            
            let region = MKCoordinateRegion(center: userLocation!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            myMap.setRegion(region, animated: true)
            
            myMap.removeAnnotations(myMap.annotations)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = userLocation!
            annotation.title = "Driver Location"
            myMap.addAnnotation(annotation)
            
        }
    }
    
    func acceptUber(lat: Double, long: Double , userLocName: String , destLocName : String , destLat : Double , destLon : Double ,userid : String ,requestID : String) {
        riderLatLon = CLLocation(latitude: lat, longitude: long)
        destLatLon = CLLocation(latitude : destLat , longitude : destLon)
        
        pUid = userid
        reqID = requestID
        
        destLatitude = destLat
        destLongitude = destLon
        
        pickupLocName = userLocName
        
        pickupLatitude = lat
        pickupLongitude = long
        
        destLocation2D = CLLocationCoordinate2D (latitude: destLatitude!, longitude: destLongitude!)
        
        let riderLocation:CLLocation = riderLatLon!
        let driverLocation:CLLocation = driverLatLon!
        let destLocation:CLLocation = destLatLon!
        let meters:CLLocationDistance = driverLocation.distance(from: riderLocation)
        
        totalDistance = riderLocation.distance(from: destLocation)
        
        if !acceptedUber && meters > 0 && meters <= 2000 {
            uberRequest(title: "Ride Request", message: "You have a request for a ride at \(userLocName) \(meters/1000) KM away", requestAlive: true)
        }
        else if !acceptedUber && meters > 2000 && meters <= 5000 {
            uberRequest(title: "Ride Request", message: "You have a request for a ride at \(userLocName) \(meters/1000) KM away", requestAlive: true)
        }
        else if !acceptedUber && meters > 5000 && meters <= 7000 {
            uberRequest(title: "Ride Request", message: "You have a request for a ride at \(userLocName) \(meters/1000) KM away", requestAlive: true)
        }
        else if !acceptedUber && meters > 7000 && meters <= 10000 {
            uberRequest(title: "Ride Request", message: "You have a request for a ride at \(userLocName) \(meters/1000) KM away", requestAlive: true)
        }
        
        if acceptedUber {
            let userID = Auth.auth().currentUser!.uid
            let dlat : Double = driverLatitude!
            let dlon : Double = driverLongitude!
            let rID : String = reqID!
            let data: Dictionary<String, Any> = [Constants.LATITUDE : dlat , Constants.LONGITUDE : dlon , Constants.dUid : userID ,Constants.randomRequestID : rID]
            
            DBProvider.Instance.requestAcceptedRef.child(rID).setValue(data)
            DBProvider.Instance.requestRef.child(rID).removeValue()

        }
        
        if acceptedUber && meters <= 10{
            
            

            self.performSegue(withIdentifier: "startTrip", sender: self)
        }

    }
    
    @IBAction func logOut(_ sender: UIButton) {
        if AuthProvider.Instance.logOut() {
            //dismiss(animated: true, completion: nil) //Remove VC
            self.performSegue(withIdentifier: "logoutToMainScreen", sender: self)
        }else{
            uberRequest(title: "Could Not Logout", message: "We Could Not Logout At The Moment, Please Try Again Later", requestAlive: false)
        }
    }
    


    
    @IBAction func cancelUber(_ sender: Any) {
    }
    
    @IBOutlet weak var startTripBTN: UIButton!
    @IBAction func startTrip(_ sender: UIButton) {
        let sticks = String(Date().ticks)
        startTime = sticks
        let startoDato = NSDate().timeIntervalSinceNow
        startDate = startoDato
        startTripBTN.isHidden = true
        let driverID = Auth.auth().currentUser!.uid
        
        DBProvider.Instance.setStartTrip(cashColl : false , dArrDuration : "0" , dID : driverID , endtime : "0" , pID : pUid! , starttime : startTime! , tripcost : 0 , triprate : 0 , triprated : false ,tripreview : "" , tripstate : "Started" , destAdd : destLocName! , destLat : destLatitude! , destLon : destLongitude! , pickupAdd : pickupLocName! , pickupLat : pickupLatitude! , pickupLon : pickupLongitude! , tDuration : "0 mins" , tDistance : "\(totalDistance!) KM")
        
        if let location = locationManager.location?.coordinate{
            userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            let centre = userLocation!
            
            let getLat: CLLocationDegrees = centre.latitude
            let getLon: CLLocationDegrees = centre.longitude
            
            driverLatLon = CLLocation(latitude: getLat, longitude: getLon)
            let driverLocation:CLLocation = driverLatLon!
            let destLocation:CLLocation = destLatLon!
            let meters:CLLocationDistance = driverLocation.distance(from: destLocation)
            print (meters)
            
            
//            if meters < 5 {
//                let completeTrip = true
//                var fare:Double = 5
//                let metersCalculated : CLLocationDistance = totalDistance! - meters
//                metersDriven = metersCalculated
//                fare = round(5 + 1.5*metersCalculated)
//                print (fare)
//
//            }
            
        }
    }
    
    @IBOutlet weak var endTripBTN: UIButton!
     @IBAction func endTrip(_ sender: UIButton) {
        let sticks = String(Date().ticks)
        endTime = sticks
        let startoDato = Date().addingTimeInterval(startDate!)
        let elapsedTime = NSDate().timeIntervalSince(startoDato)
        let duration = Int(elapsedTime)
        var fare:Double = 5
        fare = round(5 + 1.5 * metersDriven!)
        
        DBProvider.Instance.updateCompleteTrip(cashColl: true, endTime: endTime!, tripcost: Int(fare), tripstate: "Completed", tDuration: "\(duration) Mins", tDistance: "\(metersDriven!) KM")
        
        let alert = UIAlertController(title: "Trip Fare", message: "Trip Fare Is \(fare) EGP", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Collect", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert,animated: true, completion: nil)
        
    }
    
    
    func showRouteOnMap() {
        
        myMap.delegate = self
        
        let sourceLocation = userLocation
        let destinationLocation = destLocation2D
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation!, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation!, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "Pickup Point"
        //userLocName = sourcePlacemark.name
        //print ("hi this is current user location name")
        //print (userLocName)
        
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "Drop-off Point"
        destLocName = destinationPlacemark.name
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        self.myMap.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.myMap.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.myMap.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.black
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        return MKOverlayRenderer()
    }

    
    
    private func uberRequest(title: String, message: String, requestAlive: Bool){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if requestAlive {
            let accept = UIAlertAction(title: "Accept", style: .default, handler: { (alertAction: UIAlertAction) in
                
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            
            alert.addAction(accept)
            alert.addAction(cancel)
            
        }else {
            let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(ok)
        }
        
        
        present(alert,animated: true, completion: nil)
    }
    
    
    
    
} //Class


extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}
