//
//  BeaconListController.swift
//  IOSGlue
//
//  Created by Petra Farber on 22-09-18.
//  Copyright © 2018 Loki. All rights reserved.
//

import UIKit
import CoreBluetooth

import Common
import Bluecast

class BeaconListController: UITableViewController, uBlueViewMainController {
    static let uniqueId = "BeaconListController"
    
    static var isScanning = false
    
    var blueCallback : uBlueCallback?
    var devices : [uBlueDevice] = []
    
    @IBOutlet weak var scanButton: UIButton!
    
    @IBAction func scanButtonClicked(_ sender: Any) {
        BeaconListController.isScanning = !BeaconListController.isScanning
        
        blueCallback!.onBeaconScanEnable(BeaconListController.isScanning)
    }
    
    // turn on/off bluetooth
    func blueEnable(_ enable: Bool) {
        if(enable && CBCentralManager().state != CBManagerState.poweredOn) {
            UIAlertController(
                title: "Bluetooth",
                message: "Please turn bluetooth on",
                preferredStyle: UIAlertControllerStyle.alert).show(self, sender: nil)
        }
    }
    
    func setDeviceList(_ devices: [uBlueDevice]) {
        DispatchQueue.main.async {
            self.devices = devices
            self.tableView.reloadData()
        }
    }
    
    func launchViewDisplay(_ device: uBlueDevice) {
        
        DispatchQueue.main.async {
            let nav = UIApplication.shared.keyWindow!.rootViewController! as! UINavigationController
            
            let view = self.storyboard!.instantiateViewController(withIdentifier: "DisplayInfoController") as! DisplayInfoViewController
            view.device = device
            nav.pushViewController(view, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        blueCallback = SuperGlueBluecast.bluetooth!.blueCallback
        blueCallback!.onCreateMain(self, permissionManager: PermImpl())
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devices.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BeaconListController.uniqueId, for: indexPath)

        let device = devices[indexPath.row]
        cell.textLabel!.text = device.address
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)!
        
        let device = uBlueDevice(name: nil, address: cell.textLabel!.text!)
        
        blueCallback!.onSelect(device)
    }
}
