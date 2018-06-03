//
//  LiveCameraViewController.swift
//  ONVIF-LiveFeed
//
//  Created by Jeel Shah on 31/05/18.
//  Copyright © 2018 Jeel Shah. All rights reserved.
//

import UIKit
import ONVIFCamera

class LiveCameraViewController: UIViewController {

    @IBAction func crossButtonWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var movieView: UIView!
    var onvifCamera: ONVIFCamera!
    var credi: String!
    let mediaPlayer = VLCMediaPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.onvifCamera.getServices {
            self.onvifCamera.getCameraInformation(callback: {(camera) in
                print(camera.manufacturer!)
                print(camera.model!)
            }, error: {(error) in
                print("Couldn't connect to camera: \(error)")
            })
            self.onvifCamera.getProfiles(profiles: {(profiles) in
                print("profiles \(profiles)")
                self.onvifCamera.getStreamURI(with: profiles.first!.token, uri: {(uri) in
                    print("uri: \(uri)")
                    let newuri = uri.prefix(7) + self.credi
                    let nuri = String(newuri + uri.dropFirst(7))
                    print("uri: \(nuri)")
                    self.playURI(uri: nuri)
                })
            })
        }

        // Do any additional setup after loading the view.
    }
    func playURI(uri:String) {
        mediaPlayer.drawable = self.movieView
        let url = URL(string: uri)
        let media = VLCMedia(url: url!)
        mediaPlayer.media = media
        
        mediaPlayer.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
