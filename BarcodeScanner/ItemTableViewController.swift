//
//  ItemTableViewController.swift
//  BarcodeScanner
//
//  Created by Amelia Delzell on 4/16/17.
//  Copyright © 2017 Amelia Delzell. All rights reserved.
//

import UIKit
import os.log

class ItemTableViewController: UITableViewController, DataServiceProtocol {
    
    //MARK: Properties
    
    
    var feedItems: NSArray = NSArray()
    var scannedItem: Item = Item()
    var price: Double = Double()
    var didCheckOutofStock = false
    
    @IBOutlet weak var totalPrice: UILabel!
    var items = [Item]()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let databaseRetrieval = DatabaseRetrieval()
        databaseRetrieval.delegate1 = self
        print(databaseRetrieval.delegate1)
        databaseRetrieval.downloadItems()
        
        totalPrice.text = "   Total Cost:"
        
        
        
        // Load any saved items, otherwise load sample data.
        if let savedItems = loadItems() {
            items += savedItems
            setPrice()
            //isOutofStock(index: 0)
        }
//        else {
//            // Load the sample data.
//            loadSampleItems()
//        }
        
        
//                NotificationCenter.default.addObserver(self, selector: #selector(ItemTableViewController.saveItems), name: NSNotification.Name(rawValue: "ProductNotification"), object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (!didCheckOutofStock){
        isOutofStock(index: 0)
        didCheckOutofStock = true
        }
    }
    
    func isOutofStock(index: Int) {
        if items.count > 0 {
            let stock = DataService.getStock(name: items[index].name!)
            if (Int(stock) == 0){
                let alert = UIAlertController(title: " Item out of stock!", message: items[index].name!, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK!", style: UIAlertActionStyle.default, handler: { action in
                    if (index + 1 < self.items.count){
                        self.isOutofStock(index: index + 1)
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            }
            else if (Int(stock) == 1) {
                let alert = UIAlertController(title: "Only one more remaining!", message: items[index].name!, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK!", style: UIAlertActionStyle.default, handler: { action in
                    if (index + 1 < self.items.count){
                        self.isOutofStock(index: index + 1)
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            }
            else{
                if (index + 1 < self.items.count){
                    self.isOutofStock(index: index + 1)
                }
            }
        }
    }
    
    func setPrice() {
        price = 0.00
        if items.count > 0{
        for i in 0 ..< items.count{
            price += Double(items[i].price!)!
        }
        price = Double(round(100*price)/100)
        print(price)
        }
        totalPrice.text = "  Total Cost: $" + String(price)
    }
    
    
    func reload(){
        let databaseRetrieval = DatabaseRetrieval()
        databaseRetrieval.delegate1 = self
        print(databaseRetrieval.delegate1)
        databaseRetrieval.downloadItems()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func itemsDownloaded(items: NSArray) {
        feedItems = items
        DataService.itemsReceived(items: items)
        ManualSearchViewController.itemsReceived(items: items)
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ItemTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ItemTableViewCell else{
            fatalError("The dequeued cell is not an instance of ItemTableViewCell.")
        }
        
        //Fetches the appropriate item for the data source layout.
        let item = items[indexPath.row]
        
        cell.selectionStyle = UITableViewCellSelectionStyle(rawValue: 0)!
        
        cell.name.text = item.name
        cell.photo.image = item.photo
        cell.price.text = item.price
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    //     Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            items.remove(at: indexPath.row)
            setPrice()
            saveItems()
            //Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } //else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        //}
    }
    
    
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
    
    
    //MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            if #available(iOS 10.0, *) {
                os_log("Adding a new item.", log: OSLog.default, type: .debug)
            } else {
                // Fallback on earlier versions
            }
        case "ViewFavorites":
            if #available(iOS 10.0, *) {
                os_log("Adding a new item.", log: OSLog.default, type: .debug)
            } else {
                // Fallback on earlier versions
            }
        case "AddFavorites":
            if #available(iOS 10.0, *) {
                os_log("Adding a new item.", log: OSLog.default, type: .debug)
            } else {
                // Fallback on earlier versions
            }
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    //MARK: Actions
    
    @IBAction func unwindToItemList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? SetStockViewController, let item = sourceViewController.item {
                // Add a new item.
                let newIndexPath = IndexPath(row: items.count, section: 0)
                
                //items += [item!]
                items.append(item)
                //^instead of this line, they said: meals.append(meal)
                
                tableView.insertRows(at: [newIndexPath], with: .automatic)

            
            // Save the items.
            setPrice()
            saveItems()
            
            print(Int(item.stock!)!)
            
            let when = DispatchTime.now() + 0.5 // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
            if (Int(item.stock!) == -1){
                let stock = DataService.getStock(name: item.name!)
                if (Int(stock)! == 0){
                let alert = UIAlertController(title: "Item out of stock!", message: item.name, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK!", style: UIAlertActionStyle.default, handler: nil))
                 self.present(alert, animated: true, completion: nil)
                }
                }
            }
        }
    }
    
        private func saveItems() {
            let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(items, toFile: Item.ArchiveURL.path)
            if isSuccessfulSave {
                if #available(iOS 10.0, *) {
                    os_log("Items successfully saved.", log: OSLog.default, type: .debug)
                } else {
                    // Fallback on earlier versions
                }
            } else {
                if #available(iOS 10.0, *) {
                    os_log("Failed to save items...", log: OSLog.default, type: .error)
                } else {
                    // Fallback on earlier versions
                }
            }
        }
    
    private func loadItems() -> [Item]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Item.ArchiveURL.path) as? [Item]
    }
}
