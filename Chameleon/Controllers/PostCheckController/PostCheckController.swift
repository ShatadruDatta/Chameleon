//
//  PostCheckController.swift
//  Chameleon
//
//  Created by SHATADRU DATTA on 04/03/24.
//

import UIKit

class PostCheckController: BaseViewController {

    @IBOutlet weak var lblNcNumber: UILabel!
    @IBOutlet weak var tblPostCheck: UITableView!
    @IBOutlet weak var viewPreCheck: UIView!
    @IBOutlet weak var viewPostCheck: UIView!
    @IBOutlet weak var viewClosure: UIView!
    var arrBufferPartsId: Int = 0
    var arrBufferParts: [(id: Int, partsName: String, serialNo: String, consumed: String, partsImg: UIImage)] = []
    var arrPartsReturnId: Int = 0
    var arrPartsToReturn: [(id: Int, partsName: String, serialNo: String, returnedBy: String, partsImg: UIImage)] = []
    var arrImg: [UIImage] = []
    var isReset: Bool = false
    var isSave: Bool = false
    
    var checkController: Bool = false
    
    var isIssueElectrical: Bool = false
    var issueIndexElectrical: Int = -1
    var arrImgElectricalIssue: [UIImage] = []
    
    var isIssueExterior: Bool = false
    var arrImgExteriorIssue: [UIImage] = []
    
    var isIssueInterior: Bool = false
    var arrImgInteriorIssue: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblPostCheck.reloadData()
        viewPreCheck.layer.cornerRadius = 10.0
        viewPostCheck.layer.cornerRadius = 10.0
        viewClosure.layer.cornerRadius = 10.0
        
        self.viewPreCheck.layer.masksToBounds = false
        self.viewPreCheck.dropShadow(color: .lightGray, opacity: 0.3 ,offSet: CGSize.init(width: 4, height: 4), radius: 10.0)
        
        self.viewPostCheck.layer.masksToBounds = false
        self.viewPostCheck.dropShadow(color: .lightGray, opacity: 0.3 ,offSet: CGSize.init(width: 4, height: 4), radius: 10.0)
        
        self.viewClosure.layer.masksToBounds = false
        self.viewClosure.dropShadow(color: .lightGray, opacity: 0.3 ,offSet: CGSize.init(width: 4, height: 4), radius: 10.0)
        self.arrBufferPartsId += 1
        arrBufferParts.append((id: self.arrBufferPartsId, partsName: "RP123456", serialNo: "ABC7463", consumed: "Yes", partsImg: UIImage()))
        self.arrPartsReturnId += 1
        arrPartsToReturn.append((id: self.arrPartsReturnId, partsName: "", serialNo: "", returnedBy: "", partsImg: UIImage()))
        
        self.lblNcNumber.text = JobSheetData.nc_bnc_number
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closure(_ sender: UIButton) {
        let closureVC = mainStoryboard.instantiateViewController(withIdentifier: "ClosureController") as! ClosureController
        NavigationHelper.helper.contentNavController!.pushViewController(closureVC, animated: true)
    }
    
    @IBAction func precheck(_ sender: UIButton) {
        let allViewController: [UIViewController] =  NavigationHelper.helper.contentNavController!.viewControllers as [UIViewController]
        for aviewcontroller: UIViewController in allViewController {
            if aviewcontroller.isKind(of: PrecheckController.classForCoder()) {
                NavigationHelper.helper.contentNavController!.popToViewController(aviewcontroller, animated: true)
                self.checkController = true
                break
            }
        }
        if self.checkController == false {
            let precheckVC = mainStoryboard.instantiateViewController(withIdentifier: "PrecheckController") as! PrecheckController
            NavigationHelper.helper.contentNavController!.pushViewController(precheckVC, animated: true)
        }
        self.checkController = false
    }
    
    @IBAction func menu(_ sender: UIButton) {
        NavigationHelper.helper.openSidePanel(open: true)
    }
}

extension PostCheckController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 2
        case 2:
            return 2 + arrBufferParts.count
        case 3:
            return 2 + arrPartsToReturn.count
        case 4:
            return 4 // ElectricalIssue, ExteriorIssue, InteriorIssue
        case 5:
            return 2
        case 6:
            return 2
        case 7:
            return 2
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                return 50.0
            case 1:
                return 197.0
            default:
                return 197.0
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                return 50.0
            default:
                return 140.0
            }
        } else if indexPath.section == 2 || indexPath.section == 3 {
            switch indexPath.row {
            case 0:
                return 50.0
            default:
                return UITableView.automaticDimension
            }
        } else if indexPath.section == 4 {
            switch indexPath.row {
            case 0:
                return 50.0
            case 1:
                if isIssueElectrical {
                    if arrImgElectricalIssue.count > 0 {
                        return 245.0
                    } else {
                        return 180.0
                    }
                } else {
                    return 50.0
                }
            case 2:
                if isIssueExterior {
                    if arrImgExteriorIssue.count > 0 {
                        return 245.0
                    } else {
                        return 180.0
                    }
                } else {
                    return 50.0
                }
            default:
                if isIssueInterior {
                    if arrImgInteriorIssue.count > 0 {
                        return 245.0
                    } else {
                        return 180.0
                    }
                } else {
                    return 50.0
                }
            }
        } else if indexPath.section == 5 {
            switch indexPath.row {
            case 0:
                return 50.0
            default:
                return 210.0
            }
        } else if indexPath.section == 6 {
            switch indexPath.row {
            case 0:
                return 50.0
            default:
                return 240.0
            }
        } else if indexPath.section == 7 {
            switch indexPath.row {
            case 0:
                return 50.0
            default:
                return 340.0
            }
        } else {
            return 80.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                let headerCell = self.tblPostCheck.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
                headerCell.datasource = "" as AnyObject
                headerCell.lblContent.text = "Vehicle"
                headerCell.imgContent.image = UIImage(named: "vehicle-details")
                return headerCell
            case 1:
                let imgCell = self.tblPostCheck.dequeueReusableCell(withIdentifier: "DashImageCaptureCell", for: indexPath) as! DashImageCaptureCell
                imgCell.datasource = "" as AnyObject
                imgCell.lblImg1.text = "Front"
                imgCell.lblImg2.text = "Rear"
                imgCell.didFirstImg = { val in
                    CameraHandler.shared.showActionSheet(vc: self)
                    CameraHandler.shared.imagePickedBlock = { (image) in
                        imgCell.imgView1.image = image
                        imgCell.lblAddImage1.isHidden = true
                        imgCell.imgCamera1.isHidden = true
                        imgCell.btnDel1.isHidden = false
                    }
                }
                imgCell.delImage1 = { check in
                    imgCell.imgView1.image = UIImage(named: "ImgCapBg")
                    imgCell.lblAddImage1.isHidden = false
                    imgCell.imgCamera1.isHidden = false
                    imgCell.btnDel1.isHidden = true
                }
                imgCell.didSecondImg = { val in
                    CameraHandler.shared.showActionSheet(vc: self)
                    CameraHandler.shared.imagePickedBlock = { (image) in
                        imgCell.imgView2.image = image
                        imgCell.lblAddImage2.isHidden = true
                        imgCell.imgCamera2.isHidden = true
                        imgCell.btnDel2.isHidden = false
                    }
                }
                imgCell.delImage2 = { check in
                    imgCell.imgView2.image = UIImage(named: "ImgCapBg")
                    imgCell.lblAddImage2.isHidden = false
                    imgCell.imgCamera2.isHidden = false
                    imgCell.btnDel2.isHidden = true
                }
                return imgCell
            default:
                let imgCell = self.tblPostCheck.dequeueReusableCell(withIdentifier: "FrontImageCaptureCell", for: indexPath) as! FrontImageCaptureCell
                imgCell.datasource = "" as AnyObject
                imgCell.lblImg1.text = "Passenger Side"
                imgCell.lblImg2.text = "Driver Side"
                imgCell.didFirstImg = { val in
                    CameraHandler.shared.showActionSheet(vc: self)
                    CameraHandler.shared.imagePickedBlock = { (image) in
                        imgCell.imgView1.image = image
                        imgCell.lblAddImage1.isHidden = true
                        imgCell.imgCamera1.isHidden = true
                        imgCell.btnDel1.isHidden = false
                    }
                }
                imgCell.delImage1 = { check in
                    imgCell.imgView1.image = UIImage(named: "ImgCapBg")
                    imgCell.lblAddImage1.isHidden = false
                    imgCell.imgCamera1.isHidden = false
                    imgCell.btnDel1.isHidden = true
                }
                imgCell.didSecondImg = { val in
                    CameraHandler.shared.showActionSheet(vc: self)
                    CameraHandler.shared.imagePickedBlock = { (image) in
                        imgCell.imgView2.image = image
                        imgCell.lblAddImage2.isHidden = true
                        imgCell.imgCamera2.isHidden = true
                        imgCell.btnDel2.isHidden = false
                    }
                }
                imgCell.delImage2 = { check in
                    imgCell.imgView2.image = UIImage(named: "ImgCapBg")
                    imgCell.lblAddImage2.isHidden = false
                    imgCell.imgCamera2.isHidden = false
                    imgCell.btnDel2.isHidden = true
                }
                return imgCell
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                let headerCell = self.tblPostCheck.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
                headerCell.datasource = "" as AnyObject
                headerCell.lblContent.text = "Sent Parts"
                headerCell.imgContent.image = UIImage(named: "parts")
                return headerCell
            default:
                let partsCell = self.tblPostCheck.dequeueReusableCell(withIdentifier: "SentPartsCell", for: indexPath) as! SentPartsCell
                partsCell.datasource = "" as AnyObject
                partsCell.didCaptureCamera = { check in
                    let postPartVC = mainStoryboard.instantiateViewController(withIdentifier: "PostCheckPartController") as! PostCheckPartController
                    postPartVC.didCaptureData = { unitPosition, permConn, earthConn, ignConn, serial, loom, comments in
                        
                    }
                    NavigationHelper.helper.contentNavController!.pushViewController(postPartVC, animated: true)
                }
                return partsCell
            }
        } else if indexPath.section == 2 {
            switch indexPath.row {
            case 0:
                let headerCell = self.tblPostCheck.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
                headerCell.datasource = "" as AnyObject
                headerCell.lblContent.text = "Buffer Parts"
                headerCell.imgContent.image = UIImage(named: "Spinner")
                return headerCell
            case 1:
                let partsHeaderCell = self.tblPostCheck.dequeueReusableCell(withIdentifier: "BufferPartsHeaderCell", for: indexPath) as! BufferPartsHeaderCell
                partsHeaderCell.datasource = "" as AnyObject
                partsHeaderCell.datasource = "" as AnyObject
                partsHeaderCell.lblParts.text = "Parts"
                partsHeaderCell.lblSerial.text = "Serial"
                partsHeaderCell.lblConsumed.text = "Consumed"
                partsHeaderCell.didAddRow = { add in
                    self.arrBufferPartsId += 1
                    self.arrBufferParts.append((id: self.arrBufferPartsId, partsName: "", serialNo: "", consumed: "Yes", partsImg: UIImage()))
                    self.tblPostCheck.reloadData()
                }
                return partsHeaderCell
            default:
                let partsRowCell = self.tblPostCheck.dequeueReusableCell(withIdentifier: "BufferPartsRowCell", for: indexPath) as! BufferPartsRowCell
                partsRowCell.datasource = "" as AnyObject
                partsRowCell.index = indexPath.row
                partsRowCell.txtParts.text = self.arrBufferParts[indexPath.row - 2].partsName
                partsRowCell.txtSerial.text = self.arrBufferParts[indexPath.row - 2].serialNo
                partsRowCell.txtConsumed.text = self.arrBufferParts[indexPath.row - 2].consumed
                partsRowCell.parts = { check, index in
                    let prodPartsVC = mainStoryboard.instantiateViewController(withIdentifier: "ProductController") as! ProductController
                    prodPartsVC.didSelectProd = { parts in
                        for (indexPart, partsVal) in self.arrBufferParts.enumerated() {
                            if indexPart == index - 2 {
                                self.arrBufferParts.remove(at: indexPart)
                                self.arrBufferParts.insert((id: partsVal.id, partsName: parts, serialNo: partsVal.serialNo, consumed: partsVal.consumed, partsImg: partsVal.partsImg), at: indexPart)
                                self.tblPostCheck.reloadData()
                            }
                        }
                    }
                    NavigationHelper.helper.contentNavController!.pushViewController(prodPartsVC, animated: true)
                }
                partsRowCell.serialNo = { val, index in
                    for (indexPart, partsVal) in self.arrBufferParts.enumerated() {
                        if indexPart == index - 2 {
                            self.arrBufferParts.remove(at: indexPart)
                            self.arrBufferParts.insert((id: partsVal.id, partsName: partsVal.partsName, serialNo: val, consumed: partsVal.consumed, partsImg: partsVal.partsImg), at: indexPart)
                            self.tblPostCheck.reloadData()
                        }
                    }
                }
                partsRowCell.didSendSignalConsumed = { val in
                    PickerViewController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, arrPickerVal: ["Yes", "No"]) { val in
                        
                        self.tblPostCheck.reloadData()
                    } didFinish: { txt in
                        
                    }
                }
                return partsRowCell
            }
        } else if indexPath.section == 3 {
            switch indexPath.row {
            case 0:
                let headerCell = self.tblPostCheck.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
                headerCell.datasource = "" as AnyObject
                headerCell.lblContent.text = "Parts to Return"
                headerCell.imgContent.image = UIImage(named: "ArrowUDownLeft")
                return headerCell
            case 1:
                let partsHeaderCell = self.tblPostCheck.dequeueReusableCell(withIdentifier: "BufferPartsHeaderCell", for: indexPath) as! BufferPartsHeaderCell
                partsHeaderCell.datasource = "" as AnyObject
                partsHeaderCell.lblParts.text = "Parts"
                partsHeaderCell.lblSerial.text = "Serial"
                partsHeaderCell.lblConsumed.text = "Returned by"
                partsHeaderCell.didAddRow = { add in
                    self.arrPartsReturnId += 1
                    self.arrPartsToReturn.append((id: self.arrPartsReturnId, partsName: "", serialNo: "", returnedBy: "Yes", partsImg: UIImage()))
                    self.tblPostCheck.reloadData()
                }
                return partsHeaderCell
            default:
                let partsRowCell = self.tblPostCheck.dequeueReusableCell(withIdentifier: "BufferPartsRowCell", for: indexPath) as! BufferPartsRowCell
                partsRowCell.datasource = "" as AnyObject
                partsRowCell.index = indexPath.row
                partsRowCell.txtParts.text = self.arrPartsToReturn[indexPath.row - 2].partsName
                partsRowCell.txtSerial.text = self.arrPartsToReturn[indexPath.row - 2].serialNo
                partsRowCell.txtConsumed.text = self.arrPartsToReturn[indexPath.row - 2].returnedBy
                partsRowCell.parts = { check, index in
                    let prodPartsVC = mainStoryboard.instantiateViewController(withIdentifier: "ProductController") as! ProductController
                    prodPartsVC.didSelectProd = { parts in
                        for (indexPart, partsVal) in self.arrPartsToReturn.enumerated() {
                            if indexPart == index - 2 {
                                self.arrPartsToReturn.remove(at: indexPart)
                                self.arrPartsToReturn.insert((id: partsVal.id, partsName: parts, serialNo: partsVal.serialNo, returnedBy: partsVal.returnedBy, partsImg: partsVal.partsImg), at: indexPart)
                                self.tblPostCheck.reloadData()
                            }
                        }
                    }
                    NavigationHelper.helper.contentNavController!.pushViewController(prodPartsVC, animated: true)
                }
                partsRowCell.serialNo = { val, index in
                    for (indexPart, partsVal) in self.arrPartsToReturn.enumerated() {
                        if indexPart == index - 2 {
                            self.arrPartsToReturn.remove(at: indexPart)
                            self.arrPartsToReturn.insert((id: partsVal.id, partsName: partsVal.partsName, serialNo: val, returnedBy: partsVal.returnedBy, partsImg: partsVal.partsImg), at: indexPart)
                            self.tblPostCheck.reloadData()
                        }
                    }
                }
                partsRowCell.didSendSignalConsumed = { val in
                    PickerViewController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, arrPickerVal: ["Yes", "No"]) { val in
                        
                        self.tblPostCheck.reloadData()
                    } didFinish: { txt in
                        
                    }
                }
                return partsRowCell
            }
        } else if indexPath.section == 4 {
            switch indexPath.row {
            case 0:
                let headerCell = self.tblPostCheck.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
                headerCell.datasource = "" as AnyObject
                headerCell.lblContent.text = "Issues"
                headerCell.imgContent.image = UIImage(named: "TestReport")
                return headerCell
            case 1:
                let issueCell = self.tblPostCheck.dequeueReusableCell(withIdentifier: "ElectricalIssueCell", for: indexPath) as! ElectricalIssueCell
                issueCell.datasource = "Electrical" as AnyObject
                issueIndexElectrical = indexPath.row
                issueCell.didSendYes = { check in
                    self.isIssueElectrical = check
                    self.tblPostCheck.reloadData()
                }
                issueCell.arrImg = self.arrImgElectricalIssue
                issueCell.didcaptureCamera = { capture in
                    CameraHandler.shared.showActionSheet(vc: self)
                    CameraHandler.shared.imagePickedBlock = { (image) in
                        self.arrImgElectricalIssue.append(image)
                        self.tblPostCheck.reloadData()
                    }
                }
                return issueCell
            case 2:
                let issueCell = self.tblPostCheck.dequeueReusableCell(withIdentifier: "ExteriorIssueCell", for: indexPath) as! ExteriorIssueCell
                issueCell.datasource = "Exterior" as AnyObject
                issueCell.didSendYes = { check in
                    self.isIssueExterior = check
                    self.tblPostCheck.reloadData()
                }
                issueCell.arrImg = self.arrImgExteriorIssue
                issueCell.didcaptureCamera = { capture in
                    CameraHandler.shared.showActionSheet(vc: self)
                    CameraHandler.shared.imagePickedBlock = { (image) in
                        self.arrImgExteriorIssue.append(image)
                        self.tblPostCheck.reloadData()
                    }
                }
                return issueCell
            default:
                let issueCell = self.tblPostCheck.dequeueReusableCell(withIdentifier: "InteriorIssueCell", for: indexPath) as! InteriorIssueCell
                issueCell.datasource = "Interior" as AnyObject
                issueCell.didSendYes = { check in
                    self.isIssueInterior = check
                    self.tblPostCheck.reloadData()
                }
                issueCell.arrImg = self.arrImgInteriorIssue
                issueCell.didcaptureCamera = { capture in
                    CameraHandler.shared.showActionSheet(vc: self)
                    CameraHandler.shared.imagePickedBlock = { (image) in
                        self.arrImgInteriorIssue.append(image)
                        self.tblPostCheck.reloadData()
                    }
                }
                return issueCell
            }
        } else if indexPath.section == 5 {
            switch indexPath.row {
            case 0:
                let headerCell = self.tblPostCheck.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
                headerCell.datasource = "" as AnyObject
                headerCell.lblContent.text = "Declaration"
                headerCell.imgContent.image = UIImage(named: "declaration")
                return headerCell
            default:
                let engDeclCell = self.tblPostCheck.dequeueReusableCell(withIdentifier: "EngineersDeclarationCell", for: indexPath) as! EngineersDeclarationCell
                engDeclCell.datasource = "" as AnyObject
                return engDeclCell
            }
        } else if indexPath.section == 6 {
            switch indexPath.row {
            case 0:
                let headerCell = self.tblPostCheck.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
                headerCell.datasource = "" as AnyObject
                headerCell.lblContent.text = "Engineer Signature"
                headerCell.imgContent.image = UIImage(named: "Signature")
                return headerCell
            default:
                let signCell = self.tblPostCheck.dequeueReusableCell(withIdentifier: "EngineerSignatureCell", for: indexPath) as! EngineerSignatureCell
                signCell.datasource = "" as AnyObject
                return signCell
            }
        } else if indexPath.section == 7 {
            switch indexPath.row {
            case 0:
                let headerCell = self.tblPostCheck.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
                headerCell.datasource = "" as AnyObject
                headerCell.lblContent.text = "Customer Signature"
                headerCell.imgContent.image = UIImage(named: "Signature")
                return headerCell
            default:
                let signCell = self.tblPostCheck.dequeueReusableCell(withIdentifier: "CustomerSignatureCell", for: indexPath) as! CustomerSignatureCell
                signCell.datasource = "" as AnyObject
                return signCell
            }
        } else {
            let saveCell = self.tblPostCheck.dequeueReusableCell(withIdentifier: "SaveCell", for: indexPath) as! SaveCell
            saveCell.datasource = "" as AnyObject
            saveCell.didSave = { save in
                self.isSave = save
            }
            saveCell.didReset = { reset in
                self.isReset = reset
                self.tblPostCheck.reloadData()
            }
            return saveCell
        }
    }
}

// MARK: SentPartsCell
class SentPartsCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collParts: UICollectionView!
    var didCaptureCamera:((Bool) -> ())!
    var selectedParts: Int = 0
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                collParts.layer.cornerRadius = 10.0
                collParts.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let partsCell = self.collParts.dequeueReusableCell(withReuseIdentifier: "SentPartsCollectionCell", for: indexPath) as! SentPartsCollectionCell
        partsCell.datasource = "" as AnyObject
        partsCell.didCaptureCamera = { check in
            self.didCaptureCamera!(check)
        }
        if indexPath.item == selectedParts {
            partsCell.parentView.backgroundColor = UIColor.blueColor
            partsCell.lblPart.textColor = .white
            partsCell.lblSerial.textColor = .white
            partsCell.lblReturnedBy.textColor = .white
            partsCell.lblUsed.textColor = .white
        } else {
            partsCell.parentView.backgroundColor = UIColor.init(hexString: "E3E6EE")
            partsCell.lblPart.textColor = UIColor.fontColor
            partsCell.lblSerial.textColor = UIColor.fontColor
            partsCell.lblReturnedBy.textColor = UIColor.fontColor
            partsCell.lblUsed.textColor = UIColor.fontColor
        }
        return partsCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedParts = indexPath.item
        self.collParts.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 343.0, height: 130.0)
    }
}


// MARK: SentPartsCollCell
class SentPartsCollectionCell: BaseCollectionViewCell {
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var lblPart: UILabel!
    @IBOutlet weak var lblSerial: UILabel!
    @IBOutlet weak var lblReturnedBy: UILabel!
    @IBOutlet weak var lblUsed: UILabel!
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var btnCamera: UIButton!
    @IBOutlet weak var viewCamera: UIView!
    var didCaptureCamera:((Bool) -> ())!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                parentView.layer.cornerRadius = 10.0
                viewCamera.layer.cornerRadius = 15.0
                let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
                segment.setTitleTextAttributes(titleTextAttributes, for: .normal)
                segment.setTitleTextAttributes(titleTextAttributes, for: .selected)
                segment.layer.cornerRadius = 15.0
                segment.layer.masksToBounds = true
                btnCamera.addTarget(self, action: #selector(cameraParts), for: .touchUpInside)
            }
        }
    }
    
    @objc func cameraParts(_ sender: UIButton) {
        self.didCaptureCamera!(true)
    }
}


// MARK: BufferPartsHeaderCell
class BufferPartsHeaderCell: BaseTableViewCell {
    @IBOutlet weak var lblParts: UILabel!
    @IBOutlet weak var lblSerial: UILabel!
    @IBOutlet weak var lblConsumed: UILabel!
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var parentView: UIView!
    var didAddRow:((Bool) -> ())!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                parentView.layer.cornerRadius = 10.0
                btnPlus.addTarget(self, action: #selector(plus), for: .touchUpInside)
            }
        }
    }
    
    @objc func plus(_ sender: UIButton) {
        self.didAddRow!(true)
    }
}


// MARK: BufferPartsRowCell
class BufferPartsRowCell: BaseTableViewCell, UITextFieldDelegate {
    @IBOutlet weak var txtParts: UILabel!
    @IBOutlet weak var btnParts: UIButton!
    @IBOutlet weak var txtSerial: CustomTextField!
    @IBOutlet weak var txtConsumed: CustomTextField!
    @IBOutlet weak var btnDots: UIButton!
    @IBOutlet weak var parentView: UIView!
    var index: Int!
    var didSendSignalConsumed:((Bool) -> ())!
    var didAddRow:((Bool) -> ())!
    var parts:((Bool, Int) -> ())!
    var serialNo:((String, Int) -> ())!
    var didSendSignal:((Bool) -> ())!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                parentView.layer.cornerRadius = 10.0
                btnDots.addTarget(self, action: #selector(dots), for: .touchUpInside)
                btnParts.addTarget(self, action: #selector(products), for: .touchUpInside)
            }
        }
    }
    
    @objc func products(_ sender: UIButton) {
        self.parts!(true, index)
    }
    
    @objc func dots(_ sender: UIButton) {
        self.didSendSignal!(true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == txtConsumed {
            self.didSendSignalConsumed!(true)
            return false
        } else {
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.serialNo!(textField.text ?? "", index)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


// MARK: EngineersDeclarationCell
class EngineersDeclarationCell: BaseTableViewCell, UITextViewDelegate {
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var txtView: UITextView!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                parentView.layer.cornerRadius = 10.0
            }
        }
    }
}

// MARK: EngineerSignatureCell
class EngineerSignatureCell: BaseTableViewCell, UITextFieldDelegate {
    @IBOutlet weak var signatureView: SignatureView!
    @IBOutlet weak var txtEngName: CustomTextField!
    @IBOutlet weak var txtEngCode: CustomTextField!
    @IBOutlet weak var viewBG: UIView!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                viewBG.layer.cornerRadius = 10.0
                signatureView.layer.cornerRadius = 10.0
                setupViews()
                signatureView.setStrokeColor(color: .black)
                txtEngCode.layer.cornerRadius = 25.0
                txtEngName.layer.cornerRadius = 25.0
            }
        }
    }
    
    func setupViews() {
        signatureView.layer.borderWidth = 0.5
        signatureView.layer.borderColor = UIColor.black.cgColor
        signatureView.layer.cornerRadius = 10
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: CustomerSignatureCell
class CustomerSignatureCell: BaseTableViewCell, UITextFieldDelegate {
    @IBOutlet weak var signatureView: SignatureView!
    @IBOutlet weak var txtName: CustomTextField!
    @IBOutlet weak var txtPosition: CustomTextField!
    @IBOutlet weak var txtEmailAdd: CustomTextField!
    @IBOutlet weak var viewBG: UIView!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                viewBG.layer.cornerRadius = 10.0
                signatureView.layer.cornerRadius = 10.0
                setupViews()
                signatureView.setStrokeColor(color: .black)
                txtName.layer.cornerRadius = 25.0
                txtPosition.layer.cornerRadius = 25.0
                txtEmailAdd.layer.cornerRadius = 25.0
            }
        }
    }
    
    func setupViews() {
        signatureView.layer.borderWidth = 0.5
        signatureView.layer.borderColor = UIColor.black.cgColor
        signatureView.layer.cornerRadius = 10
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
