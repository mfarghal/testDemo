//
//  _RidarVC.swift
//  Scooter
//
//  Created by Mohamed Farghal on 11/3/17.
//  Copyright © 2017 Nour El Zafarany. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import AddressBookUI

class _RidarVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UberController , GetDriverID {
    func canCallUber(delegateCalled: Bool) {
        
    }
    
    func getDriverID(driverID: String) {
        
    }
    

    @IBOutlet weak var myMap: MKMapView!
    
    
    var locationTable:_locationSearchTable = _locationSearchTable()
    // Mark SECTION NewGUI
    let leftBtnBar: UIButton = {
        let view = UIButton(type: UIButtonType.system)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(named: "Menu.png"), for: UIControlState.normal)
        view.imageView?.contentMode = .scaleToFill
        view.contentHorizontalAlignment = .center
        
        return view
    }()
    
    let rightBtnBar: UIButton = {
        let view = UIButton(type: UIButtonType.system)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setBackgroundImage(UIImage(named: "CurrentLocation.png"), for: UIControlState.normal)
        view.imageView?.contentMode = .scaleToFill
        view.contentHorizontalAlignment = .center
        
        return view
    }()
    //------------------------------------------------------------------------------------------------
    let bottomViewluncher: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let imageCash: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.backgroundColor = UIColor.white
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    let BtnCash: UIButton = {
        let view = UIButton(type: UIButtonType.system)
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Cash", for: UIControlState.normal)
        view.titleLabel?.font = UIFont(name: "", size: 28)
        view.contentHorizontalAlignment = .left
        view.setTitleColor(UIColor.black, for: UIControlState.normal)
        view.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 0.0)
        
        return view
    }()
    
    let BtnEstimate: UIButton = {
        let view = UIButton(type: UIButtonType.system)
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Estimate", for: UIControlState.normal)
        view.titleLabel?.font = UIFont(name: "", size: 28)
        view.contentHorizontalAlignment = .left
        view.setTitleColor(UIColor.black, for: UIControlState.normal)
        view.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10, bottom: 0.0, right: 0.0)
        
        return view
    }()
    let imageEstimate: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.backgroundColor = UIColor.white
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    let BtnCallUber: UIButton = {
        let view = UIButton(type: UIButtonType.system)
        view.backgroundColor = UIColor(red: 38/250, green: 167/250, blue: 224/250, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.setTitle("CONFIRM BOOKING", for: UIControlState.normal)
        view.titleLabel?.font = UIFont(name: "", size: 40)
        view.contentHorizontalAlignment = .center
        
        view.setTitleColor(UIColor.white, for: UIControlState.normal)
        return view
    }()
    //------------------------------------------------------------------------------------------------
    
    let SDView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let animationImages = [UIImage(named: "1.png")!,UIImage(named: "2.png")!,UIImage(named: "3.png")!,UIImage(named: "4.png")!,UIImage(named: "5.png")!,UIImage(named: "6.png")!,UIImage(named: "7.png")!]

    let ImageView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    let imageLocation: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.animationDuration = 0.5
        image.animationRepeatCount = 1
        image.image = UIImage(named: "1.png")
        return image
    }()
    
    
    var sourceLocation : UITextField = {
        let view = UITextField()
        view.backgroundColor = UIColor.white
        view.text = "Current Location"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var destinationLocation : UITextField = {
        let view = UITextField()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    //------------------------------------------------------------------------------------------------

    
    
    var ExpandState = true
    var heightConstraintView :NSLayoutConstraint?
    var topConstraintView :NSLayoutConstraint?
    
    var heightConstraintSource :NSLayoutConstraint?
    var topConstraintSource :NSLayoutConstraint?
    
    var bottomConstraintdestination :NSLayoutConstraint?
    var heightConstraintdestination :NSLayoutConstraint?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        destinationLocation.addTarget(self, action: #selector(self.pressedTextFieldDestination), for: .touchDown)
        destinationLocation.addTarget(self, action: #selector(self.changeTextFieldDestination), for: .editingChanged)
        rightBtnBar.addTarget(self, action: #selector(self.MyLocation), for: .touchDown)
        
        self.navigationController?.isNavigationBarHidden = true

        let leadingConstraintView = NSLayoutConstraint(item: SDView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 70)
        let trailingConstraintView = NSLayoutConstraint(item: SDView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -70)
        topConstraintView = NSLayoutConstraint(item: SDView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 150)
        heightConstraintView = NSLayoutConstraint(item: SDView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0, constant: 30)
        view.addSubview(SDView)
        view.addConstraints([topConstraintView!,leadingConstraintView,trailingConstraintView,heightConstraintView!])
        
        
        
        let leadingConstraintbottomView = NSLayoutConstraint(item: bottomViewluncher, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 20)
        let trailingConstraintbottomView = NSLayoutConstraint(item: bottomViewluncher, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -20)
        let topConstraintbottomView = NSLayoutConstraint(item: bottomViewluncher, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -70)
        let heightConstraintbottomView = NSLayoutConstraint(item: bottomViewluncher, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0, constant: 140)
        view.addSubview(bottomViewluncher)
        view.addConstraints([leadingConstraintbottomView,trailingConstraintbottomView,topConstraintbottomView,heightConstraintbottomView])
        
        //----------------------------------
        settingConstraintTextFeildView()
        settingConstraintBottomView()
        settingConstraintNavigationBar()
        
        //END Design By MohamedFarghal
        
        
        initializeLocationManager()
        UberHandler.Instance.observeMessagesForRider()
        UberHandler.Instance.delegate = self
        myMap?.delegate = self
        
        locationManager.requestLocation()
//        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
//        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
//        resultSearchController?.searchResultsUpdater = locationSearchTable as UISearchResultsUpdating
//        let searchBar = resultSearchController!.searchBar
//
//        searchBar.sizeToFit()
//        searchBar.placeholder = "Enter Destination Location"
//        navigationItem.titleView = resultSearchController?.searchBar
//        resultSearchController?.hidesNavigationBarDuringPresentation = false
//        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationTable.mapView = myMap
        locationTable.handleMapSearchDelegate = self as! HandleMapSearch

        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var resultSearchController:UISearchController?

    var userLocName : String?
    var destLocName : String?
    
    var streetName : String?

    var selectedPin:MKPlacemark? = nil
    var destLocation: CLLocationCoordinate2D?
    
    var userLatLon : CLLocation?
    var destLatLon : CLLocation?
    var userLat : CLLocationDegrees?
    var userLon : CLLocationDegrees?
    
    
    fileprivate var locationManager = CLLocationManager()
    fileprivate var userLocation: CLLocationCoordinate2D?
    fileprivate var driverLocation: CLLocationCoordinate2D?
    
    
    var userAnnotation = MKPointAnnotation()
    var destAnnotation = MKPointAnnotation()
    
    @IBAction func MyLocation(_ sender: Any) {
        if let location = locationManager.location?.coordinate{
            userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            //            print(location.latitude)
            //            print(location.longitude)
            let region = MKCoordinateRegion(center: userLocation!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            myMap?.setRegion(region, animated: true)
            
            myMap?.removeAnnotations((myMap?.annotations)!)
            
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = userLocation!
            annotation.title = "Passenger Location"
            myMap?.addAnnotation(annotation)
            userAnnotation.coordinate = userLocation!
        }
    }

}

extension _RidarVC{
    func initializeLocationManager(){
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
            
            myMap?.setRegion(region, animated: true)
            
            myMap?.removeAnnotations((myMap?.annotations)!)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = userLocation!
            annotation.title = "Passenger Location"
            myMap?.addAnnotation(annotation)
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
}



extension _RidarVC{
    @objc func pressedTextFieldDestination(_ sender:Any)  {
        
        
        locationTable.showSettings()
        if ExpandState {
            self.topConstraintView?.constant = 134
            self.heightConstraintView?.constant = 61
            
            
            imageLocation.image = UIImage(named: "1.png")
            imageLocation.animationImages = animationImages
            self.imageLocation.startAnimating()
            
            UIView.animate(withDuration: 0.5, animations: {
                self.view.layoutIfNeeded()
                self.SDView.layoutIfNeeded()
            }) { (suc) in
                self.imageLocation.image = UIImage(named: "7.png")
                self.ExpandState = !self.ExpandState
            }
        }else{
            self.topConstraintView?.constant = 150.0
            self.heightConstraintView?.constant = 30
            
            imageLocation.image = UIImage(named: "7.png")
            imageLocation.animationImages = animationImages.reversed()
            self.imageLocation.startAnimating()
            
            UIView.animate(withDuration: 0.5, animations: {
                
                self.view.layoutIfNeeded()
                self.SDView.layoutIfNeeded()
            }) { (suc) in
                self.imageLocation.image = UIImage(named: "1.png")
                
                self.ExpandState = !self.ExpandState
            }
        }
        
    }
    @objc func changeTextFieldDestination(_ sender:Any)  {
        
          locationTable.updateSearchResults((sender as? UITextField)?.text)

    }
    
    func settingConstraintNavigationBar()  {
        let leadingConstraintleftBtn = NSLayoutConstraint(item: leftBtnBar, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 10)
        let topConstraintleftBtn = NSLayoutConstraint(item: leftBtnBar, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 30)
        let heightConstraintleftBtn = NSLayoutConstraint(item: leftBtnBar, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0, constant: 25)
        let widthConstraintleftBtn = NSLayoutConstraint(item: leftBtnBar, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0, constant: 25)
        view.addSubview(leftBtnBar)
        view.addConstraints([leadingConstraintleftBtn,topConstraintleftBtn,heightConstraintleftBtn,widthConstraintleftBtn])
        
        let trailingConstraintrightBtn = NSLayoutConstraint(item: rightBtnBar, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -10)
        let topConstraintrightBtn = NSLayoutConstraint(item: rightBtnBar, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 30)
        let heightConstraintrightBtn = NSLayoutConstraint(item: rightBtnBar, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0, constant: 30)
        let widthConstraintrightBtn = NSLayoutConstraint(item: rightBtnBar, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0, constant: 30)
        view.addSubview(rightBtnBar)
        view.addConstraints([trailingConstraintrightBtn,topConstraintrightBtn,heightConstraintrightBtn,widthConstraintrightBtn])
    }
    
    func settingConstraintTextFeildView(){
        let bottomConstraintImageView = NSLayoutConstraint(item: ImageView, attribute: .bottom, relatedBy: .equal, toItem: SDView, attribute: .bottom, multiplier: 1, constant: 0)
        let topConstraintImageView = NSLayoutConstraint(item: ImageView, attribute: .top, relatedBy: .equal, toItem: SDView, attribute: .top, multiplier: 1, constant: 0)
        
        let leadingConstraintImageView = NSLayoutConstraint(item: ImageView, attribute: .leading, relatedBy: .equal, toItem: SDView, attribute: .leading, multiplier: 1, constant: 0)
        let widthConstraintSourceView = NSLayoutConstraint(item: ImageView, attribute: .width, relatedBy: .equal, toItem: SDView, attribute: .width, multiplier: 0, constant: 35)
        
        SDView.addSubview(ImageView)
        SDView.addConstraints([bottomConstraintImageView,topConstraintImageView,leadingConstraintImageView,widthConstraintSourceView])
        
        
        
        let bottomConstraintImage = NSLayoutConstraint(item: imageLocation, attribute: .bottom, relatedBy: .equal, toItem: ImageView, attribute: .bottom, multiplier: 1, constant: -5)
        let topConstraintImage = NSLayoutConstraint(item: imageLocation, attribute: .top, relatedBy: .equal, toItem: ImageView, attribute: .top, multiplier: 1, constant: 5)
        
        let leadingConstraintImage = NSLayoutConstraint(item: imageLocation, attribute: .leading, relatedBy: .equal, toItem: ImageView, attribute: .leading, multiplier: 1, constant: 0)
        let widthConstraintSource = NSLayoutConstraint(item: imageLocation, attribute: .width, relatedBy: .equal, toItem: ImageView, attribute: .width, multiplier: 0, constant: 35)
        
        ImageView.addSubview(imageLocation)
        ImageView.addConstraints([topConstraintImage,bottomConstraintImage,leadingConstraintImage,widthConstraintSource])
        
        let leadingConstraintSource = NSLayoutConstraint(item: sourceLocation, attribute: .leading, relatedBy: .equal, toItem: ImageView, attribute: .trailing, multiplier: 1, constant: 0)
        let trailingConstraintSource = NSLayoutConstraint(item: sourceLocation, attribute: .trailing, relatedBy: .equal, toItem: SDView, attribute: .trailing, multiplier: 1, constant: 0)
        topConstraintSource = NSLayoutConstraint(item: sourceLocation, attribute: .top, relatedBy: .equal, toItem: SDView, attribute: .top, multiplier: 1, constant: 0)
        heightConstraintSource = NSLayoutConstraint(item: sourceLocation, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0, constant: 30)
        
        
        SDView.addSubview(sourceLocation)
        SDView.addConstraints([leadingConstraintSource,trailingConstraintSource,topConstraintSource!,heightConstraintSource!])
        
        
        let leadingConstraintdestination = NSLayoutConstraint(item: destinationLocation, attribute: .leading, relatedBy: .equal, toItem: ImageView, attribute: .trailing, multiplier: 1, constant: 0)
        let trailingConstraintdestination = NSLayoutConstraint(item: destinationLocation, attribute: .trailing, relatedBy: .equal, toItem: SDView, attribute: .trailing, multiplier: 1, constant: 0)
        bottomConstraintdestination = NSLayoutConstraint(item: destinationLocation, attribute: .bottom, relatedBy: .equal, toItem: SDView, attribute: .bottom, multiplier: 1, constant: 0)
        heightConstraintdestination = NSLayoutConstraint(item: destinationLocation, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0, constant: 30)
        
        SDView.addSubview(destinationLocation)
        SDView.addConstraints([leadingConstraintdestination,trailingConstraintdestination,bottomConstraintdestination!,heightConstraintdestination!])
    }
    func settingConstraintBottomView(){
        
        
        let topConstraintCashImage = NSLayoutConstraint(item: imageCash, attribute: .top, relatedBy: .equal, toItem: bottomViewluncher, attribute: .top, multiplier: 1, constant: 0)
        let leadingConstraintCashImage = NSLayoutConstraint(item: imageCash, attribute: .leading, relatedBy: .equal, toItem: bottomViewluncher, attribute: .leading, multiplier: 1, constant: 0)
        let heightConstraintCashImage = NSLayoutConstraint(item: imageCash, attribute: .height, relatedBy: .equal, toItem: bottomViewluncher, attribute: .height, multiplier: 0, constant: 45)
        let widthConstraintCashImage = NSLayoutConstraint(item: imageCash, attribute: .width, relatedBy: .equal, toItem: bottomViewluncher, attribute: .width, multiplier: 0, constant: 45)
        
        bottomViewluncher.addSubview(imageCash)
        bottomViewluncher.addConstraints([topConstraintCashImage,leadingConstraintCashImage,heightConstraintCashImage,widthConstraintCashImage])
        
        
        let topConstraintCashBtn = NSLayoutConstraint(item: BtnCash, attribute: .top, relatedBy: .equal, toItem: bottomViewluncher, attribute: .top, multiplier: 1, constant: 0)
        let leadingConstraintCashBtn = NSLayoutConstraint(item: BtnCash, attribute: .leading, relatedBy: .equal, toItem: imageCash, attribute: .trailing, multiplier: 1, constant: 0)
        let trailingConstraintCashBtn = NSLayoutConstraint(item: BtnCash, attribute: .trailing, relatedBy: .equal, toItem: bottomViewluncher, attribute: .trailing, multiplier: 1, constant: 0)
        let heightConstraintCashBtn = NSLayoutConstraint(item: BtnCash, attribute: .height, relatedBy: .equal, toItem: bottomViewluncher, attribute: .height, multiplier: 0, constant: 45)
        
        
        
        bottomViewluncher.addSubview(BtnCash)
        bottomViewluncher.addConstraints([topConstraintCashBtn,leadingConstraintCashBtn,trailingConstraintCashBtn,heightConstraintCashBtn])
        
        //--------
        let topConstraintEstimateImage = NSLayoutConstraint(item: imageEstimate, attribute: .top, relatedBy: .equal, toItem: bottomViewluncher, attribute: .top, multiplier: 1, constant: 46)
        let leadingConstraintEstimateImage = NSLayoutConstraint(item: imageEstimate, attribute: .leading, relatedBy: .equal, toItem: bottomViewluncher, attribute: .leading, multiplier: 1, constant: 0)
        let heightConstraintEstimateImage = NSLayoutConstraint(item: imageEstimate, attribute: .height, relatedBy: .equal, toItem: bottomViewluncher, attribute: .height, multiplier: 0, constant: 45)
        let widthConstraintEstimateImage = NSLayoutConstraint(item: imageEstimate, attribute: .width, relatedBy: .equal, toItem: bottomViewluncher, attribute: .width, multiplier: 0, constant: 45)
        
        bottomViewluncher.addSubview(imageEstimate)
        bottomViewluncher.addConstraints([topConstraintEstimateImage,leadingConstraintEstimateImage,heightConstraintEstimateImage,widthConstraintEstimateImage])
        
        
        let topConstraintEstimateBtn = NSLayoutConstraint(item: BtnEstimate, attribute: .top, relatedBy: .equal, toItem: bottomViewluncher, attribute: .top, multiplier: 1, constant:46)
        let leadingConstraintEstimateBtn = NSLayoutConstraint(item: BtnEstimate, attribute: .leading, relatedBy: .equal, toItem: imageCash, attribute: .trailing, multiplier: 1, constant: 0)
        let trailingConstraintEstimateBtn = NSLayoutConstraint(item: BtnEstimate, attribute: .trailing, relatedBy: .equal, toItem: bottomViewluncher, attribute: .trailing, multiplier: 1, constant: 0)
        let heightConstraintEstimateBtn = NSLayoutConstraint(item: BtnEstimate, attribute: .height, relatedBy: .equal, toItem: bottomViewluncher, attribute: .height, multiplier: 0, constant: 45)
        
        
        
        bottomViewluncher.addSubview(BtnEstimate)
        bottomViewluncher.addConstraints([topConstraintEstimateBtn,leadingConstraintEstimateBtn,trailingConstraintEstimateBtn,heightConstraintEstimateBtn])
        
        
        
        let topConstraintBtnCall = NSLayoutConstraint(item: BtnCallUber, attribute: .top, relatedBy: .equal, toItem: BtnEstimate, attribute: .bottom, multiplier: 1, constant:1)
        
        let bottomConstraintBtnCall = NSLayoutConstraint(item: BtnCallUber, attribute: .bottom, relatedBy: .equal, toItem: bottomViewluncher, attribute: .bottom, multiplier: 1, constant:0)
        
        let leadingConstraintBtnCall = NSLayoutConstraint(item: BtnCallUber, attribute: .leading, relatedBy: .equal, toItem: bottomViewluncher, attribute: .leading, multiplier: 1, constant: 0)
        let trailingConstraintBtnCall = NSLayoutConstraint(item: BtnCallUber, attribute: .trailing, relatedBy: .equal, toItem: bottomViewluncher, attribute: .trailing, multiplier: 1, constant: 0)
        
        
        
        
        bottomViewluncher.addSubview(BtnCallUber)
        bottomViewluncher.addConstraints([topConstraintBtnCall,leadingConstraintBtnCall,trailingConstraintBtnCall,bottomConstraintBtnCall])
        
        
    }
}
extension _RidarVC{
    
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
}
extension _RidarVC: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        myMap.removeOverlays(myMap.overlays)
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        myMap.removeAnnotations(myMap.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        destLocation = placemark.coordinate
        destAnnotation.coordinate = placemark.coordinate
        //        if let city = placemark.locality,
        //            let state = placemark.administrativeArea {
        //            annotation.subtitle = "(city) (state)"
        //        }
        myMap.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        myMap.setRegion(region, animated: true)
        //print (destLocation ?? "not set")
        showRouteOnMap()
        //self.myMap.setVisibleMapRect(self.myMap.visibleMapRect, edgePadding: UIEdgeInsetsMake(40.0, 20.0, 20, 20.0), animated: true)
        //var fare:Double = 5;
        //fare = calculateFare()
        //print (fare)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        //self.performSegue(withIdentifier: "ConfirmBooking", sender: self)
    }
}
