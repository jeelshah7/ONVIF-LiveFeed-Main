//
//  HomeViewController.swift
//  ONVIF-LiveFeed
//
//  Created by Jeel Shah on 26/05/18.
//  Copyright © 2018 Jeel Shah. All rights reserved.
//

import UIKit
import CoreData
import RevealingSplashView

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
   
    var locations:[LocationMO] = []
    @IBOutlet weak var tableView: UITableView!
    var fetchResultController: NSFetchedResultsController<LocationMO>!
    let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "AppIcon83")!,iconInitialSize: CGSize(width: 83,height: 83),backgroundColor: UIColor.white)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(revealingSplashView)
        revealingSplashView.animationType = SplashAnimationType.heartBeat
        revealingSplashView.startAnimation()
        revealingSplashView.heartAttack = true
        
        self.tableView.separatorColor = UIColor.clear
        
        let fetchRequest:NSFetchRequest<LocationMO> = LocationMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "location", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    locations = fetchedObjects
                }
            } catch {
                print(error)
            }
        }
        
        
        
     
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func    controller(_    controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at    indexPath:IndexPath?,for type:NSFetchedResultsChangeType, newIndexPath:IndexPath?)  {
        
        switch    type    {
           case .insert: if let newIndexPath = newIndexPath{ tableView.insertRows(at:[newIndexPath], with: .fade)}
           case .delete: if let indexPath = indexPath{tableView.deleteRows(at:[indexPath],with: .fade)}
           case .update: if let indexPath = indexPath{tableView.reloadRows(at:[indexPath],with: .fade)}
        default: tableView.reloadData()
            
        }
        if let fetchedObjects = controller.fetchedObjects{
            locations = fetchedObjects as! [LocationMO]
        }
    }
            
    func    controllerDidChangeContent(_    controller:    NSFetchedResultsController<NSFetchRequestResult>)    {                tableView.endUpdates() }

    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Mark:- table View
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! HomeTableViewCell
        
        cell.locationLabel.text = locations[indexPath.row].location!
        let locationImage = locations[indexPath.row].image
        cell.locationImage.image = UIImage(data: (locationImage as Data?)!)
        
        

        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        cell.layer.shadowRadius = 4.0
        cell.layer.shadowOpacity = 1
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cell.contentView.layer.cornerRadius).cgPath
        
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCameraView" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationController = segue.destination as! CameraViewController
                destinationController.location = locations[indexPath.row]
            }
            
        }
    }
    
    // Mark: Swipe for more action
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteaction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action,indexPath) -> Void in
            let warningMenu = UIAlertController(title: "Warning", message: "Deleting this will permanently delete all cameras inside it.", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {(action) -> Void in
                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                    let context = appDelegate.persistentContainer.viewContext
                    let locationToDelete = self.fetchResultController.object(at: indexPath)
                    context.delete(locationToDelete)
                    appDelegate.saveContext()
                }
            })
            
            warningMenu.addAction(cancelAction)
            warningMenu.addAction(deleteAction)
            self.present(warningMenu,animated: true,completion: nil)
        })
        return [deleteaction]
    }

    
 

}

