//
//  PreCheckController.swift
//  Chameleon
//
//  Created by SHATADRU DATTA on 09/01/24.
//

import UIKit
import MapKit
import SwiftyJSON

struct JobSheetData {
    static var jobId: Int = 0
    static var ref_no: String = ""
    static var date: String = ""
    static var time: String = ""
    static var nc_bnc_number: String = ""
    static var service: String = ""
    static var ins_vehicle_det_color: String = ""
    static var ins_vehicle_det_fuelType: String = ""
    static var ins_vehicle_det_reg: String = ""
    static var ins_vehicle_det_vehicle: String = ""
    static var ins_vehicle_det_vehicle_make: String = ""
    static var ins_vehicle_det_vehicle_model: String = ""
    static var ins_vehicle_det_vin: String = ""
    static var ins_vehicle_det_yom: String = ""
    static var check_Deinstallation_available = false
    static var deins_vehicle_det_color: String = ""
    static var deins_vehicle_det_fuelType: String = ""
    static var deins_vehicle_det_reg: String = ""
    static var deins_vehicle_det_vehicle: String = ""
    static var deins_vehicle_det_vehicle_make: String = ""
    static var deins_vehicle_det_vehicle_model: String = ""
    static var deins_vehicle_det_vin: String = ""
    static var deins_vehicle_det_yom: String = ""
    static var customerName: String = ""
    static var engineerName: String = ""
    static var engineerId: String = ""
    static var emailAdd: String = ""
}

class JobSheetController: BaseViewController {

    @IBOutlet weak var lblNcNumber: UILabel!
    @IBOutlet weak var tblPrecheck: UITableView!
    @IBOutlet weak var viewPreCheck: UIView!
    @IBOutlet weak var viewPostCheck: UIView!
    @IBOutlet weak var viewClosure: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var imgPreCheck: UIImageView!
    @Published var jobSheetDataModel: JobSheetModels?
    var street2DeliveryAdd: String = ""
    var street3DeliveryAdd: String = ""
    var street2InstallationAdd: String = ""
    var street3InstallationAdd: String = ""
    var partsCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblNcNumber.text = JobSheetData.nc_bnc_number
        self.tblPrecheck.isHidden = true
        tblPrecheck.estimatedRowHeight = 100.0
        tblPrecheck.rowHeight = UITableView.automaticDimension
        viewPreCheck.layer.cornerRadius = 10.0
        viewPostCheck.layer.cornerRadius = 10.0
        viewClosure.layer.cornerRadius = 10.0
        
        self.viewPreCheck.layer.masksToBounds = false
        self.viewPreCheck.dropShadow(color: .lightGray, opacity: 0.3 ,offSet: CGSize.init(width: 4, height: 4), radius: 10.0)
        self.imgPreCheck.setImageColor(color: .white)
        
        self.viewPostCheck.layer.masksToBounds = false
        self.viewPostCheck.dropShadow(color: .lightGray, opacity: 0.3 ,offSet: CGSize.init(width: 4, height: 4), radius: 10.0)
        
        self.viewClosure.layer.masksToBounds = false
        self.viewClosure.dropShadow(color: .lightGray, opacity: 0.3 ,offSet: CGSize.init(width: 4, height: 4), radius: 10.0)
        
        // MARK: JobSheetAPICall
        self.jobSheet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func precheck(_ sender: UIButton) {
        let precheckVC = mainStoryboard.instantiateViewController(withIdentifier: "PrecheckController") as! PrecheckController
        NavigationHelper.helper.contentNavController!.pushViewController(precheckVC, animated: true)
    }
    
    
    //  MARK: JobSheetAPI
    @objc func jobSheet() {
        self.activity.startAnimating()
        let baseurl = "\(baseurl)/v1/joborder/\(JobSheetData.jobId)"
        print(baseurl)
        let headers = ["x-api-key" : apiKey, "x-token": Chameleon.token]
        AFWrapper.requestGETURL(baseurl, headers: headers) { [self] jsonVal, data, statusCode  in
            print(jsonVal)
            self.activity.stopAnimating()
            if statusCode == 200 {
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(JobSheetModels.self, from: data)
                    jobSheetDataModel = data
                    self.street2DeliveryAdd = jsonVal["delivery_address"]["street2"].stringValue
                    self.street3DeliveryAdd = jsonVal["delivery_address"]["street3"].stringValue
                    self.street2InstallationAdd = jsonVal["installation_address"]["street2"].stringValue
                    self.street3InstallationAdd = jsonVal["installation_address"]["street3"].stringValue
                    let appointment = jsonVal["appointment"].stringValue.components(separatedBy: " ")
                    if appointment.count == 2 {
                        let dateFormatterGet = DateFormatter()
                        dateFormatterGet.dateFormat = "yyyy-MM-dd"
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd MMM, yyyy"
                        let date: Date? = dateFormatterGet.date(from: appointment[0])
                        JobSheetData.date = dateFormatter.string(from: date ?? Date())
                        
                        let dateFormatterGetTime = DateFormatter()
                        dateFormatterGetTime.dateFormat = "HH:mm:ss"
                        let dateFormatterSetTime = DateFormatter()
                        dateFormatterSetTime.dateFormat = "hh:mm a"
                        let time: Date? = dateFormatterGetTime.date(from: appointment[1])
                        JobSheetData.time = dateFormatterSetTime.string(from: time ?? Date())
                    }
                    JobSheetData.customerName = jsonVal["customer"]["name"].stringValue
                    JobSheetData.engineerName = jsonVal["engineer_id"]["name"].stringValue
                    JobSheetData.engineerId = jsonVal["engineer_id"]["id"].stringValue
                    JobSheetData.ref_no = jsonVal["client_order_ref"].stringValue
                    JobSheetData.service = jsonVal["service"]["service"].stringValue
                    
                    JobSheetData.emailAdd = jsonVal["installation_address"]["email"].stringValue
                    JobSheetData.ins_vehicle_det_reg = jsonVal["installation_vehicle_details"]["reg"].stringValue
                    JobSheetData.ins_vehicle_det_color = jsonVal["installation_vehicle_details"]["colour"].stringValue
                    JobSheetData.ins_vehicle_det_fuelType = jsonVal["installation_vehicle_details"]["fuel_type"].stringValue
                    JobSheetData.ins_vehicle_det_vehicle = jsonVal["installation_vehicle_details"]["vehicle"].stringValue
                    JobSheetData.ins_vehicle_det_vehicle_make = jsonVal["installation_vehicle_details"]["vehicle_make"].stringValue
                    JobSheetData.ins_vehicle_det_vehicle_model = jsonVal["installation_vehicle_details"]["vehicle_model"].stringValue
                    JobSheetData.ins_vehicle_det_vin = jsonVal["installation_vehicle_details"]["vin"].stringValue
                    JobSheetData.ins_vehicle_det_yom = jsonVal["installation_vehicle_details"]["yom"].stringValue
                    JobSheetData.deins_vehicle_det_vin = jsonVal["installation_vehicle_details"]["vin"].stringValue
                    JobSheetData.deins_vehicle_det_yom = jsonVal["installation_vehicle_details"]["yom"].stringValue
                    
                    if jsonVal.dictionary!.keyExists("de_installation_vehicle_details") {
                        JobSheetData.check_Deinstallation_available = true
                        JobSheetData.deins_vehicle_det_reg = jsonVal["de_installation_vehicle_details"]["reg"].stringValue
                        JobSheetData.deins_vehicle_det_color = jsonVal["de_installation_vehicle_details"]["colour"].stringValue
                        JobSheetData.deins_vehicle_det_fuelType = jsonVal["de_installation_vehicle_details"]["fuel_type"].stringValue
                        JobSheetData.deins_vehicle_det_vehicle = jsonVal["de_installation_vehicle_details"]["vehicle"].stringValue
                        JobSheetData.deins_vehicle_det_vehicle_make = jsonVal["de_installation_vehicle_details"]["vehicle_make"].stringValue
                        JobSheetData.deins_vehicle_det_vehicle_model = jsonVal["de_installation_vehicle_details"]["vehicle_model"].stringValue
                    } else {
                        JobSheetData.check_Deinstallation_available = false
                    }
                    
                    arrPartsSerial.removeAll()
                    if jsonVal["part_list"].count > 0 {
                        for val in jsonVal["part_list"].arrayValue {
                            self.partsCount += 1
                            arrPartsSerial.append((id: self.partsCount, ncNo: jsonVal["nc_bnc_number"].stringValue, serialPart1: val["serial1"].stringValue, serialPart2: val["serial2"].stringValue, prodName: val["product_id"]["name"].stringValue, prodId: val["product_id"]["id"].intValue, quantity: val["quantity"].intValue, returnedBy: "", used: true, imgUnit: UIImage(named: "ImgCapBg") ?? UIImage(), isImgUnit: false, imgPerm: UIImage(named: "ImgCapBg") ?? UIImage(), isImgPerm: false, imgEarth: UIImage(named: "ImgCapBg") ?? UIImage(), isImgEarth: false, imgIgn: UIImage(named: "ImgCapBg") ?? UIImage(), isImgIgn: false, imgSerial: UIImage(named: "ImgCapBg") ?? UIImage(), isImgSerial: false, imgLoom: UIImage(named: "ImgCapBg") ?? UIImage(), isImgLoom: false, comments: ""))
                        }
                    } else {
                        arrPartsSerial.append((id: 0, ncNo: "NA", serialPart1: "NA", serialPart2: "NA", prodName: "Not Available", prodId: 0, quantity: 0, returnedBy: "", used: false, imgUnit: UIImage(), isImgUnit: false, imgPerm: UIImage(), isImgPerm: false, imgEarth: UIImage(), isImgEarth: false, imgIgn: UIImage(), isImgIgn: false, imgSerial: UIImage(), isImgSerial: false, imgLoom: UIImage(), isImgLoom: false, comments: ""))
                    }
                    self.tblPrecheck.isHidden = false
                    self.tblPrecheck.reloadData()
                } catch {
                    self.tblPrecheck.isHidden = true
                    SharedClass.sharedInstance.alert(view: self, title: "Failure", message: jsonVal["message"].stringValue)
                }
            } else if statusCode == 400 || statusCode == 403 || statusCode == 429 || statusCode == 500
                        || statusCode == 503 {
                self.presentAlertForLogout(title: "Failure", message: jsonVal["message"].stringValue)
            } else {
                SharedClass.sharedInstance.alert(view: self, title: "Failure", message: jsonVal["message"].stringValue)
            }
        } failure: { error in
            SharedClass.sharedInstance.alert(view: self, title: "Failure", message: error.localizedDescription)
            self.activity.stopAnimating()
        }
    }
    
    @IBAction func menu(_ sender: UIButton) {
        NavigationHelper.helper.reloadMenu()
        NavigationHelper.helper.openSidePanel(open: true)
    }
}

// MARK: TableViewDelegate, TableViewDataSource
extension JobSheetController: UITableViewDelegate, UITableViewDataSource {

     func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 4:
            return JobSheetData.check_Deinstallation_available ? 40.0 : 0.0
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
         case 1:
             return 2
         case 0,3:
             return 1
         case 4:
             return JobSheetData.check_Deinstallation_available ? 1 : 0
         case 2:
             return arrPartsSerial.count
         default:
             return 1
         }
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         if indexPath.section == 0 {
             let custCell = self.tblPrecheck.dequeueReusableCell(withIdentifier: "CustomerJobSheetCell", for: indexPath) as! CustomerJobSheetCell
             custCell.datasource = "" as AnyObject
             custCell.lblCust.text = self.jobSheetDataModel?.customer.name
             custCell.lblCustClient.text = self.jobSheetDataModel?.customerClient.name
             custCell.lblRef.text = self.jobSheetDataModel?.clientOrderRef
             custCell.lblDate.text = JobSheetData.date
             custCell.lblTime.text = JobSheetData.time
             custCell.lblService.text = self.jobSheetDataModel?.service.name
             custCell.lblFee.text = "£\(String(format: "%.2f", self.jobSheetDataModel?.service.engineerFee ?? 0.00))"
             return custCell
         } else if indexPath.section == 1 {
             switch indexPath.row {
             case 0:
                 let conDetCell = self.tblPrecheck.dequeueReusableCell(withIdentifier: "ContactDetailsCell", for: indexPath) as! ContactDetailsCell
                 conDetCell.datasource = "" as AnyObject
                 conDetCell.lblContactName.text = self.jobSheetDataModel?.installationAddress.contactName
                 conDetCell.lblContactNo.text = self.jobSheetDataModel?.installationAddress.contactNumber
                 conDetCell.lblContactMail.text = self.jobSheetDataModel?.installationAddress.email
                 conDetCell.lblInstallation.text = (self.jobSheetDataModel?.installationAddress.street ?? "")
                 + self.street2InstallationAdd + self.street3InstallationAdd
                 conDetCell.lblDeliveryAddress.text = (self.jobSheetDataModel?.deliveryAddress.street ?? "")
                 + self.street2DeliveryAdd + self.street3DeliveryAdd
                 return conDetCell
             default:
                 let conCell = self.tblPrecheck.dequeueReusableCell(withIdentifier: "ConCell", for: indexPath) as! ConCell
                 conCell.datasource = "" as AnyObject
                 conCell.lblConNo.text = "NA"
                 return conCell
             }
         } else if indexPath.section == 2 {
             let partsCell = self.tblPrecheck.dequeueReusableCell(withIdentifier: "PartsCell", for: indexPath) as! PartsCell
             if arrPartsSerial[indexPath.row].prodName == "Not Available" {
                 partsCell.datasource = "\(arrPartsSerial[indexPath.row].prodName)" as AnyObject
             } else {
                 partsCell.datasource = "\(arrPartsSerial[indexPath.row].prodName)\n Serial Number : \(arrPartsSerial[indexPath.row].serialPart1)" as AnyObject
             }
             if indexPath.row % 2 == 0 {
                 partsCell.viewBG.backgroundColor = UIColor.init(hexString: "F0EEF5")
             } else {
                 partsCell.viewBG.backgroundColor = .white
             }
             return partsCell
         } else if indexPath.section == 3 {
             let installCell = self.tblPrecheck.dequeueReusableCell(withIdentifier: "InstallationCell", for: indexPath) as! InstallationCell
             installCell.datasource = "" as AnyObject
             // Installation Details
             installCell.lblDetail.text = "Details Vehicle: \(JobSheetData.ins_vehicle_det_vehicle)"
             installCell.lblReg.text = JobSheetData.ins_vehicle_det_reg.count > 0 ? JobSheetData.ins_vehicle_det_reg : "NA"
             installCell.lblYOM.text = JobSheetData.ins_vehicle_det_yom.count > 0 ? JobSheetData.ins_vehicle_det_yom : "NA"
             installCell.lblColour.text = JobSheetData.ins_vehicle_det_color.count > 0 ? JobSheetData.ins_vehicle_det_color : "NA"
             installCell.lblVIN.text = JobSheetData.ins_vehicle_det_vin.count > 0 ? JobSheetData.ins_vehicle_det_vin : "NA"
             installCell.lblFuel.text = JobSheetData.ins_vehicle_det_fuelType.count > 0 ? JobSheetData.ins_vehicle_det_fuelType : "NA"
             return installCell
         } else if indexPath.section == 4 {
             let installCell = self.tblPrecheck.dequeueReusableCell(withIdentifier: "InstallationCell", for: indexPath) as! InstallationCell
             installCell.datasource = "" as AnyObject
             // Deinstallation Details
             installCell.lblDetail.text = "Details Vehicle: \(JobSheetData.deins_vehicle_det_vehicle)"
             installCell.lblReg.text = JobSheetData.deins_vehicle_det_reg.count > 0 ? JobSheetData.deins_vehicle_det_reg : "NA"
             installCell.lblYOM.text = JobSheetData.deins_vehicle_det_yom.count > 0 ? JobSheetData.deins_vehicle_det_yom : "NA"
             installCell.lblColour.text = JobSheetData.deins_vehicle_det_color.count > 0 ? JobSheetData.deins_vehicle_det_color : "NA"
             installCell.lblVIN.text = JobSheetData.deins_vehicle_det_vin.count > 0 ? JobSheetData.deins_vehicle_det_vin : "NA"
             installCell.lblFuel.text = JobSheetData.deins_vehicle_det_fuelType.count > 0 ? JobSheetData.deins_vehicle_det_fuelType : "NA"
             return installCell
         } else {
             let noteCell = self.tblPrecheck.dequeueReusableCell(withIdentifier: "PartsCell", for: indexPath) as! PartsCell
             noteCell.datasource = self.jobSheetDataModel?.engineerNotes2 as AnyObject
             noteCell.viewBG.backgroundColor = .white
             return noteCell
         }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 312.0
        }
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                return UITableView.automaticDimension
            default:
                return 75.0
            }
        }
        if indexPath.section == 3 || indexPath.section == 4 {
            return 115.0
        } else {
            return UITableView.automaticDimension
        }
    }
}

// MARK: CustomerJobSheetCell
class CustomerJobSheetCell: BaseTableViewCell {
    @IBOutlet weak var viewBG: UIView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblCust: UILabel!
    @IBOutlet weak var lblCustClient: UILabel!
    @IBOutlet weak var lblRef: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblService: UILabel!
    @IBOutlet weak var lblFee: UILabel!
    @IBOutlet weak var clientIcon: UIImageView!
    @IBOutlet weak var refIcon: UIImageView!
    @IBOutlet weak var dateIcon: UIImageView!
    @IBOutlet weak var serviceIcon: UIImageView!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                viewBG.layer.cornerRadius = 10.0
                clientIcon.setImageColor(color: UIColor.init(hexString: "#5D89F7"))
                refIcon.setImageColor(color: UIColor.init(hexString: "#5D89F7"))
                refIcon.setImageColor(color: UIColor.init(hexString: "#5D89F7"))
                dateIcon.setImageColor(color: UIColor.init(hexString: "#5D89F7"))
                serviceIcon.setImageColor(color: UIColor.init(hexString: "#5D89F7"))
            }
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
    @IBOutlet weak var lblFee: UILabel!
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
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lblContactName: UILabel!
    @IBOutlet weak var lblContactNo: UILabel!
    @IBOutlet weak var lblContactMail: UILabel!
    @IBOutlet weak var lblInstallation: UILabel!
    @IBOutlet weak var lblDeliveryAddress: UILabel!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                viewBG.layer.cornerRadius = 10.0
                mapView.layer.cornerRadius = 12.0
                mapView.layer.masksToBounds = true
                mapView.mapType = .standard
                let location = CLLocationCoordinate2D(latitude: 11.361516, longitude: 76.30274)
                let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                let region = MKCoordinateRegion(center: location, span: span)
                mapView.setRegion(region, animated: true)
                    
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                annotation.title = "Edakkara"
                annotation.subtitle = "Nilambur"
                mapView.addAnnotation(annotation)
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
            }
        }
    }
}


// MARK: ConCell
class ConCell: BaseTableViewCell {
    @IBOutlet weak var lblConNo: UILabel!
    @IBOutlet weak var btnCon: UIButton!
    @IBOutlet weak var viewBG: UIView!
    override var datasource: AnyObject? {
        didSet {
            if datasource != nil {
                viewBG.layer.cornerRadius = 10.0
                btnCon.layer.cornerRadius = 20.0
            }
        }
    }
}
