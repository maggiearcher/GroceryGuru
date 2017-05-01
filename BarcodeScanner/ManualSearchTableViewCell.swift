//
//  ManualSearchTableViewCell.swift
//  BarcodeScanner
//
//  Created by Amelia Delzell on 4/20/17.
//  Copyright © 2017 Amelia Delzell. All rights reserved.
//

import UIKit


class ManualSearchTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }


}
