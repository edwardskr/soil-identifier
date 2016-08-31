//
//  SoilInfoViewController.swift
//  Soil Identifier
//
//  Created by Keith Edwards on 2015-03-22.
//  Copyright (c) 2015 Keith Edwards. All rights reserved.
//

import UIKit

class SoilInfoViewController: UITableViewController {

    var soil: String!
    let SoilCell = "SoilCell"
    let sections = [
        "Soil Series","Soil Correlation Area","Calcareousness","Parent Material (1)","Parent Material (2)","Soil Order","Soil Subgroup","Soil Correlator Notes","My Notes","My Photos"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return sections.count
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        if sections[indexPath.section] == "My Notes"{
            let cell = tableView.dequeueReusableCellWithIdentifier("NoteCell", forIndexPath: indexPath) as UITableViewCell
            if NotesModel.sharedNotesModel.notes[soil] == nil{
                cell.textLabel?.text = "Add Notes"
                cell.textLabel?.font = UIFont.italicSystemFontOfSize(UIFont.systemFontSize())
            } else {
                if NotesModel.sharedNotesModel.notes[soil] == "" {
                    cell.textLabel?.text = "Add Notes"
                    cell.textLabel?.font = UIFont.italicSystemFontOfSize(UIFont.systemFontSize())
                } else {
                    cell.textLabel?.text = NotesModel.sharedNotesModel.notes[soil]
                    cell.textLabel?.font = UIFont.systemFontOfSize(UIFont.systemFontSize())
                }
            }
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            return cell
            
        } else if sections[indexPath.section] == "My Photos" {
            let cell = tableView.dequeueReusableCellWithIdentifier("PhotoCell", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = "View"
            if let c = PhotosModel.sharedPhotosModel.photos[soil]?.count {
                cell.detailTextLabel?.text = "\(c)"
            } else {
                cell.detailTextLabel?.text = "0"
            }
            return cell
        }else {
            let cell = tableView.dequeueReusableCellWithIdentifier(SoilCell, forIndexPath: indexPath) as UITableViewCell
            if indexPath.section==2 {
                cell.textLabel?.text = SoilsModel.sharedSoilsModel.getCalc((SoilsModel.sharedSoilsModel.soils[soil])![indexPath.section])
            } else if indexPath.section==5 {
                cell.textLabel?.text = SoilsModel.sharedSoilsModel.getOrder((SoilsModel.sharedSoilsModel.soils[soil])![indexPath.section])
            } else if indexPath.section==6 {
                cell.textLabel?.text = SoilsModel.sharedSoilsModel.getSG((SoilsModel.sharedSoilsModel.soils[soil])![indexPath.section])
            } else if indexPath.section==3 || indexPath.section==4 {
                if let pmx = SoilsModel.sharedSoilsModel.getPM(SoilsModel.sharedSoilsModel.soils[soil]![indexPath.section]) {
                    cell.textLabel?.text = "\((SoilsModel.sharedSoilsModel.soils[soil])![indexPath.section]) - \(SoilsModel.sharedSoilsModel.getPM((SoilsModel.sharedSoilsModel.soils[soil])![indexPath.section])!)"
                } else {
                    cell.textLabel?.text = nil
                }
            } else {
                cell.textLabel?.text = (SoilsModel.sharedSoilsModel.soils[soil])![indexPath.section]
            }
            return cell
        }
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "Notes"{
            let NotesEditVC = segue.destinationViewController as NotesEditViewController
            NotesEditVC.soil = soil
            NotesEditVC.navigationItem.title = "Edit Notes"
        }
        if segue.identifier == "Photos" {
            let SoilPhotoVC = segue.destinationViewController as SoilPhotoCollectionViewController
            SoilPhotoVC.soil = self.soil
            SoilPhotoVC.navigationItem.title = "\(soil) Photos"
        }
    }


}
