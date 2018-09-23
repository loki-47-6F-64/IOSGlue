//
//  DisplayInfoViewController.swift
//  IOSGlue
//
//  Created by Petra Farber on 23-09-18.
//  Copyright © 2018 Loki. All rights reserved.
//

import UIKit

import Bluecast

class DisplayInfoViewController: UIViewController, uBlueViewDisplayController {
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelUUID: UILabel!
    @IBOutlet weak var displayInfo: UILabel!
  
    var device : uBlueDevice?
    
    func display(_ device: uBlueDevice, info: String) {
        labelName.text = device.name
        labelUUID.text = device.address
        
        displayInfo.text = info
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        SuperGlueBluecast.bluetooth!.blueCallback!.onCreateDisplay(device!, blueView: self)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        SuperGlueBluecast.bluetooth!.blueCallback!.onDestroyDisplay()
        
        super.viewWillDisappear(animated)
    }
}
