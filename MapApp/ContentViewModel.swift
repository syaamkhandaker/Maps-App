//
//  ContentViewModel.swift
//  MapApp
//
//  Created by Syaam Boss on 5/2/22.
//
// This class's main purpose is to ask for location services and to create directions from two places. This entire class wass inspired by Sean Allen's video on showing user's locations.

import MapKit
import SwiftUI

//creates default values, I had chosen random values
enum MapDetails{
    static let startingLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    static let startingSpan = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
}

final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
    @Published var region = MKCoordinateRegion (center: MapDetails.startingLocation, span: MapDetails.startingSpan)
    var locationManager: CLLocationManager?
    @Published var steps: [MKRoute.Step] = []
    var end: CLLocationCoordinate2D?
    
    //first method that is called by my base class
    func checkLocationServices(){
        if(CLLocationManager.locationServicesEnabled()){
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            //method above automatically calls locationManagerDidChangeAuthorization(), so we overrided the method to call to checkLocationAuthorization()
        }else{
            print("Please turn on your location services!")
        }
    }
    
    private func checkLocationAuthorization(){
        guard let locationManager = locationManager else {
            return
        }
        switch locationManager.authorizationStatus{
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Please turn on your location services")
        case .denied:
            print("You have denied this app's location services. Please turn them on")
        case .authorizedAlways, .authorizedWhenInUse:
            region = MKCoordinateRegion(center: locationManager.location!.coordinate, span: MapDetails.startingSpan)
            //this code above makes sure that the screen can focus primarily on the user's location. It centers so that the users location is in the center of the map.
        @unknown default:
            break
        }
        
    }
    

func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    checkLocationAuthorization()
}


}
