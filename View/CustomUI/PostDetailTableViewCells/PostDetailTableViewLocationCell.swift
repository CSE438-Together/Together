//
//  PostDetailTableViewLocationCell.swift
//  Together
//
//  Created by Bingxin Liu on 11/11/21.
//

import UIKit
import MapKit
import CoreLocation

class PostDetailTableViewLocationCell: UITableViewCell {
    
    @IBOutlet var departurePlaceView : UILabel!
    @IBOutlet var destionationView : UILabel!
    @IBOutlet var navigationView : MKMapView!
    @IBOutlet var shadowView : UIView!
    
    var locationManager = CLLocationManager()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    
    static let identifier = "PostDetailTableViewLocationCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "PostDetailTableViewLocationCell", bundle: nil)
    }
    
    public func configure( with departurePlace : String , with destination : String, with transportationType : Transportation) {
        
        self.navigationView.layer.cornerRadius = 10
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        self.shadowView.layer.shadowColor = UIColor.gray.cgColor
        self.shadowView.layer.shadowOffset = CGSize(width: 2, height: 3)
        self.shadowView.layer.shadowOpacity = 0.8
        self.shadowView.layer.masksToBounds = false
        self.shadowView.layer.cornerRadius = 10
        
        self.shadowView.layer.zPosition = -2
        self.shadowView.backgroundColor = UIColor(named: "bgGreen")
        
        
        self.departurePlaceView.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.departurePlaceView.numberOfLines = 0
        self.departurePlaceView.text = "From: \n" + departurePlace.components(separatedBy: .newlines).joined(separator: ", ")
        
        self.destionationView.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.destionationView.numberOfLines = 0
        self.destionationView.text = "To: \n" + destination.components(separatedBy: .newlines).joined(separator: ", ")
        
        // set up mapview
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        navigationView.delegate = self
        
        let geoCoder = CLGeocoder()
        guard departurePlace.count != 0 else { return }
        guard destination.count != 0 else { return }
        
        geoCoder.geocodeAddressString(departurePlace, completionHandler: {
            (placeMarks, error) in
            guard let placeMarks = placeMarks,
                  let departure = placeMarks.first?.location
            else {
                // Error Message
                print("Departure Location Not Found")
                return
            }
            
            geoCoder.geocodeAddressString(destination, completionHandler: {
                (placeMarks, error) in
                guard let placeMarks = placeMarks,
                      let destination = placeMarks.first?.location
                else {
                    // Error Message
                    print("Destination Location Not Found")
                    return
                }
                
                self.route(departureCord: departure.coordinate, destinationCord: destination.coordinate, transportationType: transportationType)
                
                
                
            })
        })
        
    }
    
    func route(departureCord: CLLocationCoordinate2D, destinationCord: CLLocationCoordinate2D, transportationType: Transportation) {
        
        guard let sourceCord = locationManager.location?.coordinate else { return }
        
        let sourcePlaceMark = MKPlacemark(coordinate: sourceCord)
        let departurePlaceMark = MKPlacemark(coordinate: departureCord)
        let destinationPlaceMark = MKPlacemark(coordinate: destinationCord)
        
        let sourceItem = MKMapItem(placemark: sourcePlaceMark)
        let departureItem = MKMapItem(placemark: departurePlaceMark)
        let destinationItem = MKMapItem(placemark: destinationPlaceMark)
        
        // draw from place right now to departure place
        let fromSourceToDepartureDirectionRequest = MKDirections.Request()
        fromSourceToDepartureDirectionRequest.source = sourceItem
        fromSourceToDepartureDirectionRequest.destination = departureItem
        switch transportationType {
        case .car:
            fromSourceToDepartureDirectionRequest.transportType = .automobile
        case .walk:
            fromSourceToDepartureDirectionRequest.transportType = .walking
        case .tram:
            fromSourceToDepartureDirectionRequest.transportType = .transit
        case .bike:
            fromSourceToDepartureDirectionRequest.transportType = .walking
        case .taxi:
            fromSourceToDepartureDirectionRequest.transportType = .automobile
        }
        
        fromSourceToDepartureDirectionRequest.requestsAlternateRoutes = true
        
        let routeFromSourceToDeparture = MKDirections(request: fromSourceToDepartureDirectionRequest)
        routeFromSourceToDeparture.calculate(completionHandler: {
            (response, error) in
            guard let response = response, error == nil else {
                print("route from source to departure failed")
                return
            }
            
            let routePath = response.routes[0]
            self.navigationView.addOverlay(routePath.polyline)
            self.navigationView.setVisibleMapRect(routePath.polyline.boundingMapRect, animated: true)
            
            // draw from departure to destination
            
            let fromDepartureToDestinationDirectionRequest = MKDirections.Request()
            fromDepartureToDestinationDirectionRequest.source = departureItem
            fromDepartureToDestinationDirectionRequest.destination = destinationItem
            fromDepartureToDestinationDirectionRequest.transportType = .automobile
            fromDepartureToDestinationDirectionRequest.requestsAlternateRoutes = true

            let routeFromDepartureToDestination = MKDirections(request: fromDepartureToDestinationDirectionRequest)
            routeFromDepartureToDestination.calculate(completionHandler: {
                (response, error) in
                guard let response = response, error == nil else {
                    print("route from source to departure failed")
                    return
                }

                let routePath = response.routes[0]
                self.navigationView.addOverlay(routePath.polyline)
                self.navigationView.setVisibleMapRect(routePath.polyline.boundingMapRect, animated: true)
            })
            
        })
        
    }
    
    
}

extension PostDetailTableViewLocationCell : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // You can print location like this
        // an output example:
        // [<+37.78583400,-122.40641700> +/- 5.00m (speed -1.00 mps / course -1.00) @ 11/19/21, 11:43:18 PM Central Standard Time]
        
        //print(locations)
    }
}

extension PostDetailTableViewLocationCell : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .blue
        return render
    }
}
