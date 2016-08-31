//
//  SubgroupViewController.swift
//  Soil Identifier
//
//  Created by Keith Edwards on 2015-03-23.
//  Copyright (c) 2015 Keith Edwards. All rights reserved.
//

import UIKit

class SubgroupViewController: UITableViewController {
    
    private var orderList: [String]!
    private var imageList: [String: String] = ["Soil Structure":"fig43.png"]
    
    var level: Int = 1
    var item: String!
    var parentitem: String!
    var grandparentitem: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        if level == 1 {
            orderList = sorted(SoilInfoModel.sharedSoilInfoModel.soilInfo.keys.array)
        } else if level == 2 {
            orderList = sorted(SoilInfoModel.sharedSoilInfoModel.soilInfo[self.item]!.keys.array)
        } else if level == 3 {
            orderList = sorted(SoilInfoModel.sharedSoilInfoModel.soilInfo[self.parentitem]![self.item]!.keys.array)
            if let idx = find(orderList, "Description") {
                orderList.removeAtIndex(idx)
            }
        } else if level == 4 {
            orderList = []
        } else {
            orderList = []
        }
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
        if level == 1 || level == 3 || level == 4 {
            return 2
        } else {
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if level == 4 {
            if section == 0 {
                return "Name"
            } else {
                return "Description"
            }
        }
        if level == 3 {
            if section == 0 {
                return "Description"
            } else {
                return "Subgroups"
            }
        }
        if level == 2 {
            return "Great Groups"
        }
        if level == 1 {
            if section == 0 {
                return "Orders"
            } else {
                return "Reference"
            }
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if level == 3 {
            if section == 0 {
                return 1
            } else {
                return orderList.count
            }
        } else if level == 4{
            return 1
        } else {
            if section == 0 {
                return orderList.count
            } else {
                return imageList.count
            }
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if level == 1  || level == 2{
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("SoilCell", forIndexPath: indexPath) as UITableViewCell
                
                // Configure the cell...
                cell.textLabel?.text = orderList[indexPath.row]
                
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as UITableViewCell
                
                cell.textLabel?.text = imageList.keys.array[indexPath.row]
                
                return cell
            }
        } else if level == 3 {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("DescriptionCell", forIndexPath: indexPath) as UITableViewCell
                
                // Configure the cell...
                
                cell.textLabel?.text = SoilInfoModel.sharedSoilInfoModel.soilInfo[self.parentitem]![self.item]!["Description"]![0]
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("DetailCell", forIndexPath: indexPath) as UITableViewCell
                
                // Configure the cell...
                cell.textLabel?.text = orderList[indexPath.row]
                cell.detailTextLabel?.text = SoilInfoModel.sharedSoilInfoModel.soilInfo[self.parentitem]![self.item]![orderList[indexPath.row]]![0]
                
                return cell
            }
            
        } else if level == 4 {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("SoilCell", forIndexPath: indexPath) as UITableViewCell
                
                // Configure the cell...
                cell.textLabel?.text = SoilInfoModel.sharedSoilInfoModel.soilInfo[self.grandparentitem]![self.parentitem]![self.item]![0]
                cell.accessoryType = UITableViewCellAccessoryType.None
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("DescriptionCell", forIndexPath: indexPath) as UITableViewCell
                
                // Configure the cell...
                
                cell.textLabel?.text = SoilInfoModel.sharedSoilInfoModel.soilInfo[self.grandparentitem]![self.parentitem]![self.item]![1]
                
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("DetailCell", forIndexPath: indexPath) as UITableViewCell
            
            // Configure the cell...
            cell.textLabel?.text = orderList[indexPath.row]
            //cell.detailTextLabel?.text = SoilInfoModel.sharedSoilInfoModel.soilInfo[self.item]![orderList[indexPath.row]]![0]
            
            return cell
        }
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if level == 1 && indexPath.section == 1 {
            return
        }
        if !(level == 3 && indexPath.section == 0) && level != 4{
            let svc = self.storyboard?.instantiateViewControllerWithIdentifier("SubgroupViewController") as SubgroupViewController
            svc.level = self.level + 1
            svc.item = orderList[indexPath.row]
            if self.level == 2 {
                svc.parentitem = self.item
            }
            if self.level == 3 {
                svc.parentitem = self.item
                svc.grandparentitem = self.parentitem
            }
            svc.navigationItem.title = orderList[indexPath.row]
            self.navigationController?.pushViewController(svc, animated: true)
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
        if segue.identifier == "Image" {

            
            let tableViewCell = sender as UITableViewCell
            let imageText = tableViewCell.textLabel?.text
            
            let image = imageList[imageText!]
            
            let ImageVC = segue.destinationViewController as ImageViewController
            ImageVC.imageName = image
            
            ImageVC.navigationItem.title = imageText!
        
            
        }
    
    }
    
    
}
