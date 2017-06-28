//
//  ViewController.swift
//  SATextViewDemo
//
//  Created by Michael Schmidt on 9/24/16.
//  Copyright © 2016 SchmidtyApps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 60
        
        tableView.tableFooterView = UIView()
    }
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellReuseIdentifier: String = "SATextViewCell"
        
        var cell:SATextViewTableViewCell? = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? SATextViewTableViewCell
        if (cell == nil) {
            var nib: [Any] = Bundle.main.loadNibNamed("SATextViewTableViewCell", owner: self, options: nil)!
            cell = nib[0] as? SATextViewTableViewCell
        }
        
        if let cell = cell {
            cell.textView.delegate = self
            
            switch indexPath.row {
            case 0:
                cell.titleLabel.text = "Name"
                cell.textView.placeholder = "Optional"
            case 1:
                cell.titleLabel.text = "Email"
                cell.textView.placeholder = "Required"
                cell.textView.text = "test@test.com"
            case 2:
                cell.titleLabel.text = "Phone Number"
                cell.textView.placeholder = "Optional"
            case 3:
                cell.titleLabel.text = "Note"
                cell.textView.placeholder = "Optional (Type something long enough to wrap)"
            default:
                break
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
}

extension ViewController : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
