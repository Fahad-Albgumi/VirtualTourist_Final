//
//  MapViewController.swift
//  VirtualTourist
//
//  Created by fahad on 08/04/1441 AH.
//  Copyright © 1441 udacity. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate, NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController: NSFetchedResultsController<Pin>!

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultsController()
        loadMapAnnotations()
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        mapView.delegate = self
        mapView.addGestureRecognizer(longPressRecognizer)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    deinit {
        fetchedResultsController = nil
    }
    
    func setupView() {
        view.backgroundColor = UIColor.black
        navigationController?.navigationBar.barStyle = .black
        
        let mapRadius = CLLocationDistance(exactly: MKMapRect.world.size.height)!
        mapView.addOverlay(MKCircle(center: mapView.centerCoordinate, radius: mapRadius))
    }
    
    @objc func handleTap(sender: UILongPressGestureRecognizer) {
        if sender.state != .began {
            return
        }
        
        let touchPoint = sender.location(in: mapView)
        let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        addPin(longitude: newCoordinates.longitude, latitude: newCoordinates.latitude)
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        DispatchQueue.main.async {
            guard let pin = anObject as? Pin else {
                preconditionFailure("NOT A PIN!")
            }
            switch type {
            case .insert:
                self.mapView.addAnnotation(pin)
                break
            default: ()
            }
        }
    }
    
    func addPin(longitude: Double, latitude: Double) {
        let pin = Pin(context: DataController.shared.viewContext)
        pin.longitude = longitude
        pin.latitude = latitude
        pin.creationDate = Date()
        pin.title = "Pin"
        try? DataController.shared.viewContext.save()
    }
    
    private func loadMapAnnotations() {
        if let pins = fetchedResultsController.fetchedObjects {
            mapView.addAnnotations(pins)
        }
    }
    
    private func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Pin> = Pin.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let pinId = "pinId"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: pinId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: pinId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation! , animated: true)
        let pin: Pin = view.annotation as! Pin
        let photosListVC = storyboard?.instantiateViewController(withIdentifier: "PhotosViewController") as! PhotosViewController;
        
        photosListVC.pin = pin
//        photosListVC.dataController = DataController.shared
        
        navigationController?.pushViewController(photosListVC, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
    }

}
