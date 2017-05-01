//
//  SearchBarViewController.swift
//  BarcodeScanner
//
//  Created by Amelia Delzell on 4/4/17.
//  Copyright © 2017 Amelia Delzell. All rights reserved.
//

import UIKit
import AVFoundation

class SearchBarTableViewController: UITableViewController {
    @IBOutlet weak var searchbar: UISearchBar!
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
    }
    
    
}

