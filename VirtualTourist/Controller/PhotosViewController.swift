//
//  ViewController.swift
//  VirtualTourist
//
//  Created by fahad on 08/04/1441 AH.
//  Copyright © 1441 udacity. All rights reserved.
//

import UIKit
import Kingfisher
import MapKit
import CoreData

class PhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
    
    var pin: Pin!
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    private let reuseId = "PhotoCell"
    private let itemsPerRow: CGFloat = 2
    private let insets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var refreshPhotos: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        setupFetchedResultsController()
        refreshPhotos.isEnabled = false
        if (fetchedResultsController.sections?[0].numberOfObjects ?? 0 == 0) {
            getPhotos()
        } else {
            refreshPhotos.isEnabled = true
        }
    }
    
    private func setupFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        let predicate = NSPredicate(format: "pin == %@", pin)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: "\(pin!.creationDate!)-photos")
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }
    
    private func getPhotos() {
        refreshPhotos.isEnabled = false
        API.getListOfPhotosIn(lat: pin.latitude, lon: pin.longitude) { (error, photosURL) in
            // if photos is empty show empty background
            switch error {
            case .notConnected:
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Hmmmm..", message:
                        "There seems to be no internet connection! please, connect to a network then try again.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                }
                break
            case .connected:
                for photoURL in photosURL! {
                    self.addPhoto(url: photoURL)
                }
                break
            case .other:
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Hmmmm..", message:
                        "Something bad occured. Please, try again.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
                    self.present(alertController, animated: true, completion: nil)
                }
                break
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.refreshPhotos.isEnabled = true
            }
        }
    }
    
    func addPhoto(url: String) {
        let photo = Photo(context: DataController.shared.viewContext)
        photo.creationDate = Date()
        photo.url = url
        photo.pin = pin
        try? DataController.shared.viewContext.save()
    }
    
    func deletePhoto(_ photo: Photo) {
        DataController.shared.viewContext.delete(photo)
        do {
            try DataController.shared.viewContext.save()
        } catch {
            print("Cant save photo!")
        }
        
    }
    
    @IBAction func removeAllPhotos() {
        if let photos = fetchedResultsController.fetchedObjects {
            for photo in photos {
                DataController.shared.viewContext.delete(photo)
                do {
                    try DataController.shared.viewContext.save()
                } catch {
                    print("Error saving")
                }
            }
        }
        getPhotos()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (fetchedResultsController.sections?[section].numberOfObjects ?? 0 == 0) {
            collectionView.setEmptyMessage("No photos :(, try to refresh.")
        } else {
            collectionView.deleteEmptyMessage()
        }
        
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let aPhoto = fetchedResultsController.object(at: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseId, for: indexPath) as! PhotoCell
        
        // Configure cell
        if let photoData = aPhoto.data {
            cell.imageView.image = UIImage(data: photoData)
        } else if let photoURL = aPhoto.url {
            guard let url = URL(string: photoURL) else {
                print("no!")
                return cell
            }
            cell.imageView.kf.setImage(with: url, placeholder: UIImage(named: "Placeholder"), options: nil, progressBlock: nil) { (img, err, cacheType, url) in
                if ((err) != nil) {
                    
                } else {
                    aPhoto.data = img?.pngData()
                    try? DataController.shared.viewContext.save()
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = insets.right * (itemsPerRow + 1)
        let availableWidth = view.frame.width - padding
        let widthOfItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthOfItem, height: widthOfItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return insets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return insets.right
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let aPhoto = fetchedResultsController.object(at: indexPath)
        deletePhoto(aPhoto)
        
    }
}

