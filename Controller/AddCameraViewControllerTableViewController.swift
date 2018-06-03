//
//  AddCameraViewControllerTableViewController.swift
//  ONVIF-LiveFeed
//
//  Created by Jeel Shah on 26/05/18.
//  Copyright © 2018 Jeel Shah. All rights reserved.
//

import UIKit
import CoreData
import ONVIFCamera

class AddCameraViewControllerTableViewController: UITableViewController {

    var camera: Camera!
    var location: LocationMO!

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var ipAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var portnoTextField: UITextField!
    @IBOutlet weak var cameraNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        view.addDoneButtonToKeyboard(textField: userNameTextField)
        view.addDoneButtonToKeyboard(textField: ipAddressTextField)
        view.addDoneButtonToKeyboard(textField: passwordTextField)
        view.addDoneButtonToKeyboard(textField: portnoTextField)
        view.addDoneButtonToKeyboard(textField: cameraNameTextField)
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

   
    @IBAction func saveButtonWasPressed(_ sender: Any) {
        if userNameTextField.text == "" || ipAddressTextField.text == "" || passwordTextField.text == "" || cameraNameTextField.text == "" {
            let alertController = UIAlertController(title: "Oops", message: "Note all the fields are necessary to proceed.", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
            
            return
        } else {
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                camera = Camera(context: appDelegate.persistentContainer.viewContext)
                camera.userName = userNameTextField.text
                camera.password = passwordTextField.text
                camera.name = cameraNameTextField.text
                camera.location = location
                if portnoTextField.text != "" {
                    camera.portNo = portnoTextField.text
                    camera.ipAddress = ipAddressTextField.text! + ":" + portnoTextField.text!
                } else {
                    camera.ipAddress = ipAddressTextField.text
                }
                let cam = ONVIFCamera(with: camera.ipAddress!, credential: (login: userNameTextField.text, password: passwordTextField.text) as? (login: String, password: String),soapLicenseKey:"nU8Yi3Turrn42DmbDIelGDPvYzatf4ZJTE6SF2GwHtZFcaGzSM+JxCE+YyK7M69KOo58YsA4scb/WqeaKklRgA==")
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
                print("Saving data to context ...")
                appDelegate.saveContext()
            }
            dismiss(animated: true, completion: nil)
        }
    }
    }
    
    @IBAction func cancelButtonWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
   

}
