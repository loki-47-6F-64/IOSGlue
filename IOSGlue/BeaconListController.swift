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
    
    var blueView : uBlueViewMainCallback?
    var beaconList : [uBlueBeacon] = []
    
    @IBOutlet weak var scanButton: UIButton!
    
    @IBAction func scanButtonClicked(_ sender: Any) {
        BeaconListController.isScanning = !BeaconListController.isScanning
        
        blueView?.onToggleScan(BeaconListController.isScanning)
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
    
    private func indexOf(uuid : String) -> Int {
        if(beaconList.count == 0) {
            return -1
        }
        
        for i in 0 ... beaconList.count - 1 {
            if(beaconList[i].uuid == uuid) {
                return i
            }
        }
        
        return -1
    }
    
    func beaconListUpdate(_ beacon: uBlueBeacon) {
        let i = indexOf(uuid: beacon.uuid)
        
        if(i == -1) {
            beaconList.append(beacon)
            DispatchQueue.main.async {
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: [IndexPath(row: self.beaconList.count - 1, section: 0)], with: UITableViewRowAnimation.automatic)
                self.tableView.endUpdates()
            }
        }
        else {
            beaconList[i] = beacon
            
            DispatchQueue.main.async {
                self.tableView.beginUpdates()
                self.tableView.reloadRows(at: [IndexPath(row: i, section: 0)], with: UITableViewRowAnimation.automatic)
                self.tableView.endUpdates()
            }
        }
    }
    
    func beaconListRemove(_ beacon: uBlueBeacon) {
        let i = indexOf(uuid: beacon.uuid)
        
        if(i != -1) {
            beaconList.remove(at: i)
            
            DispatchQueue.main.async {
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: [IndexPath(row: i, section: 0)], with: UITableViewRowAnimation.automatic)
                self.tableView.endUpdates()
            }
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

        blueView = SuperGlueBluecast.bluetooth!.blueCallback?
            .onCreateMain(self, permissionManager: PermImpl())
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
        return beaconList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BeaconListController.uniqueId, for: indexPath)

        let beacon = beaconList[indexPath.row]
        cell.textLabel!.text = beacon.uuid
        
        return cell
    }

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
