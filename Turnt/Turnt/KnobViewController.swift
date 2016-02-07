//
//  KnobViewController.swift
//  Turnt
//
//  Created by Jesse Lurie on 2/6/16.
//  Copyright © 2016 Jesse Lurie. All rights reserved.
//

import UIKit

class KnobViewController: UIViewController{
    override func viewDidLoad() {
        let wheelslider = WheelSlider(frame: CGRectMake(0, 0, 250, 250))
        wheelslider.center = self.view.center
        wheelslider.backFillColor = UIColor.redColor()
        wheelslider.backStrokeColor = UIColor.redColor()
        wheelslider.maxVal = 100
        wheelslider.valueTextColor = UIColor.blackColor()
        self.view.addSubview(wheelslider)

    }
    
}