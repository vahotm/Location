//
//  MapViewController.swift
//  Location Test
//
//  Created by Ivan Samalazau on 12.2.18.
//  Copyright © 2018 Ivan Samalazau. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class MapViewController: UIViewController {
    
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var locateButton: UIButton!
    @IBOutlet weak var listButton: UIButton!
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(gestureRecognizer:)))
        mapView.addGestureRecognizer(recognizer)
        
        DataManager.getPoints() { [weak self] (points, error) in
            guard let `self` = self else { return }
            
            if error != nil {
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                guard let newPoints = points else { return }
                self.populateMap(points: newPoints)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: - Populate map
    
    func populateMap(points: [Point]) {
        let newAnnotations = points.map { (p) -> PointAnnotation in
            return PointAnnotation(point: p)
        }
        
        mapView.removeAnnotations(mapView.annotations)
        self.mapView.addAnnotations(newAnnotations)
    }
    
    func annotationForPoint(_ point: Point) -> PointAnnotation? {
        let annotation = mapView.annotations.first { (annotation) -> Bool in
            if let pointAnnotation = annotation as? PointAnnotation {
                return pointAnnotation.point == point
            } 
            return false
        }
        return annotation as? PointAnnotation
    }
    
    func updateAnnotation(for point: Point) {
        if let annotation = annotationForPoint(point) {
            mapView.removeAnnotation(annotation)
            let newAnnotation = PointAnnotation(point: point)
            mapView.addAnnotation(newAnnotation)
        }
    }
    
    func removeAnnotation(for point: Point) {
        if let annotation = annotationForPoint(point) {
            mapView.removeAnnotation(annotation)
        }
    }
    
    func addAnnotation(for point: Point) {
        let newAnnotation = PointAnnotation(point: point)
        mapView.addAnnotation(newAnnotation)
    }
    
    // MARK: - Location authorization
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    // MARK: - Actions
    
    @IBAction func onLocate(_ sender: UIButton) {
        if let userCoordinate = mapView.userLocation.location?.coordinate {
            let region = MKCoordinateRegionMakeWithDistance(userCoordinate, 2000, 2000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    @IBAction func onList(_ sender: UIButton) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let listViewController = storyboard.instantiateViewController(withIdentifier: "ListViewController") as! ListViewController
        listViewController.data.points = DataManager.points()
        if let userCoordinate = mapView.userLocation.location?.coordinate {
            listViewController.data.coordinate = userCoordinate
        }
        listViewController.onSave = { [weak self] point in
            guard let `self` = self else { return }
            self.populateMap(points: DataManager.points())
        }
        listViewController.onDelete = { [weak self] point in
            guard let `self` = self else { return }
            self.populateMap(points: DataManager.points())
        }
        navigationController?.pushViewController(listViewController, animated: true)
    }
    
    
    @objc func onLongPress(gestureRecognizer:UIGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let touchPoint = gestureRecognizer.location(in: mapView)
            let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            
            let point = Point()
            point.name = "New Point"
            point.lat = newCoordinates.latitude
            point.lng = newCoordinates.longitude
            point.type = .user
            
            DataManager.createPoint(point)
            addAnnotation(for: point)
        }
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? PointAnnotation else { return nil }
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView { 
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        view.markerTintColor = annotation.markerTintColor
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let pointAnnotation = view.annotation as! PointAnnotation
        guard let point = pointAnnotation.point else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailsViewController = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        detailsViewController.point = point
        detailsViewController.onSave = { [weak self] point in
            guard let `self` = self else { return }
            DataManager.updatePoint(point,
                                    withName: detailsViewController.name,
                                    userDescription: detailsViewController.userDescription)
            self.updateAnnotation(for:point)
        }
        detailsViewController.onDelete = { [weak self] point in
            guard let `self` = self else { return }
            self.removeAnnotation(for: point)
            DataManager.deletePoint(point)
        }
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
}

