//
//  MapViewController.swift
//  Countries
//
//  Created by Sachendra Singh on 11/01/21.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var searchRequest:MKLocalSearch?
    
    var country:Country?
    {
        didSet {
            self.zoom(toCountry: self.country)
        }
    }
    
    var province:Province?
    {
        didSet {
            self.zoom(toCountry: self.country, province: self.province)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK : Helper methods
    private func zoom(toCountry country:Country?,
                      province:Province? = nil)
    {
        searchRequest?.cancel()
        if let country = country
        {
            let request = MKLocalSearch.Request()
            let provinceName = province?.Name ?? ""
            request.naturalLanguageQuery = (provinceName.count > 0 ? "\(provinceName)," : "") + country.Name
            
            searchRequest = MKLocalSearch(request: request)
            searchRequest?.start(completionHandler: { (response, error) in
                if let region = response?.boundingRegion
                {
                    self.mapView.setRegion(region,
                                           animated: true)
                }
            })
        }
    }

}
