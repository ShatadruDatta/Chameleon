//
//  PreCheckController.swift
//  Chameleon
//
//  Created by SHATADRU DATTA on 09/01/24.
//

import UIKit
import MapKit

class JobSheetController: BaseViewController {

    @IBOutlet weak var tblPrecheck: UITableView!
    @IBOutlet weak var viewPreCheck: UIView!
    @IBOutlet weak var viewPostCheck: UIView!
    @IBOutlet weak var viewClosure: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @Published var jobSheetDataModel: JobSheetModels?
    var jobId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
         case 0:
             return 4
         case 1,3,4:
             return 1
         case 2:
             return self.jobSheetDataModel?.partList.count ?? 0
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
                 custCell.lblCust.text = "Customer:"
                 custCell.lblDetail.text = self.jobSheetDataModel?.customer.name
                 custCell.lblCust2.text = "Customer:"
                 custCell.lblDetail2.text = self.jobSheetDataModel?.customerClient.name
                 custCell.viewBG.backgroundColor = UIColor.init(hexString: "EFF3FC")
                 custCell.viewBG2.backgroundColor = UIColor.init(hexString: "F5EFF8")
                 return custCell
             case 1:
                 let custCell = self.tblPrecheck.dequeueReusableCell(withIdentifier: "CustomerCell", for: indexPath) as! CustomerCell
                 custCell.datasource = "" as AnyObject
                 custCell.lblCust.text = "Ref:"
                 custCell.lblDetail.text = self.jobSheetDataModel?.clientOrderRef
                 custCell.lblCust2.text = "Con No:"
                 custCell.lblDetail2.text = self.jobSheetDataModel?.installationAddress.contactNumber
                 custCell.viewBG.backgroundColor = UIColor.init(hexString: "F1F8F3")
                 custCell.viewBG2.backgroundColor = UIColor.init(hexString: "F7F2EB")
                 return custCell
             case 2:
                 let custCell = self.tblPrecheck.dequeueReusableCell(withIdentifier: "CustomerCell", for: indexPath) as! CustomerCell
                 custCell.datasource = "" as AnyObject
                 custCell.lblCust.text = "Install Date:"
                 custCell.lblDetail.text = self.jobSheetDataModel?.appointment.components(separatedBy: " ")[0]
                 custCell.lblCust2.text = "Install Time:"
                 custCell.lblDetail2.text = self.jobSheetDataModel?.appointment.components(separatedBy: " ")[1]
                 custCell.viewBG.backgroundColor = UIColor.init(hexString: "F5EFF8")
                 custCell.viewBG2.backgroundColor = UIColor.init(hexString: "F1F8F3")
                 return custCell
             default:
                 let serviceCell = self.tblPrecheck.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath) as! ServiceCell
                 serviceCell.datasource = "" as AnyObject
                 serviceCell.lblDetail.text = self.jobSheetDataModel?.service.name
                 serviceCell.lblFee.text = "£" + String(self.jobSheetDataModel?.service.engineerFee ?? 0)
                 return serviceCell
             }
         } else if indexPath.section == 1 {
             let conDetCell = self.tblPrecheck.dequeueReusableCell(withIdentifier: "ContactDetailsCell", for: indexPath) as! ContactDetailsCell
             conDetCell.datasource = "" as AnyObject
             conDetCell.lblContactName.text = self.jobSheetDataModel?.installationAddress.contactName
             conDetCell.lblContactNo.text = self.jobSheetDataModel?.installationAddress.contactNumber
             conDetCell.lblContactMail.text = self.jobSheetDataModel?.installationAddress.email
             conDetCell.lblInstallation.text = (self.jobSheetDataModel?.installationAddress.street ?? "")
             conDetCell.lblDeliveryAddress.text = (self.jobSheetDataModel?.deliveryAddress.street ?? "")
             return conDetCell
         } else if indexPath.section == 2 {
             let partsCell = self.tblPrecheck.dequeueReusableCell(withIdentifier: "PartsCell", for: indexPath) as! PartsCell
             partsCell.datasource = "\(self.jobSheetDataModel?.partList[indexPath.row].productID.name ?? "")\n Serial Number : NA" as AnyObject
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
             installCell.lblDetail.text = "Details Vehicle: \(self.jobSheetDataModel?.installationVehicleDetails.vehicle ?? "")"
             installCell.lblReg.text = self.jobSheetDataModel?.installationVehicleDetails.reg
             installCell.lblYOM.text = "NA"
             installCell.lblColour.text = "NA"
             installCell.lblVIN.text = self.jobSheetDataModel?.installationVehicleDetails.vin
             installCell.lblFuel.text = "NA"
             return installCell
         } else if indexPath.section == 4 {
             let installCell = self.tblPrecheck.dequeueReusableCell(withIdentifier: "InstallationCell", for: indexPath) as! InstallationCell
             installCell.datasource = "" as AnyObject
             // Deinstallation Details
             installCell.lblDetail.text = "Details Vehicle: \(self.jobSheetDataModel?.installationVehicleDetails.vehicle ?? "")"
             installCell.lblReg.text = self.jobSheetDataModel?.installationVehicleDetails.reg
             installCell.lblYOM.text = "NA"
             installCell.lblColour.text = "NA"
             installCell.lblVIN.text = self.jobSheetDataModel?.installationVehicleDetails.vin
             installCell.lblFuel.text = "NA"
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
            if indexPath.row == 3 {
                return 110.0
            } else {
                return UITableView.automaticDimension
            }
        }
        if indexPath.section == 1 {
            return 350.0
        }
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
