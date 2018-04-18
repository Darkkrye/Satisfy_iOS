//
//  LaunchViewController.swift
//  Satisfy
//
//  Created by Pierre on 17/04/2018.
//  Copyright © 2018 boudonpierre. All rights reserved.
//

import UIKit
import SwiftGifOrigin
import SwiftyJSON

class LaunchViewController: UIViewController {
    
    
    @IBOutlet weak var loadGifImage: UIImageView!
    var am = APIManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.am.delegate = self

        // Do any additional setup after loading the view.
        self.loadGifImage.loadGif(name: "46M68")
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.am.getInfos()
        }
    }
}

extension LaunchViewController: APIManagerDelegate {
    func getCallback(statusCode: Int, data: Data) {
        if statusCode == 200 {
            let json = try? JSON(data: data)
            let pod = Pod()
            
            for j in json! {
                pod.satisfactions.append(Satisfaction(json: j.1))
            }
            
            self.am.vm.pods.append(pod)
            
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: "launchSegue", sender: nil)
            }
        }
    }
}
