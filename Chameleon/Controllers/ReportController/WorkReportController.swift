//
//  WorkReportController.swift
//  Chameleon
//
//  Created by SHATADRU DATTA on 03/03/24.
//

import UIKit

class WorkReportController: BaseViewController {

    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var tblWorkReport: UITableView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var segment: UISegmentedControl!
    var selectedIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        activity.stopAnimating()
        self.tblWorkReport.reloadData()
        segment.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func menu(_ sender: UIButton) {
        NavigationHelper.helper.reloadMenu()
        NavigationHelper.helper.openSidePanel(open: true)
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.lblHeader.text = "Work Report"
            selectedIndex = 0
        } else {
            self.lblHeader.text = "Job Sheet"
            selectedIndex = 1
        }
        self.tblWorkReport.reloadData()
    }
}

extension WorkReportController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            if selectedIndex == 0 {
                return 0
            } else {
                return 1 + arrPartsSerial.count
            }
        case 2:
            return 3
        case 3:
            return JobSheetData.check_Deinstallation_available ? 3 : 0
        case 4:
            return 9
        case 5:
            return 7
        case 6:
            return 2
        case 7:
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
            default:
                return UITableView.automaticDimension
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
            case 1:
                return 115.0
            default:
                return 0
            }
        } else if indexPath.section == 4 {
            switch indexPath.row {
            case 0:
                return 50.0
            case 1:
                return 100.0
            case 2, 4, 6:
                return UITableView.automaticDimension
            case 3:
                return PreCheckData.arrImgElectricalIssue.count > 0 ? 100.0 : 0
            case 5:
                return PreCheckData.arrImgExteriorIssue.count > 0 ? 100.0 : 0
            case 7:
                return PreCheckData.arrImgInteriorIssue.count > 0 ? 100 : 0
            default:
                return 134.0
            }
        } else if indexPath.section == 5 {
            switch indexPath.row {
            case 0:
                return 50.0
            case 1, 3, 5:
                return UITableView.automaticDimension
            case 2:
                return PostCheckData.arrImgElectricalIssue.count > 0 ? 100.0 : 0
            case 4:
                return PostCheckData.arrImgExteriorIssue.count > 0 ? 100.0 : 0
            default:
                return PostCheckData.arrImgInteriorIssue.count > 0 ? 100 : 0
            }
        } else if indexPath.section == 6 {
            switch indexPath.row {
            case 0:
                return 50.0
            default:
                return UITableView.automaticDimension
            }
        } else if indexPath.section == 7 {
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
                custCell.lblDetail.text = JobSheetData.ref_no
                custCell.viewBG.backgroundColor = UIColor.init(hexString: "F1F8F3")
                custCell.imgIcon.image = UIImage(named: "ref")
                custCell.lblCust2.text = "Job:"
                custCell.lblDetail2.text = String(JobSheetData.jobId)
                custCell.viewBG2.backgroundColor = UIColor.init(hexString: "F7F2EB")
                custCell.imgIcon2.image = UIImage(named: "Briefcase")
                return custCell
            case 1:
                let custCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "CustomerCell", for: indexPath) as! CustomerCell
                custCell.datasource = "" as AnyObject
                custCell.lblCust.text = "Install Date:"
                custCell.lblDetail.text = JobSheetData.date
                custCell.viewBG.backgroundColor = UIColor.init(hexString: "F6EFF5")
                custCell.imgIcon.image = UIImage(named: "CalendarBlank")
                custCell.lblCust2.text = "Install Time:"
                custCell.lblDetail2.text = JobSheetData.time
                custCell.viewBG2.backgroundColor = UIColor.init(hexString: "F1F8F3")
                custCell.imgIcon2.image = UIImage(named: "Clock_Green")
                return custCell
            default:
                let serviceCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "ServiceReportCell", for: indexPath) as! ServiceReportCell
                serviceCell.datasource = "" as AnyObject
                serviceCell.lblService.text = "Service"
                serviceCell.lblServiceDetails.text = JobSheetData.service
                return serviceCell
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                let headerCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
                headerCell.datasource = "" as AnyObject
                headerCell.lblContent.text = "Equipment"
                headerCell.imgContent.image = UIImage(named: "vehicle-details")
                return headerCell
            default:
                let equipPartsCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "EquipmentPartsCell", for: indexPath) as! EquipmentPartsCell
                equipPartsCell.datasource = "" as AnyObject
                equipPartsCell.lblPart.text = "Device Part Number: \(arrPartsSerial[indexPath.row - 1].prodName)"
                equipPartsCell.lblPartDesc.text = arrPartsSerial[indexPath.row - 1].comments
                equipPartsCell.imgUnit.image = arrPartsSerial[indexPath.row - 1].imgUnit
                equipPartsCell.imgPerm.image = arrPartsSerial[indexPath.row - 1].imgPerm
                equipPartsCell.imgEarth.image = arrPartsSerial[indexPath.row - 1].imgEarth
                equipPartsCell.imgIGN.image = arrPartsSerial[indexPath.row - 1].imgIgn
                equipPartsCell.imgLoam.image = arrPartsSerial[indexPath.row - 1].imgLoom
                equipPartsCell.imgSerial.image = arrPartsSerial[indexPath.row - 1].imgSerial
                return equipPartsCell
            }
        } else if indexPath.section == 2 {
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
                installCell.lblDetail.text = "Vehicle: \(JobSheetData.ins_vehicle_det_vehicle)"
                installCell.lblReg.text = JobSheetData.ins_vehicle_det_reg.count > 0 ? JobSheetData.ins_vehicle_det_reg : "NA"
                installCell.lblYOM.text = JobSheetData.ins_vehicle_det_yom.count > 0 ? JobSheetData.ins_vehicle_det_yom : "NA"
                installCell.lblColour.text = JobSheetData.ins_vehicle_det_color.count > 0 ? JobSheetData.ins_vehicle_det_color : "NA"
                installCell.lblVIN.text = JobSheetData.ins_vehicle_det_vin.count > 0 ? JobSheetData.ins_vehicle_det_vin : "NA"
                installCell.lblFuel.text = JobSheetData.ins_vehicle_det_fuelType.count > 0 ? JobSheetData.ins_vehicle_det_fuelType : "NA"
                return installCell
            default:
                let collImgCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "ImgTableCell", for: indexPath) as! ImgTableCell
                collImgCell.datasource = "" as AnyObject
                collImgCell.arrImg = [PreCheckData.dash_img]
                return collImgCell
            }
        } else if indexPath.section == 3 {
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
                installCell.lblDetail.text = "Vehicle: \(JobSheetData.deins_vehicle_det_vehicle)"
                installCell.lblReg.text = JobSheetData.deins_vehicle_det_reg.count > 0 ? JobSheetData.deins_vehicle_det_reg : "NA"
                installCell.lblYOM.text = JobSheetData.deins_vehicle_det_yom.count > 0 ? JobSheetData.deins_vehicle_det_yom : "NA"
                installCell.lblColour.text = JobSheetData.deins_vehicle_det_color.count > 0 ? JobSheetData.deins_vehicle_det_color : "NA"
                installCell.lblVIN.text = JobSheetData.deins_vehicle_det_vin.count > 0 ? JobSheetData.deins_vehicle_det_vin : "NA"
                installCell.lblFuel.text = JobSheetData.deins_vehicle_det_fuelType.count > 0 ? JobSheetData.deins_vehicle_det_fuelType : "NA"
                return installCell
            default:
                let collImgCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "ImgTableCell", for: indexPath) as! ImgTableCell
                collImgCell.datasource = "" as AnyObject
                return collImgCell
            }
        } else if indexPath.section == 4 {
            switch indexPath.row {
            case 0:
                let headerCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
                headerCell.datasource = "" as AnyObject
                headerCell.lblContent.text = "Pre-Work Checks"
                headerCell.imgContent.image = UIImage(named: "vehicle-details")
                return headerCell
            case 1:
                let collImgCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "ImgTableCell", for: indexPath) as! ImgTableCell
                collImgCell.arrImg.removeAll()
                collImgCell.arrImg.append(PreCheckData.front_img)
                collImgCell.arrImg.append(PreCheckData.rear_img)
                collImgCell.arrImg.append(PreCheckData.passengerSide_img)
                collImgCell.arrImg.append(PreCheckData.driverSide_img)
                collImgCell.datasource = "" as AnyObject
                return collImgCell
            case 2:
                let issuesCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "IssueTextCell", for: indexPath) as!IssueTextCell
                issuesCell.datasource = "" as AnyObject
                issuesCell.lblIssueValidation.text = "Electrical Issues : \(PreCheckData.isElectricalIssue ? "Yes" : "No")"
                issuesCell.lblIssueDesc.text = PreCheckData.electricalIssueTxt
                return issuesCell
            case 3:
                let collImgCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "ImgTableCell", for: indexPath) as! ImgTableCell
                collImgCell.datasource = "" as AnyObject
                collImgCell.arrImg.removeAll()
                collImgCell.arrImg = PreCheckData.arrImgElectricalIssue
                return collImgCell
            case 4:
                let issuesCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "IssueTextCell", for: indexPath) as!IssueTextCell
                issuesCell.datasource = "" as AnyObject
                issuesCell.lblIssueValidation.text = "Exterior Issues : \(PreCheckData.isExteriorIssue ? "Yes" : "No")"
                issuesCell.lblIssueDesc.text = PreCheckData.exteriorIssueTxt
                return issuesCell
            case 5:
                let collImgCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "ImgTableCell", for: indexPath) as! ImgTableCell
                collImgCell.datasource = "" as AnyObject
                collImgCell.arrImg.removeAll()
                collImgCell.arrImg = PreCheckData.arrImgExteriorIssue
                return collImgCell
            case 6:
                let issuesCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "IssueTextCell", for: indexPath) as!IssueTextCell
                issuesCell.datasource = "" as AnyObject
                issuesCell.lblIssueValidation.text = "Interior Issues : \(PreCheckData.isInteriorIssue ? "Yes" : "No")"
                issuesCell.lblIssueDesc.text = PreCheckData.interiorIssueTxt
                return issuesCell
            case 7:
                let collImgCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "ImgTableCell", for: indexPath) as! ImgTableCell
                collImgCell.datasource = "" as AnyObject
                collImgCell.arrImg.removeAll()
                collImgCell.arrImg = PreCheckData.arrImgInteriorIssue
                return collImgCell
            default:
                let confirmCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "ConfirmCell", for: indexPath) as! ConfirmCell
                confirmCell.datasource = "" as AnyObject
                confirmCell.lblConfirmText.text = "I confirm that a pre-work check has been completed and agree with the findings"
                confirmCell.imgSignView.image = PreCheckData.customerSignature
                return confirmCell
            }
        } else if indexPath.section == 5 {
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
                issuesCell.lblIssueValidation.text = "Electrical Issues : \(PostCheckData.isElectricalIssue ? "Yes" : "No")"
                issuesCell.lblIssueDesc.text = PostCheckData.electricalIssueTxt
                return issuesCell
            case 2:
                let collImgCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "ImgTableCell", for: indexPath) as! ImgTableCell
                collImgCell.datasource = "" as AnyObject
                collImgCell.arrImg.removeAll()
                collImgCell.arrImg = PostCheckData.arrImgElectricalIssue
                return collImgCell
            case 3:
                let issuesCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "IssueTextCell", for: indexPath) as!IssueTextCell
                issuesCell.datasource = "" as AnyObject
                issuesCell.lblIssueValidation.text = "Exterior Issues : \(PostCheckData.isExteriorIssue ? "Yes" : "No")"
                issuesCell.lblIssueDesc.text = PostCheckData.exteriorIssueTxt
                return issuesCell
            case 4:
                let collImgCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "ImgTableCell", for: indexPath) as! ImgTableCell
                collImgCell.datasource = "" as AnyObject
                collImgCell.arrImg.removeAll()
                collImgCell.arrImg = PostCheckData.arrImgExteriorIssue
                return collImgCell
            case 5:
                let issuesCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "IssueTextCell", for: indexPath) as!IssueTextCell
                issuesCell.datasource = "" as AnyObject
                issuesCell.lblIssueValidation.text = "Interior Issues : \(PostCheckData.isInteriorIssue ? "Yes" : "No")"
                issuesCell.lblIssueDesc.text = PostCheckData.interiorIssueTxt
                return issuesCell
            default:
                let collImgCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "ImgTableCell", for: indexPath) as! ImgTableCell
                collImgCell.datasource = "" as AnyObject
                collImgCell.arrImg.removeAll()
                collImgCell.arrImg = PostCheckData.arrImgInteriorIssue
                return collImgCell
            }
        } else if indexPath.section == 6 {
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
                declarationCell.lblDeclaration.text = PostCheckData.declaration
                return declarationCell
            }
        } else if indexPath.section == 7 {
            switch indexPath.row {
            case 0:
                let headerCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
                headerCell.datasource = "" as AnyObject
                headerCell.lblContent.text = "Engineer Signature"
                return headerCell
            default:
                let signatureCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "SignatureCell", for: indexPath) as! SignatureCell
                signatureCell.datasource = "" as AnyObject
                signatureCell.imgSignView.image = PostCheckData.engineerSignature
                signatureCell.lblEngName.text = "Engineer Name: \(PostCheckData.engineerName)"
                signatureCell.lblEngCode.text = "Engineer Code: \(PostCheckData.engineerCode)"
                return signatureCell
            }
        } else {
            switch indexPath.row {
            case 0:
                let headerCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
                headerCell.datasource = "" as AnyObject
                headerCell.lblContent.text = "Customer Signature"
                return headerCell
            case 1:
                let descCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "DeclarationCell", for: indexPath) as! DeclarationCell
                descCell.datasource = "" as AnyObject
                descCell.lblDeclaration.text = "I confirm that a post-work check has been completed and that the work has been completed to my satisfaction"
                return descCell
            default:
                let signatureCell = self.tblWorkReport.dequeueReusableCell(withIdentifier: "SignatureCell", for: indexPath) as! SignatureCell
                signatureCell.datasource = "" as AnyObject
                signatureCell.imgSignView.image = PostCheckData.customerSignature
                signatureCell.lblEngName.text = "Customer Name: \(PostCheckData.customerName)"
                signatureCell.lblEngCode.text = "Position: \(PostCheckData.customerPosition)"
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImgCollCell", for: indexPath)
        let imageview: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        imageview.image = arrImg[indexPath.item]
        imageview.contentMode = .scaleAspectFill
        cell.contentView.layer.cornerRadius = 5.0
        cell.contentView.addSubview(imageview)
        let btnDel: UIButton = UIButton(frame: CGRect(x: 56, y: 0, width: 24, height: 24))
        btnDel.setImage(UIImage(named: "trash"), for: .normal)
        btnDel.isHidden = true
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


// MARK: EquipmentCell
class EquipmentPartsCell: BaseTableViewCell {
    @IBOutlet weak var lblPart: UILabel!
    @IBOutlet weak var lblPartDesc: UILabel!
    @IBOutlet weak var imgUnit: UIImageView!
    @IBOutlet weak var imgPerm: UIImageView!
    @IBOutlet weak var imgEarth: UIImageView!
    @IBOutlet weak var imgIGN: UIImageView!
    @IBOutlet weak var imgLoam: UIImageView!
    @IBOutlet weak var imgSerial: UIImageView!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                
            }
        }
    }
}
