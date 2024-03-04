//
//  WorkReportController.swift
//  Chameleon
//
//  Created by SHATADRU DATTA on 03/03/24.
//

import UIKit

class WorkReportController: BaseViewController {

    @IBOutlet weak var tblWorkReport: UITableView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        activity.stopAnimating()
        self.tblWorkReport.reloadData()
        // Do any additional setup after loading the view.
    }
}

extension WorkReportController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 3
        case 2:
            return 3
        case 3:
            return 8
        case 4:
            return 7
        case 5:
            return 2
        case 6:
            return 2
        default:
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0, 1:
                return 60.0
            default:
                return 60.0
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                return 50.0
            case 1:
                return 115.0
            default:
                return 100.0
            }
        } else if indexPath.section == 2 {
            switch indexPath.row {
            case 0:
                return 50.0
            case 1:
                return 115.0
            default:
                return 100.0
            }
        } else if indexPath.section == 3 {
            switch indexPath.row {
            case 0:
                return 50.0
            case 1, 3, 5:
                return UITableView.automaticDimension
            case 2, 4, 6:
                return 100.0
            default:
                return 134.0
            }
        } else if indexPath.section == 4 {
            switch indexPath.row {
            case 0:
                return 50.0
            case 1, 3, 5:
                return UITableView.automaticDimension
            case 2, 4:
                return 100.0
            default:
                return 100.0
            }
        } else if indexPath.section == 5 {
            switch indexPath.row {
            case 0:
                return 50.0
            default:
                return UITableView.automaticDimension
            }
        } else if indexPath.section == 6 {
            switch indexPath.row {
            case 0:
                return 50.0
            default:
                return 170.0
            }
        } else {
            switch indexPath.row {
            case 0:
                return 50.0
            case 1:
                return UITableView.automaticDimension
            default:
                return 170.0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let custCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "CustomerCell", for: indexPath) as! CustomerCell
                custCell.datasource = "" as AnyObject
                custCell.lblCust.text = "Ref:"
                custCell.lblDetail.text = "abcd/12345"
                custCell.viewBG.backgroundColor = UIColor.init(hexString: "F1F8F3")
                custCell.imgIcon.image = UIImage(named: "ref")
                custCell.lblCust2.text = "Job:"
                custCell.lblDetail2.text = "123456"
                custCell.viewBG2.backgroundColor = UIColor.init(hexString: "F7F2EB")
                custCell.imgIcon2.image = UIImage(named: "Briefcase")
                return custCell
            case 1:
                let custCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "CustomerCell", for: indexPath) as! CustomerCell
                custCell.datasource = "" as AnyObject
                custCell.lblCust.text = "Install Date:"
                custCell.lblDetail.text = "15th January, 2024"
                custCell.viewBG.backgroundColor = UIColor.init(hexString: "F6EFF5")
                custCell.imgIcon.image = UIImage(named: "CalendarBlank")
                custCell.lblCust2.text = "Install Time:"
                custCell.lblDetail2.text = "10:30 AM"
                custCell.viewBG2.backgroundColor = UIColor.init(hexString: "F1F8F3")
                custCell.imgIcon2.image = UIImage(named: "Clock_Green")
                return custCell
            default:
                let serviceCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "ServiceReportCell", for: indexPath) as! ServiceReportCell
                serviceCell.datasource = "" as AnyObject
                serviceCell.lblService.text = "Service"
                serviceCell.lblServiceDetails.text = "jkadhfgadhkgfadhkfgadkhf"
                return serviceCell
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                let headerCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
                headerCell.datasource = "" as AnyObject
                headerCell.lblContent.text = "Installation Vehicle Details"
                headerCell.imgContent.image = UIImage(named: "vehicle-details")
                return headerCell
            case 1:
                let installCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "InstallationCell", for: indexPath) as! InstallationCell
                installCell.datasource = "" as AnyObject
                installCell.lblDetail.text = "Vehicle: Jeep Renegade Nighteagle"
                installCell.lblReg.text = "NA"
                installCell.lblYOM.text = "NA"
                installCell.lblColour.text = "NA"
                installCell.lblVIN.text = "NA"
                installCell.lblFuel.text = "NA"
                return installCell
            default:
                let collImgCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "ImgTableCell", for: indexPath) as! ImgTableCell
                collImgCell.datasource = "" as AnyObject
                return collImgCell
            }
        } else if indexPath.section == 2 {
            switch indexPath.row {
            case 0:
                let headerCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
                headerCell.datasource = "" as AnyObject
                headerCell.lblContent.text = "De-Installation Vehicle Details"
                headerCell.imgContent.image = UIImage(named: "vehicle-details")
                return headerCell
            case 1:
                let installCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "InstallationCell", for: indexPath) as! InstallationCell
                installCell.datasource = "" as AnyObject
                installCell.lblDetail.text = "Vehicle: Jeep Renegade Nighteagle"
                installCell.lblReg.text = "NA"
                installCell.lblYOM.text = "NA"
                installCell.lblColour.text = "NA"
                installCell.lblVIN.text = "NA"
                installCell.lblFuel.text = "NA"
                return installCell
            default:
                let collImgCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "ImgTableCell", for: indexPath) as! ImgTableCell
                collImgCell.datasource = "" as AnyObject
                return collImgCell
            }
        } else if indexPath.section == 3 {
            switch indexPath.row {
            case 0:
                let headerCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
                headerCell.datasource = "" as AnyObject
                headerCell.lblContent.text = "Pre-Work Checks"
                headerCell.imgContent.image = UIImage(named: "vehicle-details")
                return headerCell
            case 1:
                let issuesCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "IssueTextCell", for: indexPath) as!IssueTextCell
                issuesCell.datasource = "" as AnyObject
                issuesCell.lblIssueValidation.text = "Electrical Issues : Yes"
                issuesCell.lblIssueDesc.text = "hsgfhksfgkhgshkfgshkFGhkfgdhkfgfdagfkgfkdgffghafkgfhkgf\n khadgfakhdfgahkf"
                return issuesCell
            case 2:
                let collImgCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "ImgTableCell", for: indexPath) as! ImgTableCell
                collImgCell.datasource = "" as AnyObject
                return collImgCell
            case 3:
                let issuesCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "IssueTextCell", for: indexPath) as!IssueTextCell
                issuesCell.datasource = "" as AnyObject
                issuesCell.lblIssueValidation.text = "Exterior Issues : Yes"
                issuesCell.lblIssueDesc.text = "hsgfhksfgkhgshkfgshkFGhkfgdhkfgfdagfkgfkdgffghafkgfhkgf\n khadgfakhdfgahkf"
                return issuesCell
            case 4:
                let collImgCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "ImgTableCell", for: indexPath) as! ImgTableCell
                collImgCell.datasource = "" as AnyObject
                return collImgCell
            case 5:
                let issuesCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "IssueTextCell", for: indexPath) as!IssueTextCell
                issuesCell.datasource = "" as AnyObject
                issuesCell.lblIssueValidation.text = "Interior Issues : Yes"
                issuesCell.lblIssueDesc.text = "hsgfhksfgkhgshkfgshkFGhkfgdhkfgfdagfkgfkdgffghafkgfhkgf\n khadgfakhdfgahkf"
                return issuesCell
            case 6:
                let collImgCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "ImgTableCell", for: indexPath) as! ImgTableCell
                collImgCell.datasource = "" as AnyObject
                return collImgCell
            default:
                let confirmCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "ConfirmCell", for: indexPath) as! ConfirmCell
                confirmCell.datasource = "" as AnyObject
                return confirmCell
            }
        } else if indexPath.section == 4 {
            switch indexPath.row {
            case 0:
                let headerCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
                headerCell.datasource = "" as AnyObject
                headerCell.lblContent.text = "Post-Work Checks"
                headerCell.imgContent.image = UIImage(named: "vehicle-details")
                return headerCell
            case 1:
                let issuesCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "IssueTextCell", for: indexPath) as!IssueTextCell
                issuesCell.datasource = "" as AnyObject
                issuesCell.lblIssueValidation.text = "Electrical Issues : Yes"
                issuesCell.lblIssueDesc.text = "hsgfhksfgkhgshkfgshkFGhkfgdhkfgfdagfkgfkdgffghafkgfhkgf\n khadgfakhdfgahkf"
                return issuesCell
            case 2:
                let collImgCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "ImgTableCell", for: indexPath) as! ImgTableCell
                collImgCell.datasource = "" as AnyObject
                return collImgCell
            case 3:
                let issuesCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "IssueTextCell", for: indexPath) as!IssueTextCell
                issuesCell.datasource = "" as AnyObject
                issuesCell.lblIssueValidation.text = "Exterior Issues : Yes"
                issuesCell.lblIssueDesc.text = "hsgfhksfgkhgshkfgshkFGhkfgdhkfgfdagfkgfkdgffghafkgfhkgf\n khadgfakhdfgahkf"
                return issuesCell
            case 4:
                let collImgCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "ImgTableCell", for: indexPath) as! ImgTableCell
                collImgCell.datasource = "" as AnyObject
                return collImgCell
            case 5:
                let issuesCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "IssueTextCell", for: indexPath) as!IssueTextCell
                issuesCell.datasource = "" as AnyObject
                issuesCell.lblIssueValidation.text = "Interior Issues : Yes"
                issuesCell.lblIssueDesc.text = "hsgfhksfgkhgshkfgshkFGhkfgdhkfgfdagfkgfkdgffghafkgfhkgf\n khadgfakhdfgahkf"
                return issuesCell
            default:
                let collImgCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "ImgTableCell", for: indexPath) as! ImgTableCell
                collImgCell.datasource = "" as AnyObject
                return collImgCell
            }
        } else if indexPath.section == 5 {
            switch indexPath.row {
            case 0:
                let headerCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
                headerCell.datasource = "" as AnyObject
                headerCell.lblContent.text = "Declaration"
                headerCell.imgContent.image = UIImage(named: "vehicle-details")
                return headerCell
            default:
                let declarationCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "DeclarationCell", for: indexPath) as! DeclarationCell
                declarationCell.datasource = "" as AnyObject
                declarationCell.lblDeclaration.text = "khsfgshkfghkfghkfghfghfgFHKF"
                return declarationCell
            }
        } else if indexPath.section == 6 {
            switch indexPath.row {
            case 0:
                let headerCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
                headerCell.datasource = "" as AnyObject
                headerCell.lblContent.text = "Engineer Signature"
                headerCell.imgContent.image = UIImage(named: "Signature")
                return headerCell
            default:
                let signatureCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "SignatureCell", for: indexPath) as! SignatureCell
                signatureCell.datasource = "" as AnyObject
                return signatureCell
            }
        } else {
            switch indexPath.row {
            case 0:
                let headerCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
                headerCell.datasource = "" as AnyObject
                headerCell.lblContent.text = "Customer Signature"
                headerCell.imgContent.image = UIImage(named: "Signature")
                return headerCell
            case 1:
                let descCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "DeclarationCell", for: indexPath) as! DeclarationCell
                descCell.datasource = "" as AnyObject
                descCell.lblDeclaration.text = "khsfgshkfghkfghkfghfghfgFHKF"
                return descCell
            default:
                let signatureCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "SignatureCell", for: indexPath) as! SignatureCell
                signatureCell.datasource = "" as AnyObject
                return signatureCell
            }
        }
    }
}

// MARK: IssueTextCell
class IssueTextCell: BaseTableViewCell {
    @IBOutlet weak var lblIssueValidation: UILabel!
    @IBOutlet weak var lblIssueDesc: UILabel!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                
            }
        }
    }
}

// MARK: ConfirmCell
class ConfirmCell: BaseTableViewCell {
    @IBOutlet weak var imgSignView: UIImageView!
    @IBOutlet weak var lblConfirmText: UILabel!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                
            }
        }
    }
}

// MARK: SignatureCell
class SignatureCell: BaseTableViewCell {
    @IBOutlet weak var imgSignView: UIImageView!
    @IBOutlet weak var lblEngName: UILabel!
    @IBOutlet weak var lblEngCode: UILabel!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                
            }
        }
    }
}

// MARK: ImgTableViewCell
class ImgTableCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collImg: UICollectionView!
    var arrImg: [UIImage] = []
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                collImg.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrImg.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let imageview: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        imageview.image = arrImg[indexPath.item]
        imageview.contentMode = .scaleAspectFill
        cell.contentView.addSubview(imageview)
        let btnDel: UIButton = UIButton(frame: CGRect(x: 56, y: 0, width: 24, height: 24))
        btnDel.setImage(UIImage(named: "trash"), for: .normal)
        btnDel.addTarget(self, action: #selector(delImg), for: .touchUpInside)
        cell.contentView.addSubview(btnDel)
        return cell
    }
    
    @objc func delImg(_ sender: UIButton) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80.0, height: 80.0)
    }
}


// MARK: DeclarationCell
class DeclarationCell: BaseTableViewCell {
    @IBOutlet weak var lblDeclaration: UILabel!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                
            }
        }
    }
}

// MARK: ServiceReportCell
class ServiceReportCell: BaseTableViewCell {
    @IBOutlet weak var lblService: UILabel!
    @IBOutlet weak var lblServiceDetails: UILabel!
    @IBOutlet weak var bgView: UIView!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                self.bgView.layer.cornerRadius = 10.0
            }
        }
    }
}
