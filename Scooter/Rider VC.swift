//
//  Driver VC.swift
//  Scooter
//
//  Created by Nour El Zafarany on 10/2/17.
//  Copyright © 2017 Nour El Zafarany. All rights reserved.
//
import UIKit
import MapKit
import CoreLocation
import AddressBookUI
import Contacts
import FirebaseAuth
import FirebaseDatabase


protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class RiderVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UberController , GetDriverID {
    
    //@IBOutlet weak var fareEstimate: UIButton!
    //@IBOutlet weak var confirmBooking: UIButton!
    @IBOutlet weak var myMap: MKMapView!

    @IBOutlet weak var fromEgp: UILabel!
    @IBOutlet weak var toEgp: UILabel!
    @IBOutlet weak var pickupLocationLabel: UILabel!
    @IBOutlet weak var destLocationLabel: UILabel!
    
    //@IBOutlet weak var pickupLocation: UISearchBar!
    //@IBOutlet weak var destLocation: UISearchBar!
    //@IBOutlet weak var pickupLocation: UISearchBar!
    
    @IBOutlet weak var approxTravelTime: UILabel!
    //@IBOutlet weak var fromEgp: UILabel!
    //@IBOutlet weak var toEgp: UILabel!
    @IBOutlet weak var pickupLocationInFareEstimate: UILabel!
    @IBOutlet weak var dropoffLocationInFareEstimate: UILabel!
    @IBOutlet weak var imgContainerView: UIImageView!
    @IBOutlet weak var btnsContainerView: UIImageView!
    @IBOutlet weak var smallDollarOnCash: UIImageView!
    @IBOutlet weak var dollarCash: UIImageView!
    @IBOutlet weak var smallDollarOnEstimate: UIImageView!
    @IBOutlet weak var calcEstimate: UIImageView!
    @IBOutlet weak var fareEstimate: UIButton!
    @IBOutlet weak var cashBtn: UIButton!
    @IBOutlet weak var dividingLine: UIImageView!
    //@IBOutlet weak var destLocation: UISearchBar!
//    @IBOutlet weak var PickupLocation: UITextField!
//    
//    @IBOutlet weak var DestLocation: UITextField!
    
    @IBOutlet weak var callUberBtn: UIButton!
    
    var resultSearchController:UISearchController? = nil
    
    var userLocName : String?
    var destLocName : String?
    
    var userLatLon : CLLocation?
    var destLatLon : CLLocation?
    var userLat : CLLocationDegrees?
    var userLon : CLLocationDegrees?
    
    var streetName : String?
    var estimatedTime : String?
    var estimatedFare : String?
    var driverID : String?
    
    var selectedPin:MKPlacemark? = nil
    var destLocation: CLLocationCoordinate2D?


    var autoCompleteTableView : UITableView!
    
    var userAnnotation = MKPointAnnotation()
    var destAnnotation = MKPointAnnotation()
    
    private var locationManager = CLLocationManager()
    private var userLocation: CLLocationCoordinate2D?
    private var driverLocation: CLLocationCoordinate2D?
    @IBOutlet weak var starRating: CosmosView!
    
    var titlesArray = [String] ()

    
    private var canCallUber = true
    private var riderCanceledRequest = false
    @IBOutlet weak var driverFullName: UILabel!
    @IBOutlet weak var driverRide: UILabel!
    @IBOutlet weak var tripCost: UILabel!
    @IBOutlet weak var myDestLocation: UILabel!
    @IBOutlet weak var tripState: UILabel!
    @IBOutlet weak var historyMap: MKMapView!
    
    var searchResults = [AddressSearch]()
    
    var selectedAddressIndex:Int = -1
    
    @IBOutlet weak var riderHistoryBTN: UIButton!
    @IBOutlet weak var reviewField: UITextField!
    
    @IBAction func getRiderHistory(_ sender: Any) {
//        let userID = Auth.auth().currentUser!.uid
//        let ref = Database.database().reference()
//        ref.child(Constants.passengerTrip).child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
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
//            for trips in self.titlesArray {
//                let trip_id = trips
//                print (trip_id)
//                ref.child(Constants.TRIP).child(trip_id).observeSingleEvent(of: .value, with: { (snapshot) in
//                    let value = snapshot.value as? NSDictionary
//                    let driverID = value?[Constants.dUid] as? String ?? "Not Found"
//                    let tripcost = value?[Constants.tripCost] as? Double ?? 0
//                    self.tripCost.text = String(tripcost)
//                    let tripstatus = value?[Constants.tripState] as? String ?? "Not Found"
//                    if tripstatus == "Completed" {
//                        self.tripState.text = "Success"
//                    }
//                    else if tripstatus == "Canceled" {
//                        self.tripState.text = "Canceled"
//                    }
//                    ref.child(Constants.TRIP).child(trip_id).child(Constants.directionDetails).observeSingleEvent(of: .value, with: { (snapshot) in
//                        let value4 = snapshot.value as? NSDictionary
//                        let mydestlocname = value4?[Constants.destAddress] as? String ?? "Not Found"
//                        self.myDestLocation.text = mydestlocname
//                        self.historyMap.delegate = self
//                        let mydestloclat = value4?[Constants.destLatitude] as? Double ?? 0
//                        let mydestloclon = value4?[Constants.destLongitude] as? Double ?? 0
//                        let loc = CLLocationCoordinate2D(latitude: mydestloclat, longitude: mydestloclon)
//                        let region = MKCoordinateRegion(center: loc, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//                        
//                        self.historyMap.setRegion(region, animated: true)
//                        
//                        self.historyMap.removeAnnotations(self.historyMap.annotations)
//                    })
//                    ref.child(Constants.DRIVERS).child(driverID).observeSingleEvent(of: .value, with: { (snapshot) in
//                        let value2 = snapshot.value as? NSDictionary
//                        let driverFName = value2?[Constants.dFirstName] as? String ?? "Not Found"
//                        let driverLName = value2?[Constants.dLastName] as? String ?? "Not Found"
//                        let driverName = driverFName + " " + driverLName
//                        self.driverFullName.text = driverName
//                        
//                        print(driverFName)
//                        ref.child(Constants.DRIVERS).child(driverID).child(Constants.scooterModel).observeSingleEvent(of: .value, with: { (snapshot) in
//                            let value3 = snapshot.value as? NSDictionary
//                            let driverScooter = value3?[Constants.sBrandName] as? String ?? "Not Found"
//                            self.driverRide.text = driverScooter
//                        })
//                    })
//                }
//                    
//                )}
//        })

        
        }
    
    
    @IBAction func rateDriver(_ sender: Any){
        let value = starRating.value(forKeyPath: "rating")
        let review = self.reviewField.text
        DBProvider.Instance.updateDriverRating(triprate: value as! Double, triprated: true, tripreview: review!)
        self.performSegue(withIdentifier: "RiderVC", sender: self)
    }
    
    @IBAction func getMyLocation(_ sender: Any) {
        if let location = locationManager.location?.coordinate{
            userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            //            print(location.latitude)
            //            print(location.longitude)
            let region = MKCoordinateRegion(center: userLocation!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            myMap.setRegion(region, animated: true)
            
            myMap.removeAnnotations(myMap.annotations)
            
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = userLocation!
            annotation.title = "Passenger Location"
            myMap.addAnnotation(annotation)
            userAnnotation.coordinate = userLocation!
        }
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        //fromEgp?.text = ""
        //toEgp?.text = ""
        imgContainerView.isHidden = true
        btnsContainerView.isHidden = true
        smallDollarOnCash.isHidden = true
        dollarCash.isHidden = true
        smallDollarOnEstimate.isHidden = true
        calcEstimate.isHidden = true
        fareEstimate.isHidden = true
        cashBtn.isHidden = true
        dividingLine.isHidden = true
        callUberBtn.isHidden = true
        
        initializeLocationManager()
        UberHandler.Instance.observeMessagesForRider()
        UberHandler.Instance.delegate = self
        myMap.delegate = self
        
        locationManager.requestLocation()
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable as UISearchResultsUpdating
        let searchBar = resultSearchController!.searchBar
        
        searchBar.sizeToFit()
        searchBar.placeholder = "Enter Destination Location"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = myMap
        //locationSearchTable.handleMapSearchDelegate = self as! HandleMapSearch
    }
    
    private func initializeLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestLocation()
        locationManager.requestWhenInUseAuthorization()
        locationManager.stopUpdatingLocation()
        //locationManager.startUpdatingLocation()
        
    }
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        
        switch status {
        case .notDetermined:
            print("NotDetermined")
        case .restricted:
            print("Restricted")
        case .denied:
            print("Denied")
        case .authorizedAlways:
            print("AuthorizedAlways")
        case .authorizedWhenInUse:
            print("AuthorizedWhenInUse")
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //If we have de coordinate from the manager
        if let location = locationManager.location?.coordinate{
            userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            let centre = userLocation!
            
            userLat = centre.latitude
            userLon = centre.longitude
            
            
            userLatLon = CLLocation(latitude: userLat!, longitude: userLon!)
            //print (userLatLon)
            
//            print(location.latitude)
//            print(location.longitude)
            let region = MKCoordinateRegion(center: userLocation!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            myMap.setRegion(region, animated: true)
            
            myMap.removeAnnotations(myMap.annotations)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = userLocation!
            annotation.title = "Passenger Location"
            myMap.addAnnotation(annotation)
            userAnnotation.coordinate = userLocation!
            
            
            CLGeocoder().reverseGeocodeLocation(userLatLon!) { (placemark, error) in
                if error != nil
                {
                    print ("THERE WAS AN ERROR")
                }
                else
                {
                    if let place = placemark?[0]
                    {
                        if place.subThoroughfare != nil
                        {
                            self.streetName = "\(place.subThoroughfare!) \(place.thoroughfare!)"
                            //print (self.streetName)
                        }
                    }
                }
            }
            
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = myMap.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.isDraggable = true
            pinView?.animatesDrop = true
        }
        else {
            pinView?.annotation = annotation
        }
        
        return pinView

    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {
        if newState == MKAnnotationViewDragState.ending {
            userLocation = view.annotation?.coordinate
            //print(droppedAt)
        }
    }
    
    
//    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        // Remove all annotations
//        self.myMap.removeAnnotations(myMap.annotations)
//        
//        // Add new annotation
//        let annotation = MKPointAnnotation()
//        let reuseId = "pin"
//        var pinView = myMap.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
//        annotation.coordinate = myMap.centerCoordinate
//        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//        pinView?.animatesDrop = true
//        self.myMap.addAnnotation(annotation)
//        userLocation = annotation.coordinate
//    }

    //self.performSegue(withIdentifier: "RiderVC", sender: nil)
    

//    func getDirections(){
//        if let selectedPin = selectedPin {
//            let mapItem = MKMapItem(placemark: selectedPin)
//            let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
//            mapItem.openInMaps(launchOptions: launchOptions)
//        }
//    }
//   
    func canCallUber(delegateCalled: Bool) {
        if delegateCalled {
            callUberBtn.setTitle("Cancel Scooter", for: .normal)
            //callUberBtn.setTitle("Cancel Scooter", for: UIControlState.normal)
            canCallUber = true
        }else {
            callUberBtn.setTitle("Call Scooter", for: .normal)
            canCallUber = true
        }
    }
    
    
    func getDriverID(driverID: String) {
        self.driverID = driverID
    }
    
    @IBAction func logout(_ sender: Any) {
        if AuthProvider.Instance.logOut() {
            //dismiss(animated: true, completion: nil) //Remove VC
            self.performSegue(withIdentifier: "logoutToMainScreen", sender: self)
        }else{
            alertTheUser(title: "Could Not Logout", message: "We Could Not Logout At The Moment, Please Try Again Later")
        }
    }
    
    @IBAction func callUber(_ sender: Any) {
        if userLocation != nil {
            if canCallUber {
                UberHandler.Instance.requestUber(latitude: Double(userLocation!.latitude) , longitude: Double(userLocation!.longitude), userLocationName: streetName! , destLocationName: destLocName! , destLatitude: destLocation!.latitude , destLongitude: destLocation!.longitude)
            }else {
                riderCanceledRequest = true
                //Cancel Uber
                UberHandler.Instance.cancelUber()
            }
        }
    }
    
    
    
    private func alertTheUser(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert,animated: true, completion: nil)
    }
    
//    func searchBarSearchButtonClicked(_ searchBarPassed: UISearchBar) {
//        
//        searchBarPassed.resignFirstResponder()
//        
//        let localSearchRequest:MKLocalSearchRequest = MKLocalSearchRequest()
//        localSearchRequest.naturalLanguageQuery = searchBarPassed.text
//        // Search 5 km radius
//        localSearchRequest.region = MKCoordinateRegionMakeWithDistance(self.currentAcceptedRide!.getCoordinates(), 5000.0, 5000.0)
//        
//        let localSearch:MKLocalSearch = MKLocalSearch(request: localSearchRequest)
//        localSearch.start { (searchResponse, error) -> Void in
//            // Initialize the address selection
//            self.selectedAddressIndex = -1
//            self.searchResults.removeAll()
//            
//            if error != nil {
//                self.alertTheUser(title: "Error searching address", message: (error?.localizedDescription)!)
//            } else {
//                if searchResponse == nil {
//                    self.alertTheUser(title: "No Results", message: "No address found which matches the provided address")
//                } else {
//                    if let mapItems = searchResponse?.mapItems {
//                        self.populateAddressSearchResults(mapItems)
//                        self.autoCompleteTableView.isHidden = false
//                    }
//                }
//                
//                // Reload the auto completion table
//                self.autoCompleteTableView.reloadData()
//            }
//        }
//    }
//    

    func showRouteOnMap() {

        myMap.delegate = self
        //self.myMap.removeAnnotations(myMap.annotations)
        
        let sourceLocation = userLocation
        let destinationLocation = destLocation
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation!, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation!, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "Pickup Point"
        userLocName = sourcePlacemark.name
        //print ("hi this is current user location name")
        //print (userLocName)
        
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = userLocation!
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
    
//    func reverseGeocoding(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
//        let location = CLLocation(latitude: latitude, longitude: longitude)
//        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
//            if error != nil {
//                print(error ?? "Error Occured")
//                return
//            }
//            else if (placemarks?.count)! > 0 {
//                let pm = placemarks![0]
//                let address = [String(describing: CNPostalAddressFormatter.self): pm.addressDictionary!]
//                print("\n\(address)")
//                if (pm.areasOfInterest?.count)! > 0 {
//                    let areaOfInterest = pm.areasOfInterest?[0]
//                    print(areaOfInterest!)
//                } else {
//                    print("No area of interest found.")
//                }
//            }
//        })
//    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.black
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        return MKOverlayRenderer()
    }
    
    
    func calculateFare() -> Double {

        let startLocation = MKMapPointForCoordinate(userLocation!)
        let endLocation = MKMapPointForCoordinate(destLocation!)
        let distance = MKMetersBetweenMapPoints(startLocation, endLocation)/1000
        //let distanceStr = NSString(format: "%.3f", distance)
    
        var fare:Double = 5
        fare = round(5 + 1.5*distance)
        //print (distanceStr)
        //print (fare)
        return fare
    }
    
    func calculateTime() -> Int {
        
        let startLocation = MKMapPointForCoordinate(userLocation!)
        let endLocation = MKMapPointForCoordinate(destLocation!)
        let distance = MKMetersBetweenMapPoints(startLocation, endLocation)/1000
        //let distanceStr = NSString(format: "%.3f", distance)
        
        let speed:Int = 40
        let time = round((distance/Double(speed))/60)

        return Int(time)
    }

    
    private func estimateTravelTime(request: MKDirectionsRequest, transportType: MKDirectionsTransportType, source: MKMapItem, destination: MKMapItem, string: (String) -> ()) {
        let request = MKDirectionsRequest()
        var directions: MKDirections!
        
        let sourceLocation = userLocation
        let destinationLocation = destLocation
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation!, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation!, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)

        request.source = sourceMapItem
        request.destination = destinationMapItem
        request.transportType = .automobile
        request.requestsAlternateRoutes = false
        directions = MKDirections(request: request)
        directions.calculateETA { (response, error) in
            if let seconds = response?.expectedTravelTime {
                let minutes = seconds / 60
                self.estimatedTime = String(Int(ceil(minutes)).description)
            }
        }
    }
    
    
    @IBAction func estimatedFare(_ sender:Any){
        let fare = calculateFare()
        //print (fare)
        //print(userLocation ?? "")
        //print(destLocation ?? "")
        let toFare = ceil(1.1*fare)
        let stringFare = String(fare)
        let stringToFare = String(toFare)
        //print(stringFare)
        //print(stringFare)
        fromEgp?.text = stringFare
        toEgp?.text = stringToFare

        let time = calculateTime()
        approxTravelTime?.text = String(format:"%.1f", time)
        dropoffLocationInFareEstimate?.text = destLocName
        pickupLocationInFareEstimate?.text = userLocName
        
        
        let request = MKDirectionsRequest()
        var directions: MKDirections!
        //var locationManager = CLLocationManager()
        
        let sourceLocation = userLocation
        let destinationLocation = destLocation
        //print(userLocation)
        //print(destLocation)
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation!, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation!, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        request.source = sourceMapItem
        request.destination = destinationMapItem
        request.transportType = .automobile
        request.requestsAlternateRoutes = false
        directions = MKDirections(request: request)
        directions.calculateETA { (response, error) in
            if let seconds = response?.expectedTravelTime {
                let minutes = seconds / 60
                self.estimatedTime = String(ceil(minutes))
            }
        }
        
        estimateTravelTime(request: request, transportType: .automobile, source: sourceMapItem, destination: destinationMapItem) { (string) in
            print("Minutes for Automobile: \(string) minutes")
        }
        
        
        //alertTheUser(title: "Estimate Fare", message: "Estimated Fare is \(stringFare) EGP to \(stringToFare) EGP \n ETA \(String(describing: estimatedTime)) Minutes")
        
         alertTheUser(title: "Estimate Fare", message: "Estimated Fare is \(stringFare) EGP to \(stringToFare) EGP")
        
        //self.performSegue(withIdentifier: "fareEstimate", sender: self)
        
    }

    
//    fileprivate func displayDirectionInMapFromStartToDestAddress() {
//        
//        self.myMap.removeOverlays(self.myMap.overlays)
//        
//        let markDestinationAddress = MKPlacemark(coordinate: self.currentAcceptedRide!.getDestinationCoordinates()!, addressDictionary: nil)
//        
//        let destinationMapItem = MKMapItem(placemark: markDestinationAddress)
//        destinationMapItem.name = "Trip Destination"
//        
//        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
//        
//        destinationMapItem.openInMaps(launchOptions: launchOptions)
//    }
    
}

struct AddressSearch {
    var addressText:String
    var addressCoordinate:CLLocationCoordinate2D
}

//extension RiderVC: HandleMapSearch {
//    func dropPinZoomIn(placemark:MKPlacemark){
//        myMap.removeOverlays(myMap.overlays)
//        // cache the pin
//        selectedPin = placemark
//        // clear existing pins
//        myMap.removeAnnotations(myMap.annotations)
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = placemark.coordinate
//        annotation.title = placemark.name
//        destLocation = placemark.coordinate
//        destAnnotation.coordinate = placemark.coordinate
////        if let city = placemark.locality,
////            let state = placemark.administrativeArea {
////            annotation.subtitle = "(city) (state)"
////        }
//        myMap.addAnnotation(annotation)
//        let span = MKCoordinateSpanMake(0.05, 0.05)
//        let region = MKCoordinateRegionMake(placemark.coordinate, span)
//        myMap.setRegion(region, animated: true)
//        //print (destLocation ?? "not set")
//        showRouteOnMap()
//        //self.myMap.setVisibleMapRect(self.myMap.visibleMapRect, edgePadding: UIEdgeInsetsMake(40.0, 20.0, 20, 20.0), animated: true)
//        //var fare:Double = 5;
//        //fare = calculateFare()
//        //print (fare)
//        imgContainerView.isHidden = false
//        btnsContainerView.isHidden = false
//        smallDollarOnCash.isHidden = false
//        dollarCash.isHidden = false
//        smallDollarOnEstimate.isHidden = false
//        calcEstimate.isHidden = false
//        fareEstimate.isHidden = false
//        cashBtn.isHidden = false
//        dividingLine.isHidden = false
//        callUberBtn.isHidden = false
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        //self.performSegue(withIdentifier: "ConfirmBooking", sender: self)
//    }
//}

