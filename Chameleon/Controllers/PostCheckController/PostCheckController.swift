//
//  PostCheckController.swift
//  Chameleon
//
//  Created by SHATADRU DATTA on 04/03/24.
//

import UIKit

struct PostCheckData {
    static var front_img = UIImage()
    static var front_img_base64 = ""
    static var rear_img = UIImage()
    static var rear_img_base64 = ""
    static var passengerSide_img = UIImage()
    static var passengerSide_img_base64 = ""
    static var driverSide_img = UIImage()
    static var driverSide_img_base64 = ""
    static var arrBufferParts: [(id: Int, partsName: String, serialNo: String, consumed: String, imgUnit: UIImage, isImgUnit: Bool, imgPerm: UIImage, isImgPerm: Bool, imgEarth: UIImage, isImgEarth: Bool, imgIgn: UIImage, isImgIgn: Bool, imgSerial: UIImage, isImgSerial: Bool, imgLoom: UIImage, isImgLoom: Bool, comments: String)] = []
    static var arrPartsToReturn: [(id: Int, partsName: String, serialNo: String, returnedBy: String, imgUnit: UIImage, isImgUnit: Bool, imgPerm: UIImage, isImgPerm: Bool, imgEarth: UIImage, isImgEarth: Bool, imgIgn: UIImage, isImgIgn: Bool, imgSerial: UIImage, isImgSerial: Bool, imgLoom: UIImage, isImgLoom: Bool, comments: String)] = []
    static var isElectricalIssue = false
    static var electricalIssueTxt = ""
    static var arrImgElectricalIssue: [UIImage] = []
    static var arrImgElectricalIssueBase64: [String] = []
    static var isExteriorIssue = false
    static var exteriorIssueTxt = ""
    static var arrImgExteriorIssue: [UIImage] = []
    static var arrImageExteriorIssueBase64: [String] = []
    static var isInteriorIssue = false
    static var interiorIssueTxt = ""
    static var arrImgInteriorIssue: [UIImage] = []
    static var arrImgInteriorIssueBase64: [String] = []
    static var declaration = ""
    static var engineerSignature = UIImage()
    static var engineerSignature_base64 = ""
    static var engineerName = ""
    static var engineerCode = ""
    static var customerSignature = UIImage()
    static var customerSignature_base64 = ""
    static var customerName = ""
    static var customerPosition = ""
    static var emailAddress = ""
    static var isSendCopy = false
    static var bufferParts_base64: [(id: Int, partsName: String, serialNo: String, consumed: String, imgUnitBase64: String, imgPermBase64: String, imgEarthBase64: String, imgIgnBase64: String, imgSerialBase64: String, imgLoomBase64: String)] = []
    static var partsReturn_base64: [(id: Int, partsName: String, serialNo: String, returnedBy: String, imgUnitBase64: String, imgPermBase64: String, imgEarthBase64: String, imgIgnBase64: String, imgSerialBase64: String, imgLoomBase64: String)] = []
    static var sentParts_base64: [(id: Int, partsName: String, serial1: String, serial2: String, returnedBy: String, used: String, imgUnitBase64: String, imgPermBase64: String, imgEarthBase64: String, imgIgnBase64: String, imgSerialBase64: String, imgLoomBase64: String)] = []
}

class PostCheckController: BaseViewController {
    @IBOutlet weak var activity: UIActivityIndicatorView!
    var isReset: Bool = false
    var isSave: Bool = false
    @IBOutlet weak var lblNcNumber: UILabel!
    @IBOutlet weak var tblPostCheck: UITableView!
    @IBOutlet weak var viewPreCheck: UIView!
    @IBOutlet weak var viewPostCheck: UIView!
    @IBOutlet weak var viewClosure: UIView!
    var arrBufferPartsId: Int = 0
    
    var arrPartsReturnId: Int = 0
    
    var arrImg: [UIImage] = []
   
    var checkController: Bool = false
    
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
        self.lblNcNumber.text = JobSheetData.nc_bnc_number
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(PostCheckController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PostCheckController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            print("Notification: Keyboard will show")
            tblPostCheck.setBottomInset(to: keyboardHeight)
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        print("Notification: Keyboard will hide")
        tblPostCheck.setBottomInset(to: 0.0)
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
            return arrPartsSerial.count
        case 2:
            return 2 + PostCheckData.arrBufferParts.count
        case 3:
            return 2 + PostCheckData.arrPartsToReturn.count
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
                if PostCheckData.isElectricalIssue {
                    if PostCheckData.arrImgElectricalIssue.count > 0 {
                        return 245.0
                    } else {
                        return 180.0
                    }
                } else {
                    return 50.0
                }
            case 2:
                if PostCheckData.isExteriorIssue {
                    if PostCheckData.arrImgExteriorIssue.count > 0 {
                        return 245.0
                    } else {
                        return 180.0
                    }
                } else {
                    return 50.0
                }
            default:
                if PostCheckData.isInteriorIssue {
                    if PostCheckData.arrImgInteriorIssue.count > 0 {
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
                if isReset {
                    imgCell.imgView1.image = UIImage(named: "ImgCapBg")
                    imgCell.lblAddImage1.isHidden = false
                    imgCell.imgCamera1.isHidden = false
                    imgCell.btnDel1.isHidden = true
                    imgCell.imgView2.image = UIImage(named: "ImgCapBg")
                    imgCell.lblAddImage2.isHidden = false
                    imgCell.imgCamera2.isHidden = false
                    imgCell.btnDel2.isHidden = true
                }
                imgCell.lblImg1.text = "Front"
                imgCell.lblImg2.text = "Rear"
                imgCell.didFirstImg = { val in
                    CameraHandler.shared.showActionSheet(vc: self)
                    CameraHandler.shared.imagePickedBlock = { (image) in
                        PostCheckData.front_img = image
                        DispatchQueue.background(background: {
                            PostCheckData.front_img_base64 = image.toBase64() ?? ""
                        }, completion:{
                        })
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
                        PostCheckData.rear_img = image
                        DispatchQueue.background(background: {
                            PostCheckData.rear_img_base64 = image.toBase64() ?? ""
                        }, completion:{
                        })
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
                if isReset {
                    imgCell.imgView1.image = UIImage(named: "ImgCapBg")
                    imgCell.lblAddImage1.isHidden = false
                    imgCell.imgCamera1.isHidden = false
                    imgCell.btnDel1.isHidden = true
                    imgCell.imgView2.image = UIImage(named: "ImgCapBg")
                    imgCell.lblAddImage2.isHidden = false
                    imgCell.imgCamera2.isHidden = false
                    imgCell.btnDel2.isHidden = true
                }
                imgCell.lblImg1.text = "Passenger Side"
                imgCell.lblImg2.text = "Driver Side"
                imgCell.didFirstImg = { val in
                    CameraHandler.shared.showActionSheet(vc: self)
                    CameraHandler.shared.imagePickedBlock = { (image) in
                        PostCheckData.passengerSide_img = image
                        DispatchQueue.background(background: {
                            PostCheckData.passengerSide_img_base64 = image.toBase64() ?? ""
                        }, completion:{
                        })
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
                        PostCheckData.driverSide_img = image
                        DispatchQueue.background(background: {
                            PostCheckData.driverSide_img_base64 = image.toBase64() ?? ""
                        }, completion:{
                        })
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
                partsCell.arrPartsSerial = arrPartsSerial
                partsCell.didCaptureCamera = { check, partsIndex in
                    let postPartVC = mainStoryboard.instantiateViewController(withIdentifier: "PostCheckPartController") as! PostCheckPartController
                    postPartVC.index = partsIndex
                    postPartVC.unitPosition = arrPartsSerial[partsIndex - 1].imgUnit
                    postPartVC.isUnitPositionImg = arrPartsSerial[partsIndex - 1].isImgUnit
                    postPartVC.permConn = arrPartsSerial[partsIndex - 1].imgPerm
                    postPartVC.isPermConnImg = arrPartsSerial[partsIndex - 1].isImgPerm
                    postPartVC.earthConn = arrPartsSerial[partsIndex - 1].imgEarth
                    postPartVC.isEarthConnImg = arrPartsSerial[partsIndex - 1].isImgEarth
                    postPartVC.ignConn = arrPartsSerial[partsIndex - 1].imgIgn
                    postPartVC.isIgnConnImg = arrPartsSerial[partsIndex - 1].isImgIgn
                    postPartVC.serial = arrPartsSerial[partsIndex - 1].imgSerial
                    postPartVC.isSerialImg = arrPartsSerial[partsIndex - 1].isImgSerial
                    postPartVC.loom = arrPartsSerial[partsIndex - 1].imgLoom
                    postPartVC.isLoomImg = arrPartsSerial[partsIndex - 1].isImgLoom
                    postPartVC.commnets = arrPartsSerial[partsIndex - 1].comments
                    postPartVC.didCaptureData = { index, unitPosition, isImgUnit, permConn, isImgPerm, earthConn, isImgEarth, ignConn, isImgIgn, serial, isImgSerial, loom, isImgLoom, comments in
                        for (partsIndex, val) in arrPartsSerial.enumerated() {
                            if partsIndex == index {
                                arrPartsSerial.remove(at: partsIndex)
                                arrPartsSerial.insert((id: val.id, ncNo: val.ncNo, serialPart1: val.serialPart1, serialPart2: val.serialPart2, prodName: val.prodName, prodId: val.prodId, quantity: val.quantity, returnedBy: val.returnedBy, used: val.used, imgUnit: unitPosition, isImgUnit: isImgUnit, imgPerm: permConn, isImgPerm: isImgPerm, imgEarth: earthConn, isImgEarth: isImgEarth, imgIgn: ignConn, isImgIgn: isImgIgn, imgSerial: serial, isImgSerial: isImgSerial, imgLoom: loom, isImgLoom: isImgLoom, comments: comments), at: partsIndex)
                                self.tblPostCheck.reloadData()
                            }
                        }
                    }
                    NavigationHelper.helper.contentNavController!.pushViewController(postPartVC, animated: true)
                }
                partsCell.didSegmentindex = { index, partsIndex in
                    for (indexPart, partVal) in arrPartsSerial.enumerated() {
                        if indexPart == partsIndex {
                            arrPartsSerial.remove(at: indexPart)
                            arrPartsSerial.insert((id: partVal.id, ncNo: partVal.ncNo, serialPart1: partVal.serialPart1, serialPart2: partVal.serialPart2, prodName: partVal.prodName, prodId: partVal.prodId, quantity: partVal.quantity, returnedBy: partVal.returnedBy, used: index == 0 ? true : false, imgUnit: partVal.imgUnit, isImgUnit: partVal.isImgUnit, imgPerm: partVal.imgPerm, isImgPerm: partVal.isImgPerm, imgEarth: partVal.imgEarth, isImgEarth: partVal.isImgEarth, imgIgn: partVal.imgIgn, isImgIgn: partVal.isImgIgn, imgSerial: partVal.imgSerial, isImgSerial: partVal.isImgSerial, imgLoom: partVal.imgLoom, isImgLoom: partVal.isImgLoom, comments: partVal.comments), at: indexPart)
                            self.tblPostCheck.reloadData()
                        }
                    }
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
                    PostCheckData.arrBufferParts.append((id: self.arrBufferPartsId, partsName: "", serialNo: "", consumed: "", imgUnit: UIImage(named: "ImgCapBg") ?? UIImage(), isImgUnit: false, imgPerm: UIImage(named: "ImgCapBg") ?? UIImage(), isImgPerm: false, imgEarth: UIImage(named: "ImgCapBg") ?? UIImage(), isImgEarth: false, imgIgn: UIImage(named: "ImgCapBg") ?? UIImage(), isImgIgn: false, imgSerial: UIImage(named: "ImgCapBg") ?? UIImage(), isImgSerial: false, imgLoom: UIImage(named: "ImgCapBg") ?? UIImage(), isImgLoom: false, comments: ""))
                    self.tblPostCheck.reloadData()
                }
                return partsHeaderCell
            default:
                let partsRowCell = self.tblPostCheck.dequeueReusableCell(withIdentifier: "BufferPartsRowCell", for: indexPath) as! BufferPartsRowCell
                partsRowCell.datasource = "" as AnyObject
                partsRowCell.index = indexPath.row
                partsRowCell.txtParts.text = PostCheckData.arrBufferParts[indexPath.row - 2].partsName
                partsRowCell.txtSerial.text = PostCheckData.arrBufferParts[indexPath.row - 2].serialNo
                partsRowCell.txtConsumed.text = PostCheckData.arrBufferParts[indexPath.row - 2].consumed
                
                partsRowCell.parts = { check, index in
                    let prodPartsVC = mainStoryboard.instantiateViewController(withIdentifier: "ProductController") as! ProductController
                    prodPartsVC.didSelectProd = { parts in
                        for (indexPart, partsVal) in PostCheckData.arrBufferParts.enumerated() {
                            if indexPart == index - 2 {
                                PostCheckData.arrBufferParts.remove(at: indexPart)
                                PostCheckData.arrBufferParts.insert((id: partsVal.id, partsName: parts, serialNo: partsVal.serialNo, consumed: partsVal.consumed, imgUnit: partsVal.imgUnit, isImgUnit: partsVal.isImgUnit, imgPerm: partsVal.imgPerm, isImgPerm: partsVal.isImgPerm, imgEarth: partsVal.imgEarth, isImgEarth: partsVal.isImgEarth, imgIgn: partsVal.imgIgn, isImgIgn: partsVal.isImgIgn, imgSerial: partsVal.imgSerial, isImgSerial: partsVal.isImgSerial, imgLoom: partsVal.imgLoom, isImgLoom: partsVal.isImgLoom, comments: partsVal.comments), at: indexPart)
                                self.tblPostCheck.reloadData()
                            }
                        }
                    }
                    NavigationHelper.helper.contentNavController!.pushViewController(prodPartsVC, animated: true)
                }
                partsRowCell.serialNo = { serialNo, index in
                    for (indexPart, partsVal) in PostCheckData.arrBufferParts.enumerated() {
                        if indexPart == index - 2 {
                            PostCheckData.arrBufferParts.remove(at: indexPart)
                            PostCheckData.arrBufferParts.insert((id: partsVal.id, partsName: partsVal.partsName, serialNo: serialNo, consumed: partsVal.consumed, imgUnit: partsVal.imgUnit, isImgUnit: partsVal.isImgUnit, imgPerm: partsVal.imgPerm, isImgPerm: partsVal.isImgPerm, imgEarth: partsVal.imgEarth, isImgEarth: partsVal.isImgEarth, imgIgn: partsVal.imgIgn, isImgIgn: partsVal.isImgIgn, imgSerial: partsVal.imgSerial, isImgSerial: partsVal.isImgSerial, imgLoom: partsVal.imgLoom, isImgLoom: partsVal.isImgLoom, comments: partsVal.comments), at: indexPart)
                            self.tblPostCheck.reloadData()
                        }
                    }
                }
                partsRowCell.didSendSignalConsumed = { val in
                    PickerViewController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!, arrPickerVal: ["Yes/\(indexPath.row)", "No/\(indexPath.row)"]) { val in
                        let index: Int = Int(val.components(separatedBy: "/")[1]) ?? 0
                        let consumed = val.components(separatedBy: "/")[0]
                        for (indexPart, partsVal) in PostCheckData.arrBufferParts.enumerated() {
                            if indexPart == index - 2 {
                                PostCheckData.arrBufferParts.remove(at: indexPart)
                                PostCheckData.arrBufferParts.insert((id: partsVal.id, partsName: partsVal.partsName, serialNo: partsVal.serialNo, consumed: consumed, imgUnit: partsVal.imgUnit, isImgUnit: partsVal.isImgUnit, imgPerm: partsVal.imgPerm, isImgPerm: partsVal.isImgPerm, imgEarth: partsVal.imgEarth, isImgEarth: partsVal.isImgEarth, imgIgn: partsVal.imgIgn, isImgIgn: partsVal.isImgIgn, imgSerial: partsVal.imgSerial, isImgSerial: partsVal.isImgSerial, imgLoom: partsVal.imgLoom, isImgLoom: partsVal.isImgLoom, comments: partsVal.comments), at: indexPart)
                                self.tblPostCheck.reloadData()
                            }
                        }
                    } didFinish: { txt in
                        
                    }
                }
                partsRowCell.didSendSignal = { chk, index in
                    let postPartVC = mainStoryboard.instantiateViewController(withIdentifier: "PostCheckPartController") as! PostCheckPartController
                    postPartVC.index = index - 2
                    postPartVC.unitPosition = PostCheckData.arrBufferParts[index - 2].imgUnit
                    postPartVC.isUnitPositionImg = PostCheckData.arrBufferParts[index - 2].isImgUnit
                    postPartVC.permConn = PostCheckData.arrBufferParts[index - 2].imgPerm
                    postPartVC.isPermConnImg = PostCheckData.arrBufferParts[index - 2].isImgPerm
                    postPartVC.earthConn = PostCheckData.arrBufferParts[index - 2].imgEarth
                    postPartVC.isEarthConnImg = PostCheckData.arrBufferParts[index - 2].isImgEarth
                    postPartVC.ignConn = PostCheckData.arrBufferParts[index - 2].imgIgn
                    postPartVC.isIgnConnImg = PostCheckData.arrBufferParts[index - 2].isImgIgn
                    postPartVC.serial = PostCheckData.arrBufferParts[index - 2].imgSerial
                    postPartVC.isSerialImg = PostCheckData.arrBufferParts[index - 2].isImgSerial
                    postPartVC.loom = PostCheckData.arrBufferParts[index - 2].imgLoom
                    postPartVC.isLoomImg = PostCheckData.arrBufferParts[index - 2].isImgLoom
                    postPartVC.commnets = PostCheckData.arrBufferParts[index - 2].comments
                    postPartVC.didCaptureData = { index, unitPosition, isImgUnit, permConn, isImgPerm, earthConn, isImgEarth, ignConn, isImgIgn, serial, isImgSerial, loom, isImgLoom, comments in
                        for (partsIndex, val) in PostCheckData.arrBufferParts.enumerated() {
                            if partsIndex == index {
                                PostCheckData.arrBufferParts.remove(at: partsIndex)
                                PostCheckData.arrBufferParts.insert((id: val.id, partsName: val.partsName, serialNo: val.serialNo, consumed: val.consumed, imgUnit: unitPosition, isImgUnit: isImgUnit, imgPerm: permConn, isImgPerm: isImgPerm, imgEarth: earthConn, isImgEarth: isImgEarth, imgIgn: ignConn, isImgIgn: isImgIgn, imgSerial: serial, isImgSerial: isImgSerial, imgLoom: loom, isImgLoom: isImgLoom, comments: comments), at: partsIndex)
                            }
                        }
                    }
                    NavigationHelper.helper.contentNavController!.pushViewController(postPartVC, animated: true)
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
                    PostCheckData.arrPartsToReturn.append((id: self.arrPartsReturnId, partsName: "", serialNo: "", returnedBy: "Yes", imgUnit: UIImage(named: "ImgCapBg") ?? UIImage(), isImgUnit: false, imgPerm: UIImage(named: "ImgCapBg") ?? UIImage(), isImgPerm: false, imgEarth: UIImage(named: "ImgCapBg") ?? UIImage(), isImgEarth: false, imgIgn: UIImage(named: "ImgCapBg") ?? UIImage(), isImgIgn: false, imgSerial: UIImage(named: "ImgCapBg") ?? UIImage(), isImgSerial: false, imgLoom: UIImage(named: "ImgCapBg") ?? UIImage(), isImgLoom: false, comments: ""))
                    self.tblPostCheck.reloadData()
                }
                return partsHeaderCell
            default:
                let partsRowCell = self.tblPostCheck.dequeueReusableCell(withIdentifier: "BufferPartsRowCell", for: indexPath) as! BufferPartsRowCell
                partsRowCell.datasource = "" as AnyObject
                partsRowCell.index = indexPath.row
                partsRowCell.txtParts.text = PostCheckData.arrPartsToReturn[indexPath.row - 2].partsName
                partsRowCell.txtSerial.text = PostCheckData.arrPartsToReturn[indexPath.row - 2].serialNo
                partsRowCell.txtConsumed.text = PostCheckData.arrPartsToReturn[indexPath.row - 2].returnedBy
                
                partsRowCell.parts = { check, index in
                    let prodPartsVC = mainStoryboard.instantiateViewController(withIdentifier: "ProductController") as! ProductController
                    prodPartsVC.didSelectProd = { parts in
                        for (indexPart, partsVal) in PostCheckData.arrPartsToReturn.enumerated() {
                            if indexPart == index - 2 {
                                PostCheckData.arrPartsToReturn.remove(at: indexPart)
                                PostCheckData.arrPartsToReturn.insert((id: partsVal.id, partsName: parts, serialNo: partsVal.serialNo, returnedBy: partsVal.returnedBy, imgUnit: partsVal.imgUnit, isImgUnit: partsVal.isImgUnit, imgPerm: partsVal.imgPerm, isImgPerm: partsVal.isImgPerm, imgEarth: partsVal.imgEarth, isImgEarth: partsVal.isImgEarth, imgIgn: partsVal.imgIgn, isImgIgn: partsVal.isImgIgn, imgSerial: partsVal.imgSerial, isImgSerial: partsVal.isImgSerial, imgLoom: partsVal.imgLoom, isImgLoom: partsVal.isImgLoom, comments: partsVal.comments), at: indexPart)
                                self.tblPostCheck.reloadData()
                            }
                        }
                    }
                    NavigationHelper.helper.contentNavController!.pushViewController(prodPartsVC, animated: true)
                }
                partsRowCell.serialNo = { serialNo, index in
                    for (indexPart, partsVal) in PostCheckData.arrPartsToReturn.enumerated() {
                        if indexPart == index - 2 {
                            PostCheckData.arrPartsToReturn.remove(at: indexPart)
                            PostCheckData.arrPartsToReturn.insert((id: partsVal.id, partsName: partsVal.partsName, serialNo: serialNo, returnedBy: partsVal.returnedBy, imgUnit: partsVal.imgUnit, isImgUnit: partsVal.isImgUnit, imgPerm: partsVal.imgPerm, isImgPerm: partsVal.isImgPerm, imgEarth: partsVal.imgEarth, isImgEarth: partsVal.isImgEarth, imgIgn: partsVal.imgIgn, isImgIgn: partsVal.isImgIgn, imgSerial: partsVal.imgSerial, isImgSerial: partsVal.isImgSerial, imgLoom: partsVal.imgLoom, isImgLoom: partsVal.isImgLoom, comments: partsVal.comments), at: indexPart)
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
                partsRowCell.didSendSignal = { chk, index in
                    let postPartVC = mainStoryboard.instantiateViewController(withIdentifier: "PostCheckPartController") as! PostCheckPartController
                    postPartVC.index = index - 2
                    postPartVC.unitPosition = PostCheckData.arrPartsToReturn[index - 2].imgUnit
                    postPartVC.isUnitPositionImg = PostCheckData.arrPartsToReturn[index - 2].isImgUnit
                    postPartVC.permConn = PostCheckData.arrPartsToReturn[index - 2].imgPerm
                    postPartVC.isPermConnImg = PostCheckData.arrPartsToReturn[index - 2].isImgPerm
                    postPartVC.earthConn = PostCheckData.arrPartsToReturn[index - 2].imgEarth
                    postPartVC.isEarthConnImg = PostCheckData.arrPartsToReturn[index - 2].isImgEarth
                    postPartVC.ignConn = PostCheckData.arrPartsToReturn[index - 2].imgIgn
                    postPartVC.isIgnConnImg = PostCheckData.arrPartsToReturn[index - 2].isImgIgn
                    postPartVC.serial = PostCheckData.arrPartsToReturn[index - 2].imgSerial
                    postPartVC.isSerialImg = PostCheckData.arrPartsToReturn[index - 2].isImgSerial
                    postPartVC.loom = PostCheckData.arrPartsToReturn[index - 2].imgLoom
                    postPartVC.isLoomImg = PostCheckData.arrPartsToReturn[index - 2].isImgLoom
                    postPartVC.commnets = PostCheckData.arrPartsToReturn[index - 2].comments
                    postPartVC.didCaptureData = { index, unitPosition, isImgUnit, permConn, isImgPerm, earthConn, isImgEarth, ignConn, isImgIgn, serial, isImgSerial, loom, isImgLoom, comments in
                        for (partsIndex, val) in PostCheckData.arrPartsToReturn.enumerated() {
                            if partsIndex == index {
                                PostCheckData.arrPartsToReturn.remove(at: partsIndex)
                                PostCheckData.arrPartsToReturn.insert((id: val.id, partsName: val.partsName, serialNo: val.serialNo, returnedBy: val.returnedBy, imgUnit: unitPosition, isImgUnit: isImgUnit, imgPerm: permConn, isImgPerm: isImgPerm, imgEarth: earthConn, isImgEarth: isImgEarth, imgIgn: ignConn, isImgIgn: isImgIgn, imgSerial: serial, isImgSerial: isImgSerial, imgLoom: loom, isImgLoom: isImgLoom, comments: comments), at: partsIndex)
                            }
                        }
                    }
                    NavigationHelper.helper.contentNavController!.pushViewController(postPartVC, animated: true)
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
                issueCell.datasource = "Electrical*" as AnyObject
                if isReset {
                    issueCell.txtView.text = "Text Message"
                    issueCell.txtView.textColor = UIColor.fontColor
                }
                issueCell.didSendYes = { check in
                    PostCheckData.isElectricalIssue = check
                    self.tblPostCheck.reloadData()
                }
                issueCell.arrImg = PostCheckData.arrImgElectricalIssue
                issueCell.didUpdateText = { val in
                    PostCheckData.electricalIssueTxt = val
                }
                issueCell.didcaptureCamera = { capture in
                    CameraHandler.shared.showActionSheet(vc: self)
                    CameraHandler.shared.imagePickedBlock = { (image) in
                        PostCheckData.arrImgElectricalIssue.append(image)
                        self.tblPostCheck.reloadData()
                    }
                }
                issueCell.didDelImage = { index in
                    PostCheckData.arrImgElectricalIssue.remove(at: index)
                    self.tblPostCheck.reloadData()
                }
                return issueCell
            case 2:
                let issueCell = self.tblPostCheck.dequeueReusableCell(withIdentifier: "ExteriorIssueCell", for: indexPath) as! ExteriorIssueCell
                issueCell.datasource = "Exterior*" as AnyObject
                if isReset {
                    issueCell.txtView.text = "Text Message"
                    issueCell.txtView.textColor = UIColor.fontColor
                }
                issueCell.didSendYes = { check in
                    PostCheckData.isExteriorIssue = check
                    self.tblPostCheck.reloadData()
                }
                issueCell.arrImg = PostCheckData.arrImgExteriorIssue
                issueCell.didUpdateText = { val in
                    PostCheckData.exteriorIssueTxt = val
                }
                issueCell.didcaptureCamera = { capture in
                    CameraHandler.shared.showActionSheet(vc: self)
                    CameraHandler.shared.imagePickedBlock = { (image) in
                        PostCheckData.arrImgExteriorIssue.append(image)
                        self.tblPostCheck.reloadData()
                    }
                }
                issueCell.didDelImage = { index in
                    PostCheckData.arrImgExteriorIssue.remove(at: index)
                    self.tblPostCheck.reloadData()
                }
                return issueCell
            default:
                let issueCell = self.tblPostCheck.dequeueReusableCell(withIdentifier: "InteriorIssueCell", for: indexPath) as! InteriorIssueCell
                issueCell.datasource = "Interior*" as AnyObject
                if isReset {
                    issueCell.txtView.text = "Text Message"
                    issueCell.txtView.textColor = UIColor.fontColor
                }
                issueCell.didSendYes = { check in
                    PostCheckData.isInteriorIssue = check
                    self.tblPostCheck.reloadData()
                }
                issueCell.arrImg = PostCheckData.arrImgInteriorIssue
                issueCell.didUpdateText = { val in
                    PostCheckData.interiorIssueTxt = val
                }
                issueCell.didcaptureCamera = { capture in
                    CameraHandler.shared.showActionSheet(vc: self)
                    CameraHandler.shared.imagePickedBlock = { (image) in
                        PostCheckData.arrImgInteriorIssue.append(image)
                        self.tblPostCheck.reloadData()
                    }
                }
                issueCell.didDelImage = { index in
                    PostCheckData.arrImgInteriorIssue.remove(at: index)
                    self.tblPostCheck.reloadData()
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
                if isReset {
                    engDeclCell.txtView.text = "Engineer Comments"
                    engDeclCell.txtView.textColor = UIColor.fontColor
                }
                engDeclCell.didUpdateText = { val in
                    PostCheckData.declaration = val
                }
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
                if isReset {
                    signCell.showSignature = false
                    signCell.imgSign.isHidden = true
                    signCell.signatureView.isHidden = false
                    signCell.txtEngCode.text = ""
                    signCell.txtEngName.text = ""
                }
                signCell.didExpand = { chk  in
                    if chk {
                        SignatureViewController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!) { imgSign, lines, view in
                            PostCheckData.engineerSignature = imgSign
                            DispatchQueue.background(background: {
                                PostCheckData.engineerSignature_base64 = imgSign.toBase64() ?? ""
                            }, completion:{
                            })
                            signCell.showSignature = true
                            signCell.imgSign.image = imgSign
                            signCell.imgSign.contentMode = .scaleAspectFit
                            self.tblPostCheck.reloadData()
                        } didFinish: { txt in }}}
                signCell.didEndWriteTextEngCode = { val in
                    PostCheckData.engineerCode = val
                }
                signCell.didEndWriteTextEngName = { val in
                    PostCheckData.engineerName = val
                }
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
                if isReset {
                    signCell.showSignature = false
                    signCell.imgSign.isHidden = true
                    signCell.signatureView.isHidden = false
                    signCell.txtName.text = ""
                    signCell.txtPosition.text = ""
                    signCell.txtEmailAdd.text = ""
                    signCell.btnSendCopy.isSelected = false
                    signCell.imgCopy.image = UIImage(named: "uncheck")
                }
                signCell.didExpand = { chk  in
                    if chk {
                        SignatureViewController.showAddOrClearPopUp(sourceViewController: NavigationHelper.helper.mainContainerViewController!) { imgSign, lines, view in
                            PostCheckData.customerSignature = imgSign
                            DispatchQueue.background(background: {
                                PostCheckData.customerSignature_base64 = imgSign.toBase64() ?? ""
                            }, completion:{
                            })
                            signCell.showSignature = true
                            signCell.imgSign.image = imgSign
                            signCell.imgSign.contentMode = .scaleAspectFit
                            self.tblPostCheck.reloadData()
                        } didFinish: { txt in }}}
                signCell.didEndWriteTextName = { val in
                    PostCheckData.customerName = val
                }
                signCell.didEndWriteTextPosition = { val in
                    PostCheckData.customerPosition = val
                }
                signCell.didEndWriteTextEmailAddress = { val in
                    PostCheckData.emailAddress = val
                }
                signCell.didSendCopy = { isSend in
                    PostCheckData.isSendCopy = isSend
                }
                return signCell
            }
        } else {
            let saveCell = self.tblPostCheck.dequeueReusableCell(withIdentifier: "SaveCell", for: indexPath) as! SaveCell
            saveCell.datasource = "" as AnyObject
            saveCell.didSave = { save in
                self.isSave = save
                self.saveData()
            }
            saveCell.didReset = { reset in
                self.isReset = reset
                PostCheckData.electricalIssueTxt = ""
                PostCheckData.arrImgElectricalIssue.removeAll()
                PostCheckData.exteriorIssueTxt = ""
                PostCheckData.arrImgExteriorIssue.removeAll()
                PostCheckData.interiorIssueTxt = ""
                PostCheckData.arrImgInteriorIssue.removeAll()
                PostCheckData.arrBufferParts.removeAll()
                PostCheckData.bufferParts_base64.removeAll()
                self.arrBufferPartsId = 0
                PostCheckData.arrPartsToReturn.removeAll()
                PostCheckData.partsReturn_base64.removeAll()
                self.arrPartsReturnId = 0
                self.tblPostCheck.reloadData()
                self.resetData()
            }
            return saveCell
        }
    }
}

// MARK: SentPartsCell
class SentPartsCell: BaseTableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var arrPartsSerial: [(id: Int, ncNo: String, serialPart1: String, serialPart2: String, prodName: String, prodId: Int, quantity: Int, returnedBy: String, used: Bool, imgUnit: UIImage, isImgUnit: Bool, imgPerm: UIImage, isImgPerm: Bool, imgEarth: UIImage, isImgEarth: Bool, imgIgn: UIImage, isImgIgn: Bool, imgSerial: UIImage, isImgSerial: Bool, imgLoom: UIImage, isImgLoom: Bool, comments: String)] = []
    @IBOutlet weak var collParts: UICollectionView!
    var didCaptureCamera:((Bool, Int) -> ())!
    var selectedParts: Int = 0
    var didSegmentindex:((Int, Int) -> ())!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                collParts.layer.cornerRadius = 10.0
                collParts.reloadData()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrPartsSerial.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let partsCell = self.collParts.dequeueReusableCell(withReuseIdentifier: "SentPartsCollectionCell", for: indexPath) as! SentPartsCollectionCell
        partsCell.datasource = "" as AnyObject
        partsCell.lblPart.text = "Part: \(arrPartsSerial[indexPath.item].prodName)"
        partsCell.lblSerial.text = "Serial: \(arrPartsSerial[indexPath.item].serialPart1)"
        partsCell.lblReturnedBy.text = "Returned By: \(arrPartsSerial[indexPath.item].returnedBy)"
        if arrPartsSerial[indexPath.item].used == true {
            partsCell.segmentIndex = 0
        } else {
            partsCell.segmentIndex = 1
        }
        partsCell.didCaptureCamera = { check, partsIndex in
            self.didCaptureCamera!(check, partsIndex)
        }
        partsCell.didSegmentindex = { index, partsIndex in
            self.didSegmentindex!(index, partsIndex)
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
    var didCaptureCamera:((Bool, Int) -> ())!
    var didSegmentindex:((Int, Int) -> ())!
    var segmentIndex: Int = 0
    var partsIndex: Int = 0
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
                segment.selectedSegmentIndex = segmentIndex
                segment.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
            }
        }
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        self.didSegmentindex!(sender.selectedSegmentIndex, partsIndex)
    }
    
    @objc func cameraParts(_ sender: UIButton) {
        self.didCaptureCamera!(true, partsIndex)
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
    var didSendSignal:((Bool, Int) -> ())!
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
        self.didSendSignal!(true, index)
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
    var didUpdateText:((String) -> ())!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                txtView.textColor = .fontColor
                parentView.layer.cornerRadius = 10.0
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        } else {
            let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
            self.didUpdateText!(newText)
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.fontColor {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Engineer Comments"
            textView.textColor = UIColor.fontColor
        }
    }
}

// MARK: EngineerSignatureCell
class EngineerSignatureCell: BaseTableViewCell, UITextFieldDelegate {
    @IBOutlet weak var signatureView: SignatureView!
    @IBOutlet weak var btnExpand: UIButton!
    @IBOutlet weak var imgSign: UIImageView!
    @IBOutlet weak var txtEngName: CustomTextField!
    @IBOutlet weak var txtEngCode: CustomTextField!
    @IBOutlet weak var viewBG: UIView!
    var didExpand:((Bool) -> ())!
    var didEndWriteTextEngName:((String) -> ())!
    var didEndWriteTextEngCode:((String) -> ())!
    var showSignature: Bool = false
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                if showSignature {
                    imgSign.isHidden = false
                    signatureView.isHidden = true
                } else {
                    imgSign.isHidden = true
                    signatureView.isHidden = false
                }
                viewBG.layer.cornerRadius = 10.0
                signatureView.layer.cornerRadius = 10.0
                setupViews()
                txtEngCode.layer.cornerRadius = 25.0
                txtEngName.layer.cornerRadius = 25.0
                btnExpand.addTarget(self, action: #selector(expand), for: .touchUpInside)
            }
        }
    }
    
    @objc func expand(_ sender: UIButton) {
        signatureView.clear()
        self.didExpand!(true)
    }
    
    func setupViews() {
        signatureView.setStrokeColor(color: .black)
        signatureView.layer.borderWidth = 0.5
        signatureView.layer.borderColor = UIColor.black.cgColor
        signatureView.layer.cornerRadius = 10
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtEngName {
            let textFieldText: NSString = (txtEngName.text ?? "") as NSString
                let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
            self.didEndWriteTextEngName!(txtAfterUpdate)
        } else {
            let textFieldText: NSString = (txtEngCode.text ?? "") as NSString
                let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
            self.didEndWriteTextEngCode!(txtAfterUpdate)
        }
        return true
    }
}

// MARK: CustomerSignatureCell
class CustomerSignatureCell: BaseTableViewCell, UITextFieldDelegate {
    @IBOutlet weak var signatureView: SignatureView!
    @IBOutlet weak var imgSign: UIImageView!
    @IBOutlet weak var txtName: CustomTextField!
    @IBOutlet weak var txtPosition: CustomTextField!
    @IBOutlet weak var txtEmailAdd: CustomTextField!
    @IBOutlet weak var btnExpand: UIButton!
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var btnSendCopy: UIButton!
    @IBOutlet weak var imgCopy: UIImageView!
    var didExpand:((Bool) -> ())!
    var didEndWriteTextName:((String) -> ())!
    var didEndWriteTextPosition:((String) -> ())!
    var didEndWriteTextEmailAddress:((String) -> ())!
    var didSendCopy:((Bool) -> ())!
    var showSignature: Bool = false
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                if showSignature {
                    imgSign.isHidden = false
                    signatureView.isHidden = true
                } else {
                    imgSign.isHidden = true
                    signatureView.isHidden = false
                }
                viewBG.layer.cornerRadius = 10.0
                signatureView.layer.cornerRadius = 10.0
                setupViews()
                signatureView.setStrokeColor(color: .black)
                txtName.layer.cornerRadius = 25.0
                txtPosition.layer.cornerRadius = 25.0
                txtEmailAdd.layer.cornerRadius = 25.0
                btnExpand.addTarget(self, action: #selector(expand), for: .touchUpInside)
                btnSendCopy.addTarget(self, action: #selector(sendCopy), for: .touchUpInside)
            }
        }
    }
    
    @objc func sendCopy(_ sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            imgCopy.image = UIImage(named: "uncheck")
            self.didSendCopy!(false)
        } else {
            sender.isSelected = true
            imgCopy.image = UIImage(named: "check")
            self.didSendCopy!(true)
        }
    }
    
    @objc func expand(_ sender: UIButton) {
        signatureView.clear()
        self.didExpand!(true)
    }
    
    func setupViews() {
        imgSign.layer.borderWidth = 0.5
        imgSign.layer.borderColor = UIColor.black.cgColor
        imgSign.layer.cornerRadius = 10.0
        signatureView.layer.borderWidth = 0.5
        signatureView.layer.borderColor = UIColor.black.cgColor
        signatureView.layer.cornerRadius = 10
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtName {
            let textFieldText: NSString = (txtName.text ?? "") as NSString
                let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
            self.didEndWriteTextName!(txtAfterUpdate)
        } else if textField == txtPosition {
            let textFieldText: NSString = (txtPosition.text ?? "") as NSString
                let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
            self.didEndWriteTextPosition!(txtAfterUpdate)
        } else {
            let textFieldText: NSString = (txtEmailAdd.text ?? "") as NSString
                let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
            self.didEndWriteTextEmailAddress!(txtAfterUpdate)
        }
        return true
    }
}


// MARK: ResetData
extension PostCheckController {
    @objc func resetData() {
        PostCheckData.front_img = UIImage()
        PostCheckData.front_img_base64 = ""
        PostCheckData.rear_img = UIImage()
        PostCheckData.rear_img_base64 = ""
        PostCheckData.passengerSide_img = UIImage()
        PostCheckData.passengerSide_img_base64 = ""
        PostCheckData.driverSide_img = UIImage()
        PostCheckData.driverSide_img_base64 = ""
        PostCheckData.declaration = ""
        PostCheckData.engineerSignature = UIImage()
        PostCheckData.engineerSignature_base64 = ""
        PostCheckData.engineerName = ""
        PostCheckData.engineerCode = ""
        PostCheckData.customerSignature = UIImage()
        PostCheckData.customerSignature_base64 = ""
        PostCheckData.customerName = ""
        PostCheckData.customerPosition = ""
        PostCheckData.emailAddress = ""
        PostCheckData.isSendCopy = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isReset = false
        }
    }
    
    @objc func saveData() {
        if PostCheckData.front_img_base64 != "" {
            if PostCheckData.rear_img_base64 != "" {
                if PostCheckData.passengerSide_img_base64 != "" {
                    if PostCheckData.driverSide_img_base64 != "" {
                        if PostCheckData.isElectricalIssue {
                            if PostCheckData.electricalIssueTxt != "" {
                                if PostCheckData.isExteriorIssue {
                                    if PostCheckData.exteriorIssueTxt != "" {
                                        if PostCheckData.isInteriorIssue {
                                            if PostCheckData.interiorIssueTxt != "" {
                                                self.save2()
                                            } else {
                                                self.presentAlertWithTitle(title: APP_TITLE, message: "Please enter comments on interior issue!")
                                            }
                                        } else {
                                            self.save2()
                                        }
                                    } else {
                                        self.presentAlertWithTitle(title: APP_TITLE, message: "Please enter comments on exterior issue!")
                                    }
                                } else {
                                    self.save2()
                                }
                            } else {
                                self.presentAlertWithTitle(title: APP_TITLE, message: "Please enter comments on electrical issue!")
                            }
                        } else {
                            self.save2()
                        }

                    } else {
                        self.presentAlertWithTitle(title: APP_TITLE, message: "Please enter driver side image!")
                    }
                } else {
                    self.presentAlertWithTitle(title: APP_TITLE, message: "Please enter passenger side image!")
                }
            } else {
                self.presentAlertWithTitle(title: APP_TITLE, message: "Please enter rear image!")
            }
        } else {
            self.presentAlertWithTitle(title: APP_TITLE, message: "Please enter front image!")
        }
    }
    
    @objc func save2() {
        if PostCheckData.engineerSignature_base64 != "" {
            if PostCheckData.engineerName != "" {
                if PostCheckData.engineerCode != "" {
                    if PostCheckData.customerSignature_base64 != "" {
                        if PostCheckData.customerName != "" {
                            self.createBase64StringForIssues(electrical: PostCheckData.arrImgElectricalIssue, exterior: PostCheckData.arrImgExteriorIssue, interior: PostCheckData.arrImgInteriorIssue)
                        } else {
                            self.presentAlertWithTitle(title: APP_TITLE, message: "Please enter customer name!")
                        }
                    } else {
                        self.presentAlertWithTitle(title: APP_TITLE, message: "Please enter customer signature!")
                    }
                } else {
                    self.presentAlertWithTitle(title: APP_TITLE, message: "Please enter engineer code!")
                }
            } else {
                self.presentAlertWithTitle(title: APP_TITLE, message: "Please enter engineer name!")
            }
        } else {
            self.presentAlertWithTitle(title: APP_TITLE, message: "Please enter engineer signature!")
        }
    }
    
    @objc func createBase64StringForIssues(electrical: [UIImage], exterior: [UIImage], interior: [UIImage]) {
        self.activity.startAnimating()
        if electrical.count > 0 {
            PostCheckData.arrImgElectricalIssueBase64.removeAll()
            for image in electrical {
                DispatchQueue.background(background: {
                    PostCheckData.arrImgElectricalIssueBase64.append(image.toBase64() ?? "")
                }, completion:{
                    
                })
            }
        }
        
        if exterior.count > 0 {
            PostCheckData.arrImageExteriorIssueBase64.removeAll()
            for image in exterior {
                DispatchQueue.background(background: {
                    PostCheckData.arrImageExteriorIssueBase64.append(image.toBase64() ?? "")
                }, completion:{
                    
                })
            }
        }
        
        if interior.count > 0 {
            PostCheckData.arrImgInteriorIssueBase64.removeAll()
            for image in exterior {
                DispatchQueue.background(background: {
                    PostCheckData.arrImgInteriorIssueBase64.append(image.toBase64() ?? "")
                }, completion:{
                    
                })
            }
        }
        
        if PostCheckData.arrBufferParts.count > 0 {
            for val in PostCheckData.arrBufferParts {
                DispatchQueue.background(background: {
                    PostCheckData.bufferParts_base64.append((id: val.id, partsName: val.partsName, serialNo: val.serialNo, consumed: val.consumed, imgUnitBase64: (val.isImgUnit ? val.imgUnit.toBase64() ?? "" : ""), imgPermBase64: (val.isImgPerm ? val.imgPerm.toBase64() ?? "" : ""), imgEarthBase64: (val.isImgEarth ? val.imgEarth.toBase64() ?? "" : ""), imgIgnBase64: (val.isImgIgn ? val.imgIgn.toBase64() ?? "" : ""), imgSerialBase64: (val.isImgSerial ? val.imgSerial.toBase64() ?? "" : ""), imgLoomBase64: (val.isImgLoom ? val.imgLoom.toBase64() ?? "" : "")))
                }, completion:{
                    
                })
            }
        }
        
        if PostCheckData.partsReturn_base64.count > 0 {
            for val in PostCheckData.arrPartsToReturn {
                DispatchQueue.background(background: {
                    PostCheckData.partsReturn_base64.append((id: val.id, partsName: val.partsName, serialNo: val.serialNo, returnedBy: val.returnedBy, imgUnitBase64: (val.isImgUnit ? val.imgUnit.toBase64() ?? "" : ""), imgPermBase64: (val.isImgPerm ? val.imgPerm.toBase64() ?? "" : ""), imgEarthBase64: (val.isImgEarth ? val.imgEarth.toBase64() ?? "" : ""), imgIgnBase64: (val.isImgIgn ? val.imgIgn.toBase64() ?? "" : ""), imgSerialBase64: (val.isImgSerial ? val.imgSerial.toBase64() ?? "" : ""), imgLoomBase64: (val.isImgLoom ? val.imgLoom.toBase64() ?? "" : "")))
                }, completion:{
                    
                })
            }
        }
        
        if arrPartsSerial.count > 0 {
            for val in arrPartsSerial {
                DispatchQueue.background(background: {
                    PostCheckData.sentParts_base64.append((id: val.id, partsName: val.prodName, serial1: val.serialPart1, serial2: val.serialPart2, returnedBy: val.returnedBy, used: val.used ? "yes" : "no", imgUnitBase64: (val.isImgUnit ? val.imgUnit.toBase64() ?? "" : ""), imgPermBase64: (val.isImgPerm ? val.imgPerm.toBase64() ?? "" : ""), imgEarthBase64: (val.isImgEarth ? val.imgEarth.toBase64() ?? "" : ""), imgIgnBase64: (val.isImgIgn ? val.imgIgn.toBase64() ?? "" : ""), imgSerialBase64: (val.isImgSerial ? val.imgSerial.toBase64() ?? "" : ""), imgLoomBase64: (val.isImgLoom ? val.imgLoom.toBase64() ?? "" : "")))
                }, completion:{
                    
                })
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            self.activity.stopAnimating()
            let closureVC = mainStoryboard.instantiateViewController(withIdentifier: "ClosureController") as! ClosureController
            NavigationHelper.helper.contentNavController!.pushViewController(closureVC, animated: true)
        }
    }
}
