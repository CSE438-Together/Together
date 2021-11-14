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
    
    var locationManager = CLLocationManager()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    static let identifier = "PostDetailTableViewLocationCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "PostDetailTableViewLocationCell", bundle: nil)
    }
    
    public func configure( with departurePlace : String , with destination : String) {
        self.departurePlaceView.text = "Departure Place: " + departurePlace
        self.destionationView.text = "Destination: " + destination
        
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
                
                self.route(departureCord: departure.coordinate, destinationCord: destination.coordinate)
                
                
                
            })
        })
        
    }
    
    func route(departureCord: CLLocationCoordinate2D, destinationCord: CLLocationCoordinate2D) {
        
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
        fromSourceToDepartureDirectionRequest.transportType = .automobile
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
        print(locations)
    }
}

extension PostDetailTableViewLocationCell : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        render.strokeColor = .blue
        return render
    }
}
