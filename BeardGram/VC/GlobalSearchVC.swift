//
//  GlobalSearchVC.swift
//  BeardGram
//
//  Created by Pavel Semenchenko on 06.02.2023.
//

import Foundation
import UIKit

class GlobalSearchVC: UIViewController {
    
    @IBOutlet weak var globalSearchTextField: UITextField!
    
    @IBOutlet weak var globalSearchTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Global users list"
    }
    
    @IBAction func globalSearchButtonClicked(_ sender: Any) {
    }
    
}
