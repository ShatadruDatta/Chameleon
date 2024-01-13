//
//  PreCheckController.swift
//  Chameleon
//
//  Created by SHATADRU DATTA on 09/01/24.
//

import UIKit

class PreCheckController: BaseViewController {

    @IBOutlet weak var tblPrecheck: UITableView!
    @IBOutlet weak var viewPreCheck: UIView!
    @IBOutlet weak var viewPostCheck: UIView!
    @IBOutlet weak var viewClosure: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblPrecheck.reloadData()
        tblPrecheck.estimatedRowHeight = 100.0
        tblPrecheck.rowHeight = UITableView.automaticDimension
        viewPreCheck.layer.cornerRadius = 10.0
        viewPostCheck.layer.cornerRadius = 10.0
        viewClosure.layer.cornerRadius = 10.0
        
        self.viewPreCheck.layer.masksToBounds = false
        self.viewPreCheck.dropShadow(color: .lightGray, opacity: 0.3 ,offSet: CGSize.init(width: 4, height: 4), radius: 10.0)
        
        self.viewPostCheck.layer.masksToBounds = false
        self.viewPostCheck.dropShadow(color: .lightGray, opacity: 0.3 ,offSet: CGSize.init(width: 4, height: 4), radius: 10.0)
        
        self.viewClosure.layer.masksToBounds = false
        self.viewClosure.dropShadow(color: .lightGray, opacity: 0.3 ,offSet: CGSize.init(width: 4, height: 4), radius: 10.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func menu(_ sender: UIButton) {
        NavigationHelper.helper.openSidePanel(open: true)
    }
}

// MARK: TableViewDelegate, TableViewDataSource
extension PreCheckController: UITableViewDelegate, UITableViewDataSource {

     func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        default:
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return UIView()
        default:
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40))
            
            let imgIcon = UIImageView()
            imgIcon.frame = CGRect.init(x: 5, y: 12, width: 16, height: 16)
            let label = UILabel()
            label.frame = CGRect.init(x: 25, y: 0, width: headerView.frame.width-25, height: 40)
            
            // Condition depending on section
            switch section {
            case 1:
                imgIcon.image = UIImage(named: "phone-book")
                label.text = "Contact Details"
            case 2:
                imgIcon.image = UIImage(named: "parts")
                label.text = "Parts"
            case 3:
                imgIcon.image = UIImage(named: "vehicle-details")
                label.text = "Installation Vehicle Details"
            case 4:
                imgIcon.image = UIImage(named: "vehicle-details")
                label.text = "De-Installation Vehicle Details"
            default:
                imgIcon.image = UIImage(named: "engineer-notes")
                label.text = "Engineer Notes"
            }
            
            
            label.font = UIFont.Poppins(.medium, size: 15.0)
            label.textColor = UIColor.init(hexString: "#123293")
            
            headerView.addSubview(imgIcon)
            headerView.addSubview(label)
            headerView.backgroundColor = UIColor.init(hexString: "#F8F9FF")
            return headerView
        }
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         switch section {
         case 0:
             return 3
         case 1,3,4:
             return 1
         case 2:
             return 3
         default:
             return 1
         }
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         if indexPath.section == 0 {
             switch indexPath.row {
             case 0:
                 let custCell = self.tblPrecheck.dequeueReusableCell(withIdentifier: "CustomerCell", for: indexPath) as! CustomerCell
                 custCell.datasource = "" as AnyObject
                 return custCell
             case 1:
                 let custCell = self.tblPrecheck.dequeueReusableCell(withIdentifier: "CustomerCell", for: indexPath) as! CustomerCell
                 custCell.datasource = "" as AnyObject
                 return custCell
             default:
                 let serviceCell = self.tblPrecheck.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath) as! ServiceCell
                 serviceCell.datasource = "" as AnyObject
                 return serviceCell
             }
         } else if indexPath.section == 1 {
             let conDetCell = self.tblPrecheck.dequeueReusableCell(withIdentifier: "ContactDetailsCell", for: indexPath) as! ContactDetailsCell
             conDetCell.datasource = "" as AnyObject
             return conDetCell
         } else if indexPath.section == 2 {
             let partsCell = self.tblPrecheck.dequeueReusableCell(withIdentifier: "PartsCell", for: indexPath) as! PartsCell
             partsCell.datasource = "1 x [RH6SL256] - Color Gas] - RH600 Single Lens 256GB\n Serial Number : 123456" as AnyObject
             if indexPath.row % 2 == 0 {
                 partsCell.viewBG.backgroundColor = UIColor.init(hexString: "F0EEF5")
             } else {
                 partsCell.viewBG.backgroundColor = .white
             }
             return partsCell
         } else if indexPath.section == 3 {
             let installCell = self.tblPrecheck.dequeueReusableCell(withIdentifier: "InstallationCell", for: indexPath) as! InstallationCell
             installCell.datasource = "" as AnyObject
             return installCell
         } else if indexPath.section == 4 {
             let installCell = self.tblPrecheck.dequeueReusableCell(withIdentifier: "InstallationCell", for: indexPath) as! InstallationCell
             installCell.datasource = "" as AnyObject
             return installCell
         } else {
             let noteCell = self.tblPrecheck.dequeueReusableCell(withIdentifier: "PartsCell", for: indexPath) as! PartsCell
             noteCell.datasource = "Bursting with imagery, motion, interaction and distraction though it is, today’s World Wide Web is still primarily a conduit for textual information. In HTML5, the focus on writing and authorship is more pronounced than ever. It’s evident in the very way that new elements such as article and aside are named. HTML5 asks us to treat the HTML document more as… well, a document." as AnyObject
             noteCell.viewBG.backgroundColor = .white
             return noteCell
         }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 3 || indexPath.section == 4 {
            return 115.0
        } else {
            return UITableView.automaticDimension
        }
    }
}

// MARK: CustomerCell
class CustomerCell: BaseTableViewCell {
    @IBOutlet weak var lblCust: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var viewBG: UIView!
    
    @IBOutlet weak var lblCust2: UILabel!
    @IBOutlet weak var imgIcon2: UIImageView!
    @IBOutlet weak var lblDetail2: UILabel!
    @IBOutlet weak var viewBG2: UIView!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                viewBG.layer.cornerRadius = 10.0
                viewBG.layer.borderWidth = 1.0
                viewBG.layer.borderColor = UIColor.init(hexString: "#e4eaf1").cgColor
                
                viewBG2.layer.cornerRadius = 10.0
                viewBG2.layer.borderWidth = 1.0
                viewBG2.layer.borderColor = UIColor.init(hexString: "#e4eaf1").cgColor
            }
        }
    }
}

// MARK: ServiceCell
class ServiceCell: BaseTableViewCell {
    @IBOutlet weak var lblCust: UILabel!
    @IBOutlet weak var imgIcon: UIImageView!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var viewBG: UIView!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                viewBG.layer.cornerRadius = 10.0
                viewBG.layer.borderWidth = 1.0
                viewBG.layer.borderColor = UIColor.init(hexString: "#e4eaf1").cgColor
            }
        }
    }
}


// MARK: ContactDetails
class ContactDetailsCell: BaseTableViewCell {
    
    @IBOutlet weak var viewBG: UIView!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                viewBG.layer.cornerRadius = 10.0
            }
        }
    }
}

// MARK: PartsCell
class PartsCell: BaseTableViewCell {
    @IBOutlet weak var lblDetails: UILabel!
    @IBOutlet weak var viewBG: UIView!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                viewBG.layer.cornerRadius = 10.0
                lblDetails.text = datasource as? String
            }
        }
    }
}


// MARK: InstallationCell
class InstallationCell: BaseTableViewCell {
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var lblReg: UILabel!
    @IBOutlet weak var lblYOM: UILabel!
    @IBOutlet weak var lblColour: UILabel!
    @IBOutlet weak var lblVIN: UILabel!
    @IBOutlet weak var lblFuel: UILabel!
    @IBOutlet weak var viewBG: UIView!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                viewBG.layer.cornerRadius = 10.0
                lblDetail.text = "Details Vehicle: Jeep Rehegade Nightangle"
                lblReg.text = "EU22 KCX"
                lblYOM.text = "2024"
                lblColour.text = "Black"
                lblVIN.text = "123456789abcdef"
                lblFuel.text = "Pertrol"
            }
        }
    }
}
