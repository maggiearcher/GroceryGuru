//
//  DataService.swift
//  BarcodeScanner
//
//  Created by Amelia Delzell on 3/26/17.
//  Copyright © 2017 Amelia Delzell. All rights reserved.
//

import Foundation
import UIKit

import Foundation
import UIKit

class DataService {
    
    static let dataService = DataService()
    static var database = NSArray()
    var feedItems: NSArray = NSArray()
    var scannedItem: Item = Item()
    
    private(set) var NAME_OF_FOOD = " "
    private(set) var PRICE_OF_FOOD = " "
    private(set) var STOCK_OF_FOOD = " "
    private(set) var IMAGE = UIImage()
    private(set) var UPC = " "
    static var foundUPC = false
    static func itemsReceived(items: NSArray) {
        print("data service reload")
        self.database = items
    }
    
    
    static func searchAPI(codeNumber: String){
        foundUPC = false
        if database.count != 0 {
        for i in 0 ..< database.count{
            if((database[i] as! Item).UPC == codeNumber){
                self.dataService.UPC = (database[i] as! Item).UPC!
                self.dataService.NAME_OF_FOOD = (database[i] as! Item).name!
                self.dataService.PRICE_OF_FOOD = (database[i] as! Item).price!
                self.dataService.STOCK_OF_FOOD = (database[i] as! Item).stock!
                foundUPC = true
            }
        }
            if (foundUPC == false){
                self.dataService.UPC = " "
                self.dataService.NAME_OF_FOOD = " "
                self.dataService.PRICE_OF_FOOD = " "
                self.dataService.STOCK_OF_FOOD = " "
                
            }
           
        }
//
//        self.dataService.NAME_OF_FOOD = "hello"
//        self.dataService.PRICE_OF_FOOD = "$2.00"
//        self.dataService.STOCK_OF_FOOD = 0
        
        let data = codeNumber.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.applying(transform) {
                self.dataService.IMAGE = UIImage(ciImage: output)
                
            }
            
            //}
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ProductNotification"), object: nil)
        //
        //    static func generateBarcode(string: String){
        //        let data = string.data(using: String.Encoding.ascii)
        //
        //        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
        //            filter.setValue(data, forKey: "inputMessage")
        //            let transform = CGAffineTransform(scaleX: 3, y: 3)
        //
        //            if let output = filter.outputImage?.applying(transform) {
        //                self.dataService.IMAGE = UIImage(ciImage: output)
        //
        //        }
        
    }
    
    static func searchAPI(name: String){
        var codeNumber = " "
        if database.count != 0 {
            for i in 0 ..< database.count{
                if((database[i] as! Item).name == name){
                    self.dataService.UPC = (database[i] as! Item).UPC!
                    self.dataService.NAME_OF_FOOD = (database[i] as! Item).name!
                    self.dataService.PRICE_OF_FOOD = (database[i] as! Item).price!
                    self.dataService.STOCK_OF_FOOD = (database[i] as! Item).stock!
                    codeNumber = (database[i] as! Item).UPC!
                }
            }
        }
        
        let data = codeNumber.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.applying(transform) {
                self.dataService.IMAGE = UIImage(ciImage: output)
                
            }
            
            //}
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ProductNotification"), object: nil)
        
    }
    
    static func getStock(name: String) -> String {
        var thisStock = " "
        if database.count != 0{
        for i in 0 ..< database.count{
            if((database[i] as! Item).name == name){
                thisStock = (database[i] as! Item).stock!
            }
            }
        }
        return thisStock
    }
    
}
