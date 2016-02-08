//
//  MapView.swift
//  Turnt
//
//  Created by Lauren Conniff on 2/6/16.
//  Copyright © 2016 Jesse Lurie. All rights reserved.
//

import UIKit
import MapKit
import UberRides
import CoreLocation


class MapView: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    var destination: MKMapItem?
    
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView.showsUserLocation = true
        self.mapView.delegate = self;
        self.navigationController?.navigationBarHidden = true
        
        //loop through all friends lat and long and plot activiy
        let newYorkLocation = CLLocationCoordinate2DMake(40.730872, -74.003066)
        // Drop a pin
        let dropPin = MKPointAnnotation()
        let pinView = MKAnnotationView()
        dropPin.coordinate = newYorkLocation
        dropPin.title = "New York City"
        self.navigationController?.navigationBarHidden = true
        pinView.annotation = dropPin
        mapView.addAnnotation(dropPin)
        // Drop a pin
        let madso = CLLocationCoordinate2DMake(41.730872, -70.003066)
        let dropPin2 = MKPointAnnotation()
        let pinView2 = MKAnnotationView()
        dropPin2.coordinate = madso
        dropPin2.title = "a"
        pinView2.annotation = dropPin2
        mapView.addAnnotation(dropPin2)
        // Drop a pin
           let madso2 = CLLocationCoordinate2DMake(31.730872, -75.003066)
        let dropPin3 = MKPointAnnotation()
        let pinView3 = MKAnnotationView()
        dropPin3.coordinate = madso2
        dropPin3.title = "b"
        pinView3.annotation = dropPin3
        mapView.addAnnotation(dropPin3)
        // Drop a pin
        let madso4 = CLLocationCoordinate2DMake(31.730872, -40.003066)
        let dropPin4 = MKPointAnnotation()
        let pinView4 = MKAnnotationView()
        dropPin4.coordinate = madso4
        dropPin4.title = "c"
        pinView4.annotation = dropPin4
        mapView.addAnnotation(dropPin4)
        // Drop a pin
        let madso5 = CLLocationCoordinate2DMake(44.730872, -77.003066)
        let dropPin6 = MKPointAnnotation()
        let pinView6 = MKAnnotationView()
        dropPin6.coordinate = madso5
        dropPin6.title = "d"
        pinView6.annotation = dropPin6
        mapView.addAnnotation(dropPin6)
        // Drop a pin
        let madso8 = CLLocationCoordinate2DMake(31.730872, -40.003066)
        let dropPin9 = MKPointAnnotation()
        let pinView9 = MKAnnotationView()
        dropPin9.coordinate = madso8
        dropPin9.title = "e"
        pinView9.annotation = dropPin9
        mapView.addAnnotation(dropPin)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        self.mapView.setRegion(region, animated: true)
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors: " + error.localizedDescription)
    }
    
  
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        var latlon = [Double]()
        if let x = view.annotation?.coordinate.latitude{
            latlon.append(x)
        }
        if let y = view.annotation?.coordinate.longitude{
            latlon.append(y)
        }
        NSUserDefaults.standardUserDefaults().setObject(latlon, forKey: "current")
        NSUserDefaults.standardUserDefaults().synchronize()
        self.navigationController?.navigationBarHidden = false
    }
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        self.navigationController?.navigationBarHidden = true
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKPinAnnotationView()
        annotationView.canShowCallout = true
        return annotationView
        
    }
 
    
    @IBAction func gpsTap(sender: AnyObject) {
        let latlon = NSUserDefaults.standardUserDefaults().objectForKey("current") as! NSArray

        let latitute:CLLocationDegrees =  latlon[0].doubleValue
        let longitute:CLLocationDegrees =  latlon[1].doubleValue
        
        let regionDistance:CLLocationDistance = 10000
        let coordinates = CLLocationCoordinate2DMake(latitute, longitute)
        let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: regionSpan.center),
            MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: regionSpan.span)
        ]
        let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        //mapItem.name = "\(self.venueName)"
        mapItem.openInMapsWithLaunchOptions(options)

    }

    @IBAction func uberTap(sender: AnyObject) {
        let button = RequestButton()
        //view.addSubview(button)
        // Swift
        button.setProductID("abc123-productID")
        button.setPickupLocation(latitude: 37.770, longitude: -122.466, nickname: "California Academy of Sciences")
        button.setDropoffLocation(latitude: 37.791, longitude: -122.405, nickname: "Pier 39")
        button.uberButtonTapped(button)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
