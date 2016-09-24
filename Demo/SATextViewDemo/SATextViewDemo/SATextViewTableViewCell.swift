//
//  SATextViewTableViewCell.swift
//  SATextViewDemo
//
//  Created by Michael Schmidt on 9/24/16.
//  Copyright © 2016 SchmidtyApps. All rights reserved.
//

import UIKit

class SATextViewTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var textView: SATextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.addBorder()
    }

}
