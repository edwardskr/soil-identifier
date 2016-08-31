//
//  SoilsTableViewController.swift
//  Soil Identifier
//
//  Created by Keith Edwards on 2015-03-22.
//  Copyright (c) 2015 Keith Edwards. All rights reserved.
//

import UIKit

class SoilsTableViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    private var SoilsDict: [String: [String]]!
    private var SoilsList: [String]!
    
    private let SoilsCell = "SoilsCell"
    var SCA: String!
    var searchActive: Bool = false
    
    var filter: Bool = false
    var filterDict: [String:[String]]!
    
    private var filteredSoilsList: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        if !filter {
            SoilsDict = SoilsModel.sharedSoilsModel.getSoilsForSCA(SCA)
            SoilsList = sorted(SoilsDict.keys) as [String]
        } else {
            if filterDict.isEmpty {
                SoilsDict = SoilsModel.sharedSoilsModel.soils
                SoilsList = sorted(SoilsDict.keys) as [String]
            } else {
                SoilsDict = SoilsModel.sharedSoilsModel.getFilteredSoils(filterDict)
                SoilsList = sorted(SoilsDict.keys) as [String]
            }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if !searchBar.text.isEmpty && filteredSoilsList.count != 0 {
            searchActive = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Searching
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive=false
    }
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true
    }
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredSoilsList = SoilsList.filter({ (text) -> Bool in
            let tmp: NSString = text
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        
        if(filteredSoilsList.count == 0 && searchText==""){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

 
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if searchActive {
            return filteredSoilsList.count
        }
        return SoilsList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(SoilsCell, forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        if searchActive && !searchBar.text.isEmpty {
            cell.textLabel?.text = filteredSoilsList[indexPath.row]
            cell.detailTextLabel?.text = "\((SoilsDict[filteredSoilsList[indexPath.row]])![0]) (\((SoilsDict[filteredSoilsList[indexPath.row]])![6]))"
        } else {
            cell.textLabel?.text = SoilsList[indexPath.row]
            let soilsym = (SoilsDict[SoilsList[indexPath.row]])![0]
            let soilsg = (SoilsDict[SoilsList[indexPath.row]])![6]
            if let sg = SoilsModel.sharedSoilsModel.getSG(soilsg) {
                cell.detailTextLabel?.text = "\(soilsym) (\(sg))"
            } else {
                cell.detailTextLabel?.text = "\(soilsym)"
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        let tableViewCell = sender as UITableViewCell
        let indexPath = tableView.indexPathForCell(tableViewCell)!
        
        var soil = ""
        if searchActive && filteredSoilsList != nil && !filteredSoilsList.isEmpty {
            soil = filteredSoilsList[indexPath.row]
        } else {
            soil = SoilsList[indexPath.row]
        }
        
        let SoilInfoVC = segue.destinationViewController as SoilInfoViewController
        SoilInfoVC.soil = soil
        SoilInfoVC.navigationItem.title = tableViewCell.textLabel?.text
        
        //searchActive = false
        //self.tableView.reloadData()
    }


}
