//
//  CustomTableViewController.swift
//  TableExample
//
//  Created by Ryan Mathews on 3/24/16.
//  Copyright © 2016 OrangeQC. All rights reserved.
//

import UIKit

class CustomTableViewController: UITableViewController, UISearchResultsUpdating {
    var tableData = ["Few + automaticDimension", "Many + automaticDimension", "Few w/o automaticDimension (doesn't work)", "Many w/o automaticDimension", "-----", "This is really long text that should be wrapping. In a custom cell, it could. But it doesn't always, based on the estimatedRowHeight setting.", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]

    var useAutomaticDimension = false

    var filteredData:[String] = []
    var resultSearchController = UISearchController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Custom + \(useAutomaticDimension ? "w/ automatic" : "w/o automatic")"

        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)

            controller.searchResultsUpdater = self
            controller.obscuresBackgroundDuringPresentation = false

            controller.searchBar.sizeToFit()

            self.tableView.tableHeaderView = controller.searchBar
            self.tableView.contentOffset = CGPointMake(0, CGRectGetHeight(controller.searchBar.frame))

            return controller
        })()

        self.definesPresentationContext = true

        self.tableView.rowHeight = UITableViewAutomaticDimension

        /*
         Code used to switch between UITableViewAutomaticDimension and a fixed estimatedRowHeight
         */
        if useAutomaticDimension {
            self.tableView.estimatedRowHeight = UITableViewAutomaticDimension
        }
        else {
            self.tableView.estimatedRowHeight = 100.0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if resultSearchController.active {
            return filteredData.count
        }
        else {
            return tableData.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("CustomCell", forIndexPath: indexPath)

        let textLabel = cell.viewWithTag(5) as! UILabel
        if resultSearchController.active {
            textLabel.text = filteredData[indexPath.row]
        }
        else {
            textLabel.text = tableData[indexPath.row]
        }

        return cell
    }

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filteredData.removeAll(keepCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (tableData as NSArray).filteredArrayUsingPredicate(searchPredicate)
        filteredData = array as! [String]
        tableView.reloadData()
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc: CustomTableViewController = storyBoard.instantiateViewControllerWithIdentifier("CustomTableViewController") as! CustomTableViewController

        // We'll use automaticDimension if you select one of the first two
        if indexPath.row < 2 {
            vc.useAutomaticDimension = true
        }

        // If you select "few" we'll rewrite the data to only have a few items
        if indexPath.row == 0 || indexPath.row == 2 {
            vc.tableData = Array(tableData.prefix(6))
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}