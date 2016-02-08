//
//  ActivityView.swift
//  Turnt
//
//  Created by Jesse Lurie on 2/7/16.
//  Copyright © 2016 Jesse Lurie. All rights reserved.
//

import UIKit
import CoreLocation
import AddressBookUI
import Alamofire

class ActivityView: UIViewController {
    @IBOutlet weak var activity: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var time: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func doneTap(sender: AnyObject) {
       
        performSegueWithIdentifier("toMapFromActivity", sender: self )
    }
    
    func forwardGeocoding(address: String) -> [Double]{
          var retval = [Double]()
            CLGeocoder().geocodeAddressString(address, completionHandler: { (placemarks, error) in
            if error != nil {
                print(error)
                return
            }
            if placemarks?.count > 0 {
                let placemark = placemarks?[0]
                let location = placemark?.location
                let coordinate = location?.coordinate
                let x = coordinate!.latitude as Double!
                let y = coordinate!.longitude as Double!
                retval.append(x)
                retval.append(y)
                print("\nlat: \(coordinate!.latitude), long: \(coordinate!.longitude)")
                if placemark?.areasOfInterest?.count > 0 {
                    let areaOfInterest = placemark!.areasOfInterest![0]
                    print(areaOfInterest)
                } else {
                    print("No area of interest found.")
                }
            }
        })
        return retval
    }
    
}
