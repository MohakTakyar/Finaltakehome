//
//  Map.swift
//  Mohak_Takyar_FE_8871333
//
//  Created by user238229 on 4/7/24.
//

import UIKit
import MapKit

class Map: UIViewController,
           MKMapViewDelegate,
           CLLocationManagerDelegate {
    
    @IBOutlet weak var slidebar: UISlider!
    @IBOutlet weak var Mymapview: MKMapView!
   
    let loc = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    var destinationLocation: CLLocationCoordinate2D?
    var destinationCityName = ""
    var currentCityName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        Mymapview.delegate = self
        loc.delegate = self
        loc.requestWhenInUseAuthorization()
        loc.startUpdatingLocation()
        setupSlider()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(rightBarButtonTapped))
        self.tabBarController?.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    private func setupSlider() {
        slidebar.minimumValue = 0.0
        slidebar.maximumValue = 1.0
        slidebar.value = 0.5
        slidebar.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        let region = MKCoordinateRegion(center: Mymapview.centerCoordinate, latitudinalMeters: CLLocationDistance(10000 - sender.value * 10000), longitudinalMeters: CLLocationDistance(10000 - sender.value * 10000))
        Mymapview.setRegion(Mymapview.regionThatFits(region), animated: true)
    }
    
    @objc func rightBarButtonTapped() {
        gtCtyName()
    }
    
    func gtCtyName() {
        showCityInputAlert(on: self,
                           title: "Enter City",
                           message: "Type the name of the city") { cityName in
            self.lookupCity(cityName: cityName)
            self.destinationCityName = cityName
        }
    }
    
    private func lookupCity(cityName: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(cityName) { [weak self] (placemarks, error) in
            guard let strongSelf = self else { return }
            if let placemark = placemarks?.first, let location = placemark.location {
                strongSelf.destinationLocation = location.coordinate
                strongSelf.addAnnotationAtCoordinate(coordinate: location.coordinate)
                strongSelf.getDirections(transportType: .automobile)
            }
        }
    }
    
    private func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        Mymapview.addAnnotation(annotation)
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000/2, longitudinalMeters: 10000/2)
        Mymapview.setRegion(region, animated: true)
    }
    
    private func getDirections(transportType: MKDirectionsTransportType) {
        guard let startLocation = currentLocation, let endLocation = destinationLocation else { return }
        let strtplcemrk = MKPlacemark(coordinate: startLocation)
        let endplcmrkr = MKPlacemark(coordinate: endLocation)
        
        let strtmpitm = MKMapItem(placemark: strtplcemrk)
        let endmpitm = MKMapItem(placemark: endplcmrkr)
        
        let dirctionrqst = MKDirections.Request()
        dirctionrqst.source = strtmpitm
        dirctionrqst.destination = endmpitm
        dirctionrqst.transportType = transportType
        
        let drction = MKDirections(request: dirctionrqst)
        drction.calculate { [weak self] (response, error) in
            guard let strongSelf = self else { return }
            if let route = response?.routes.first {
                strongSelf.Mymapview.removeOverlays(strongSelf.Mymapview.overlays)
                strongSelf.Mymapview.addOverlay(route.polyline, level: .aboveRoads)
                let rect = route.polyline.boundingMapRect
                strongSelf.Mymapview.setRegion(MKCoordinateRegion(rect), animated: true)
                let dstnc = route.distance
                let dstncekm = dstnc / 1000
                let distanceString = String(format: "%.2f km", dstncekm)
                
                DataSavingManager.shared.saveDirection(ctyname: endplcmrkr.locality ?? "",
                                                     distence: distanceString,
                                                     fromhist: "Map",
                                                     method: transportType == .automobile ? "Car" : "Walk",
                                                     strtPnt: self?.currentCityName ?? "",
                                                     endPnt: self?.destinationCityName ?? "")
            }
        }
    }
    
    // CLLocationManagerDelegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location.coordinate
            manager.stopUpdatingLocation()
            addAnnotationAtCoordinate(coordinate: location.coordinate)
            getCurrentCityName(for: location) { city in
                self.currentCityName = city ?? ""
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let rndr = MKPolylineRenderer(overlay: overlay)
            rndr.strokeColor = UIColor.blue
            rndr.lineWidth = 4.0
            return rndr
        }
        return MKOverlayRenderer()
    }
    
    func getCurrentCityName(for location: CLLocation, completion: @escaping (String?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let err = error {
                print("Error getting city name: \(err)")
                completion(nil)
            } else if let placemark = placemarks?.first {
                let city = placemark.locality
                completion(city)
            } else {
                print("Placemark not found")
                completion(nil)
            }
        }
    }

    
    @IBAction func carTapped(_ sender: Any) {
        getDirections(transportType: .automobile)
    }
    @IBAction func walkTapped(_ sender: Any) {
        getDirections(transportType: .walking)
    }
}
