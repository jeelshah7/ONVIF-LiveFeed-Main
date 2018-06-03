//
//  CameraViewController.swift
//  ONVIF-LiveFeed
//
//  Created by Jeel Shah on 29/05/18.
//  Copyright © 2018 Jeel Shah. All rights reserved.
//

import UIKit
import CoreData
import ONVIFCamera

class CameraViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate{
   
    lazy var cameras:[Camera] = []

    var location: LocationMO!
    @IBOutlet weak var tableView: UITableView!
    var fetchResultController: NSFetchedResultsController<Camera>!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        title = location.location

        let fetchRequest:NSFetchRequest<Camera> = Camera.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let filter = location
        print(location.location!)
        let predicate = NSPredicate(format: "location == %@", filter!)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [sortDescriptor]


        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate){
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self 
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    cameras = fetchedObjects
                    
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
            cameras = fetchedObjects as! [Camera]
        }
    }
    
    func    controllerDidChangeContent(_    controller:    NSFetchedResultsController<NSFetchRequestResult>)    {                tableView.endUpdates() }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table config
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cameras.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
            let cellIdentifier = "Cell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CameraTableViewCell
        
            cell.cameraNameLabel.text = cameras[indexPath.row].name
            cell.cameraIpAddressLabel.text = cameras[indexPath.row].ipAddress
        if cameras[indexPath.row].manufacturer != "" {
            cell.manufacturerLabel.text = cameras[indexPath.row].manufacturer
        }
        else {
            cell.manufacturerLabel.text = ""
        }
        
            return cell

    }
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddCameraView" {
            
                let destinationController = segue.destination as! UINavigationController
            let segueViewController = destinationController.topViewController as! AddCameraViewControllerTableViewController
            
                segueViewController.location = location
            
            
        }
        else if segue.identifier == "LiveCameraView" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let onvifCamera = ONVIFCamera(with: cameras[indexPath.row].ipAddress!, credential: (login: cameras[indexPath.row].userName, password: cameras[indexPath.row].password) as? (login: String, password: String),soapLicenseKey:"nU8Yi3Turrn42DmbDIelGDPvYzatf4ZJTE6SF2GwHtZFcaGzSM+JxCE+YyK7M69KOo58YsA4scb/WqeaKklRgA==")
                let destinationController = segue.destination as! LiveCameraViewController
                destinationController.onvifCamera = onvifCamera
                destinationController.credi = cameras[indexPath.row].userName! + ":" + cameras[indexPath.row].password! + "@"
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        else if segue.identifier == "cameraEditView" {
        
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                let destinationController = segue.destination as! UINavigationController
                let segueViewController = destinationController.topViewController as! EditCameraTableViewController
                
                segueViewController.camera = cameras[indexPath.row]
            }
        }
    }
    
    
    // Mark: Swipe For More Action
    
     func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // Delete Button
        let deleteaction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action,indexPath) -> Void in
            let warningMenu = UIAlertController(title: "Warning", message: "Would you like to permanently delete this camera.", preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {(action) -> Void in
                if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                    let context = appDelegate.persistentContainer.viewContext
                    let cameraToDelete = self.fetchResultController.object(at: indexPath)
                    context.delete(cameraToDelete)
                    appDelegate.saveContext()
                }
            })
            
            warningMenu.addAction(cancelAction)
            warningMenu.addAction(deleteAction)
            self.present(warningMenu,animated: true,completion: nil)
            
         })
        // Edit Button
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: {(action,indexPath) -> Void in
            let cell = tableView.cellForRow(at: indexPath)
            self.performSegue(withIdentifier: "cameraEditView", sender: cell)
        })
        editAction.backgroundColor = UIColor(red: 48.0/255.0,green: 173.0/255.0,blue: 99.0/255.0,alpha:  1.0) 

        return [deleteaction,editAction]
    }
    
   
   

}
