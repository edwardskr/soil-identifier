//
//  MapViewController.swift
//  Soil Identifier
//
//  Created by Keith Edwards on 2015-03-23.
//  Copyright (c) 2015 Keith Edwards. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let coord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 54, longitude: -115)
        mapView.centerCoordinate = coord
        mapView.setRegion(MKCoordinateRegionMakeWithDistance(coord, 1600*1000, 900*1000), animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
