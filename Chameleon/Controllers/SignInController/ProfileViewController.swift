//
//  ProfileViewController.swift
//  Chameleon
//
//  Created by Shatadru Datta on 28/03/24.
//

import UIKit

class ProfileViewController: BaseViewController {

    @IBOutlet weak var tblProfile: UITableView!
    @IBOutlet weak var imgProfile: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: UIButton) {
        
    }
    
    @IBAction func btnCamera(_ sender: UIButton) {
        
    }
}

// MARK: TableViewDelegate, TableViewDataSource
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 4 {
            return 100.0
        } else {
            return 110.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            
        default:
            <#code#>
        }
    }
}

// MARK: UserProfileTableCell
class UserProfileCell: BaseTableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var txtField: UITextField!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                
            }
        }
    }
}

class UserProfileSaveCell: BaseTableViewCell {
    
}
