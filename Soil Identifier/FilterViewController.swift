//
//  FilterViewController.swift
//  Soil Identifier
//
//  Created by Keith Edwards on 2015-03-23.
//  Copyright (c) 2015 Keith Edwards. All rights reserved.
//

import UIKit

class FilterViewController: UITableViewController, FilterSelectionViewControllerDelegate {

    
    var filters:[String] = ["Soil Correlation Area","Calcareousness","Parent Material (1)","Parent Material (2)","Soil Order","Soil Subgroup"]
    var filterSettings:[String:[String]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    @IBAction func resetButton(sender: AnyObject) {
        filterSettings = [:]
        tableView.reloadData()
/*
        let app = UIApplication.sharedApplication()
        
        app.openURL(NSURL(string: "sonos:")!)*/
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func filterSettingSet(controller: FilterSelectionViewController, filter: String, filterSetting: [String]?) {
        if let filterS = filterSetting {
            filterSettings[filter] = filterS
        } else {
            filterSettings.removeValueForKey(filter)
        }
        //controller.navigationController?.popViewControllerAnimated(true)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section==0 {
            return filters.count
        } else {
            return 1
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
        let cell = tableView.dequeueReusableCellWithIdentifier("FilterCell", forIndexPath: indexPath) as UITableViewCell

        cell.textLabel?.text = filters[indexPath.row]
        if let detail = filterSettings[filters[indexPath.row]] {
            cell.detailTextLabel?.text = ", ".join(detail)
        } else {
            cell.detailTextLabel?.text = "Any"
        }

            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("SearchCell", forIndexPath: indexPath) as UITableViewCell
            cell.textLabel?.text = "Apply"
            cell.textLabel?.textAlignment = NSTextAlignment.Center
            cell.textLabel?.textColor = self.view.tintColor
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //if section == 0 {
        //    return "Filter Settings"
        //}
        return nil
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
     
        if segue.identifier == "Filter" {
            
            let tableViewCell = sender as UITableViewCell
            let indexPath = tableView.indexPathForCell(tableViewCell)!
            
            let filter = filters[indexPath.row]
            let filterSetting = filterSettings[filters[indexPath.row]]
            
            let FilterSelectionVC = segue.destinationViewController as FilterSelectionViewController
            FilterSelectionVC.filter = filter
            FilterSelectionVC.filterSetting = filterSetting
            FilterSelectionVC.navigationItem.title = filter
            
            FilterSelectionVC.delegate = self
        } else {
            let SoilsTableVC = segue.destinationViewController as SoilsTableViewController
            SoilsTableVC.filter = true
            SoilsTableVC.filterDict = filterSettings
            SoilsTableVC.navigationItem.title = "Results" 
        }
    }
    

}
