//
//  EditCameraTableViewController.swift
//  ONVIF-LiveFeed
//
//  Created by Jeel Shah on 01/06/18.
//  Copyright © 2018 Jeel Shah. All rights reserved.
//

import UIKit
import CoreData
import ONVIFCamera

class EditCameraTableViewController: UITableViewController {

    
    @IBOutlet weak var EpasswordTextField: UITextField!
    @IBOutlet weak var EipAddressTextField: UITextField!
    @IBOutlet weak var EusernameTextField: UITextField!
    @IBOutlet weak var EportnoTextField: UITextField!
    @IBOutlet weak var EcameranameTextField: UITextField!
    
   
    var camera: Camera!
    var location: LocationMO!

    override func viewDidLoad() {
        super.viewDidLoad()

       tableView.tableFooterView = UIView(frame: CGRect.zero)
    
        EusernameTextField.text = camera.userName
        EportnoTextField.text = camera.portNo
        EcameranameTextField.text = camera.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }
    
    @IBAction func updateButtonWasPressed(_ sender: Any) {
        if EusernameTextField.text == "" || EipAddressTextField.text == "" || EpasswordTextField.text == "" || EcameranameTextField.text == "" {
            let alertController = UIAlertController(title: "Oops", message: "Note all the fields are necessary to proceed.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            
            return
        } else {
                camera.password = EpasswordTextField.text
                camera.name = EcameranameTextField.text
                camera.portNo = EportnoTextField.text
                camera.userName = EusernameTextField.text
            
            if EportnoTextField.text != "" {
                camera.portNo = EportnoTextField.text
                camera.ipAddress = EipAddressTextField.text! + ":" + EportnoTextField.text!
            } else {
                camera.ipAddress = EipAddressTextField.text
            }
            
            let cam = ONVIFCamera(with: camera.ipAddress!, credential: (login: EusernameTextField.text, password: EpasswordTextField.text) as? (login: String, password: String),soapLicenseKey:"nU8Yi3Turrn42DmbDIelGDPvYzatf4ZJTE6SF2GwHtZFcaGzSM+JxCE+YyK7M69KOo58YsA4scb/WqeaKklRgA==")
            cam.getServices {
                cam.getCameraInformation(callback: {(trycamera) in
                    print(trycamera.manufacturer!)
                    print(trycamera.model!)
                    self.camera.manufacturer = trycamera.manufacturer
                    print(self.camera.manufacturer!)
                    self.camera.modelno = trycamera.model
                }, error: {(error) in
                    print("Couldn't connect to camera: \(error)")
                })
            }
            
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {                                appDelegate.saveContext()
            }
            tableView.reloadData()
            
                }
                dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
