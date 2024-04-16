//
//  MapManager.swift
//  iett
//
//  Created by Türker Kızılcık on 2.04.2024.
//

import Foundation
import MapKit

class MapManager {
    static let shared: MapManager = .init()

    func updateMapView(busCoordinates: CLLocationCoordinate2D, stationCoordinates: CLLocationCoordinate2D, mapView: MKMapView) {
        let region = MKCoordinateRegion(center: busCoordinates, latitudinalMeters: 100, longitudinalMeters: 100)
        mapView.setRegion(region, animated: true)
        mapView.mapType = .satellite
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = busCoordinates
        annotation.title = "bus".localized()

        let annotation1 = MKPointAnnotation()
        annotation1.coordinate = stationCoordinates
        annotation1.title = "station".localized()

        mapView.addAnnotation(annotation)
        mapView.addAnnotation(annotation1)
    }

    func calculateDistanceBetweenCoordinates(coord1: CLLocationCoordinate2D, coord2: CLLocationCoordinate2D) -> Double {
        let location1 = CLLocation(latitude: coord1.latitude, longitude: coord1.longitude)
        let location2 = CLLocation(latitude: coord2.latitude, longitude: coord2.longitude)
        let distanceInMeters = location1.distance(from: location2)
        let distanceInKilometers = distanceInMeters / 1000.0
        let formattedDistance = String(format: "%.3f", distanceInKilometers)
        return Double(formattedDistance) ?? 0.0
    }
}
