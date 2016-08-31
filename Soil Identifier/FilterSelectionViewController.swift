//
//  FilterSelectionViewController.swift
//  Soil Identifier
//
//  Created by Keith Edwards on 2015-03-23.
//  Copyright (c) 2015 Keith Edwards. All rights reserved.
//

import UIKit

protocol FilterSelectionViewControllerDelegate {
    func filterSettingSet(controller: FilterSelectionViewController, filter: String, filterSetting: [String]?)
}

class FilterSelectionViewController: UITableViewController {

    var filter:String!
    var filterSetting:[String]?
    var delegate:FilterSelectionViewControllerDelegate? = nil
    
    private var filterSettingList:[String]!
    private var detailFilter = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        if filter == "Soil Correlation Area" {
            filterSettingList = SoilsModel.sharedSoilsModel.getSCAs()
        } else if filter == "Soil Order" {
            filterSettingList = SoilsModel.sharedSoilsModel.getOrders()
            detailFilter = true
        } else if filter == "Calcareousness" {
            filterSettingList = SoilsModel.sharedSoilsModel.getCalcs()
            detailFilter = true
        } else if filter == "Parent Material (1)" {
            filterSettingList = SoilsModel.sharedSoilsModel.getPM1()
            detailFilter = true
        } else if filter == "Parent Material (2)" {
            filterSettingList = SoilsModel.sharedSoilsModel.getPM2()
            detailFilter = true
        } else if filter == "Soil Subgroup" {
            filterSettingList = SoilsModel.sharedSoilsModel.getSGs()
            detailFilter = true
        } else {
            filterSettingList = []
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 0{
            filterSetting = nil
        } else {
            if let f = filterSetting {
                if !contains(f, filterSettingList[indexPath.row]){
                    filterSetting!.append(filterSettingList[indexPath.row])
                } else {
                    if let idx = find(filterSetting!, filterSettingList[indexPath.row]) {
                        filterSetting!.removeAtIndex(idx)
                        if filterSetting!.isEmpty {
                            filterSetting = nil
                        }
                    }
                }
            } else {
                filterSetting = [filterSettingList[indexPath.row]]
            }
        }
        
        if let del = delegate {
            del.filterSettingSet(self, filter: filter, filterSetting: filterSetting?)
        }
        
        tableView.reloadData()
        return indexPath
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
        
        if section==0{
            return 1
        } else {
            return filterSettingList.count
        }
    }

    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var celltype = "FilterSettingCell"
        if detailFilter && indexPath.section == 1{
            celltype = "FilterSettingDetailCell"
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(celltype, forIndexPath: indexPath) as UITableViewCell
        
        cell.accessoryType=UITableViewCellAccessoryType.None

        if indexPath.section == 0 {
            cell.textLabel?.text = "Any"
            if filterSetting == nil {
                cell.accessoryType=UITableViewCellAccessoryType.Checkmark
            }
        } else {
            cell.textLabel?.text = filterSettingList[indexPath.row]
            
            if filter == "Soil Order" {
                cell.detailTextLabel?.text = SoilsModel.sharedSoilsModel.getOrder(filterSettingList[indexPath.row])
            }
            if filter == "Calcareousness" {
                cell.detailTextLabel?.text = SoilsModel.sharedSoilsModel.getCalc(filterSettingList[indexPath.row])
            }
            
            if filter == "Soil Subgroup" {
                cell.detailTextLabel?.text = SoilsModel.sharedSoilsModel.getSG(filterSettingList[indexPath.row])
            }
            
            if filter == "Parent Material (1)" || filter == "Parent Material (2)" {
                cell.detailTextLabel?.text = SoilsModel.sharedSoilsModel.getPM(filterSettingList[indexPath.row])
            }
            
            if let setting = filterSetting {
                if contains(setting, filterSettingList[indexPath.row]) {
                    cell.accessoryType=UITableViewCellAccessoryType.Checkmark
                }
            }
        }

        return cell
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
