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
    static var deins_vehicle_det_color: String = ""
    static var deins_vehicle_det_fuelType: String = ""
    static var deins_vehicle_det_reg: String = ""
    static var deins_vehicle_det_vehicle: String = ""
    static var deins_vehicle_det_vehicle_make: String = ""
    static var deins_vehicle_det_vehicle_model: String = ""
    static var deins_vehicle_det_vin: String = ""
    static var deins_vehicle_det_yom: String = ""
}


class JobSheetController: BaseViewController {

    @IBOutlet weak var lblNcNumber: UILabel!
    @IBOutlet weak var tblPrecheck: UITableView!
    @IBOutlet weak var viewPreCheck: UIView!
    @IBOutlet weak var viewPostCheck: UIView!
    @IBOutlet weak var viewClosure: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @Published var jobSheetDataModel: JobSheetModels?
    var jobId: Int!
    var street2DeliveryAdd: String = ""
    var street3DeliveryAdd: String = ""
    var street2InstallationAdd: String = ""
    var street3InstallationAdd: String = ""
    
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
        let baseurl = "\(baseurl)/v1/joborder/\(jobId ?? 0)"
        print(baseurl)
        let headers = ["x-api-key" : apiKey, "X-Token": Chameleon.token]
        AFWrapper.requestGETURL(baseurl, headers: headers) { [self] jsonVal, data in
            print(jsonVal)
            self.activity.stopAnimating()
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(JobSheetModels.self, from: data)
                jobSheetDataModel = data
                self.street2DeliveryAdd = jsonVal["delivery_address"]["street2"].stringValue
                self.street3DeliveryAdd = jsonVal["delivery_address"]["street3"].stringValue
                self.street2InstallationAdd = jsonVal["installation_address"]["street2"].stringValue
                self.street3InstallationAdd = jsonVal["installation_address"]["street3"].stringValue
                JobSheetData.service = jsonVal["service"]["service"].stringValue
                JobSheetData.ins_vehicle_det_reg = jsonVal["installation_vehicle_details"]["reg"].stringValue
                JobSheetData.ins_vehicle_det_color = jsonVal["installation_vehicle_details"]["colour"].stringValue
                JobSheetData.ins_vehicle_det_fuelType = jsonVal["installation_vehicle_details"]["fuel_type"].stringValue
                JobSheetData.ins_vehicle_det_vehicle = jsonVal["installation_vehicle_details"]["vehicle"].stringValue
                JobSheetData.ins_vehicle_det_vehicle_make = jsonVal["installation_vehicle_details"]["vehicle_make"].stringValue
                JobSheetData.ins_vehicle_det_vehicle_model = jsonVal["installation_vehicle_details"]["vehicle_model"].stringValue
                JobSheetData.ins_vehicle_det_vin = jsonVal["installation_vehicle_details"]["vin"].stringValue
                JobSheetData.ins_vehicle_det_yom = jsonVal["installation_vehicle_details"]["yom"].stringValue
                JobSheetData.deins_vehicle_det_reg = jsonVal["de_installation_vehicle_details"]["reg"].stringValue
                JobSheetData.deins_vehicle_det_color = jsonVal["de_installation_vehicle_details"]["colour"].stringValue
                JobSheetData.deins_vehicle_det_fuelType = jsonVal["de_installation_vehicle_details"]["fuel_type"].stringValue
                JobSheetData.deins_vehicle_det_vehicle = jsonVal["de_installation_vehicle_details"]["vehicle"].stringValue
                JobSheetData.deins_vehicle_det_vehicle_make = jsonVal["de_installation_vehicle_details"]["vehicle_make"].stringValue
                JobSheetData.deins_vehicle_det_vehicle_model = jsonVal["de_installation_vehicle_details"]["vehicle_model"].stringValue
                JobSheetData.deins_vehicle_det_vin = jsonVal["installation_vehicle_details"]["vin"].stringValue
                JobSheetData.deins_vehicle_det_yom = jsonVal["installation_vehicle_details"]["yom"].stringValue
                if jsonVal["part_list"].count > 0 {
                    arrPartsSerial.removeAll()
                    for val in jsonVal["part_list"].arrayValue {
                        arrPartsSerial.append((ncNo: jsonVal["nc_bnc_number"].stringValue, serialPart1: val["serial1"].stringValue, serialPart2: val["serial2"].stringValue, prodName: val["product_id"]["name"].stringValue, prodId: val["product_id"]["id"].intValue, quantity: val["quantity"].intValue))
                    }
                }
                self.tblPrecheck.isHidden = false
                self.tblPrecheck.reloadData()
            } catch {
                self.tblPrecheck.isHidden = true
                SharedClass.sharedInstance.alert(view: self, title: "Failure", message: jsonVal["message"].stringValue)
            }
        } failure: { error in
            SharedClass.sharedInstance.alert(view: self, title: "Failure", message: error.localizedDescription)
            self.activity.stopAnimating()
        }
    }
    
    @IBAction func menu(_ sender: UIButton) {
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
         case 0,3,4:
             return 1
         case 2:
             return self.jobSheetDataModel?.partList?.count ?? 0
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
             custCell.lblDate.text = self.jobSheetDataModel?.appointment.components(separatedBy: " ")[0]
             custCell.lblService.text = self.jobSheetDataModel?.service.name
             custCell.lblFee.text = "£\(self.jobSheetDataModel?.service.engineerFee ?? 0)"
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
             partsCell.datasource = "\(self.jobSheetDataModel?.partList?[indexPath.row].productID?.name ?? "")\n Serial Number : NA" as AnyObject
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
             installCell.lblReg.text = JobSheetData.ins_vehicle_det_reg
             installCell.lblYOM.text = JobSheetData.ins_vehicle_det_yom
             installCell.lblColour.text = JobSheetData.ins_vehicle_det_color
             installCell.lblVIN.text = JobSheetData.ins_vehicle_det_vin
             installCell.lblFuel.text = JobSheetData.ins_vehicle_det_fuelType
             return installCell
         } else if indexPath.section == 4 {
             let installCell = self.tblPrecheck.dequeueReusableCell(withIdentifier: "InstallationCell", for: indexPath) as! InstallationCell
             installCell.datasource = "" as AnyObject
             // Deinstallation Details
             installCell.lblDetail.text = "Details Vehicle: \(JobSheetData.deins_vehicle_det_vehicle)"
             installCell.lblReg.text = JobSheetData.deins_vehicle_det_reg
             installCell.lblYOM.text = JobSheetData.deins_vehicle_det_yom
             installCell.lblColour.text = JobSheetData.deins_vehicle_det_color
             installCell.lblVIN.text = JobSheetData.deins_vehicle_det_vin
             installCell.lblFuel.text = JobSheetData.deins_vehicle_det_fuelType
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
