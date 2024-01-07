//
//  AppDelegate.swift
//  expaTPA
//
//  Created by Shatadru Datta on 11/03/20.
//  Copyright © 2020 Procentris. All rights reserved.
//



import Foundation
import UIKit

let SYSTEM_VERSION = UIDevice.current.systemVersion

let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEIGHT = UIScreen.main.bounds.height
let MAIN_WINDOW = UIApplication.shared.windows.first


let RISTRICTED_CHARACTERS = "'*=+[]\\|;:'\",<>/?%"

//MARK: AppName
let appName = "Cosmos"

// MARK: BASEURL

let baseurlLive = "https://www.stripdeals.net/api/" //StagingURL

let Feed = "social/users/"

//MARK: DealList
let DealList = "deals/users/"

//MARK: ClubList
let ClubList = "places/users/"

//MARK: ClubDetails
let ClubDetails = "place_details/users/"

//MARK: DealCount
let DealCount = "deals/count/"

//MARK: FeedCount
let FeedCount = "social/count/"

//MARK: ClubCount
let ClubCount = "places/count/"

//MARK: DealDetails
let DealDetails = "deal_details/users/"

//MARK: Reviews
let Reviews = "places/reviews/"

//MARK: Gallery
let Gallery = "places/gallery/"

//MARK: CategoryKey
let categoryKey = "category_get_data.php"

//MARK: Register
let registerKey = "user_create.php"

//MARK: CountryKey
let countryKey = "get_country_list.php"

//MARK: SendOTP
let sendotp = "send_otp.php"

//MARK: UpdatePass
let resetPass = "reset_password.php"

//MARK: VerifyOTP
let verifyotp = "verify_otp.php"

//MARK: StateKey
let stateKey = "get_state_list.php"

//MARK: CityKey
let cityKey = "get_city_list.php"

//MARK: UserLog
let userLog = "read_user_log.php"

//MARK: OrderList
let getOrderList = "read_order_listing.php"

//MARK: UploadImage
let createOrder = "create_order.php"

//MARK: UpdateOrder
let updateOrderStatus = "update_order_status.php"

//MARK: GetProduct
let getProduct = "product_get_data.php"

//MARK: AES256 Key & iv
let iv = "1234567891123456"
let key = "wt1U5MACWJFTXGenFoZoiLwQGrLgdbHA"
let aes256 = AES(key: key, iv: iv)

var GoPNumber: String!

//MARK: ArrayInsuredMembers
var arrInsuredMembers: [(ID: String, Name: String, Relationship: String, DOB: String, InsuredFrom: String, InsuredTo: String)] = []

//MARK: ArrayDealList
var arrDealList: [(id: String, status: String, user_details_id: String, rating: String, business_name: String, address: String, city: String, state: String, zip: String, logo: String, phone: String, callName: String, dealID: String, dealTitle: String, dealDetails: String, dealImage: String, originalPrice: String, offerPrice: String, discount: String, availableDays: String, distance: Double, reviews: Int, latitude: Double, longitude: Double, mile: Double)] = []

var arrClubList: [(id: String, status: String, user_details_id: String, Rating: String, business_name: String, address: String, city: String, state: String, zip: String, logo: String, callName: String, reviews: String, latitude: Double, longitude: Double, mile: Double, mon: String, tue: String, wed: String, thu: String, fri: String, sat: String, sun: String, currWeek: String)] = []

var arrDeals: [(DealID: String, DealTitle: String, DealDetails: String, DealImage: String, OriginalPrice: String, OfferPrice: String, Discount: String)] = []

var arrFeed: [(lat: String, lon: String, reviews: Int, rating: String, feed_id: String, name: String, description: String, images: String, feed_date: String, user_id: String, fb_link: String, business_name: String, business_logo: String, isDetailDesc: Bool, descWithoutSpace: String, pixels: String, height: CGFloat)] = []

var arrLocalFeed: [(lat: String, lon: String, rating: String, feed_id: String, name: String, description: String, images: String, feed_date: String, user_id: String, fb_link: String, business_name: String, business_logo: String, isDetailDesc: Bool, descWithoutSpace: String, pixels: String, height: CGFloat)] = []

//MARK: UserArray
var arrUser = [String]()

//MARK: CountryList
var arrCountry: [(id: String, name: String)] = []

//MARK: GOPCountryList
var arrGOPCountry: [(id: String, name: String)] = []

//MARK: DoctorSpeciality
var arrDoctorSpeciality: [(id: String, name: String)] = []

//MARK: Currency
var arrCurrency: [(id: String, name: String)] = []

//MARK: ClaimBeneficiaries
var arrClaimBeneficiary: [(id: String, name: String)] = []

//MARK: Diagnosis
var arrDiagnosis: [(id: String, name: String)] = []

//MARK: DoctorDetails
var arrDoctorDetails: [(id: String, name: String)] = []

//MARK: HospitalOrPharmacyName
var arrHospital: [(id: String, name: String)] = []

//MARK: DoctorName
var arrDoctorName: [(id: String, name: String)] = []

//MARK: MedicalProcedure
var arrMedicalProcedure: [(id: String, name: String)] = []

// MARK: Storyboard
let mainStoryboard: UIStoryboard = UIStoryboard(name: UIDevice.current.userInterfaceIdiom == .phone ? "Main" : "Main", bundle: nil)


// MARK:- Font
let FONT_NAME = "Roboto-Regular"
let kTableViewBackgroundImage = "BackgroundImage"

func IS_IPAD() -> Bool {
    switch UIDevice.current.userInterfaceIdiom {
    case .phone: // It's an iPhone
        return false
    case .pad: // It's an iPad
        return true
    case .unspecified: // undefined
        return false
    default:
        return false
    }
}

func SET_OBJ_FOR_DATA(obj: Data, key: String) {
    UserDefaults.standard.set(obj, forKey: key)
}

func SET_OBJ_FOR_KEY(obj: String, key: String) {
    UserDefaults.standard.set(obj, forKey: key)
}

func OBJ_FOR_KEY(key: String) -> String? {
    if UserDefaults.standard.object(forKey: key) != nil {
        return UserDefaults.standard.object(forKey: key) as! String?
    }
    return nil
}

func convertToDictionary(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}

func SET_INTEGER_FOR_KEY(integer: Int, key: String) {
    UserDefaults.standard.set(integer, forKey: key)
}

func INTEGER_FOR_KEY(key: String) -> Int? {
    return UserDefaults.standard.integer(forKey: key)
}

func SET_FLOAT_FOR_KEY(float: Float, key: String) {
    UserDefaults.standard.set(float, forKey: key)
}

func FLOAT_FOR_KEY(key: String) -> Float? {
    return UserDefaults.standard.float(forKey: key)
}

func SET_BOOL_FOR_KEY(bool: Bool, key: String) {
    UserDefaults.standard.set(bool, forKey: key)
}

func BOOL_FOR_KEY(key: String) -> Bool? {
    return UserDefaults.standard.bool(forKey: key)
}

func REMOVE_OBJ_FOR_KEY(key: String) {
    UserDefaults.standard.removeObject(forKey: key)
}

func UIColorRGB(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor? {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
}
func UIBorderColor() -> UIColor {
    return UIColor(red: 212.0 / 255.0, green: 212.0 / 255.0, blue: 212.0 / 255.0, alpha: 1.0)
}

func UIColorRGBA(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor? {
    return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
}

func UIColorTabBarUnselected() -> UIColor? {
    return UIColor(red: 128.0 / 255.0, green: 127.0 / 255.0, blue: 123.0 / 255.0, alpha: 1.0)
}

func FIRST_WINDOW() -> AnyObject? {
    return UIApplication.shared.windows.first!
}


func SWIFT_CLASS_STRING(className: String) -> String? {
    return "\(Bundle.main.infoDictionary!["CFBundleName"] as! String).\(className)";
}

func PRIMARY_FONT(size: CGFloat) -> UIFont? {
    return UIFont(name: FONT_NAME, size: size)
}

struct GlobalMethods {
    
    /// The method is used to store value in userdefaults
    ///
    /// - Parameters:
    ///   - key: The key name for defaults
    ///   - value: The value of the ket Passed
    static func storeInDefaults (key: String, value: String){
        
        UserDefaults.standard.set(value, forKey:key)
        UserDefaults.standard.synchronize()
    }
    
    /// The method is used ato retrieve value of the saved keys in Userdefaults and if not found it returns a blank string
    ///
    /// - Parameter keyName: The key saved in the defaults
    /// - Returns: The value is returned for the key
    static func getFromDefaultsFor(keyName: String) ->String{
        let returnValue:String! = UserDefaults.standard.object(forKey: keyName) != nil ? UserDefaults.standard.object(forKey: keyName) as? String : ""
        return returnValue
    }
    
    /// The method returns the comapny access token and comapny cid
    static var getCompanyCidAndCompanyAccesstoken = {(comapnyAccessToken: String) -> (accessToken: String, cid: String) in
        let base64UserStr = NSString(format: "%@%@", comapnyAccessToken,"==") as String
        let decodedData = NSData(base64Encoded: base64UserStr, options: NSData.Base64DecodingOptions.init(rawValue: 0))
        let decodedString = NSString(data: decodedData! as Data, encoding: String.Encoding.utf8.rawValue)
        let  base64String = decodedString?.components(separatedBy: "-")
        let  companyAccessToken = base64String?[1]
        let companyCid = base64String?[2]
        return (comapnyAccessToken,companyCid!)
    }
}



func commandFrom(dict:Dictionary<String,Any>) -> String
{
    let jsonData: Data? = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
    let error: Error? = nil
    
    if jsonData != nil && error == nil
    {
        var strTempCommand = ""
        if let aData = jsonData
        {
            strTempCommand = String(data: aData, encoding: .utf8)!
            return strTempCommand
        }
    }
    
    return ""
}

var strIPGlobal : String
{
    return UserDefaults.getString(forKey: kIP)
}

var strPortGlobal : String
{
    return UserDefaults.getString(forKey: kPORT)
}


struct Platform
{
    static var isSimulator: Bool
    {
        return TARGET_OS_SIMULATOR != 0
    }
    
}

struct APP {
    static var claimNumber = ""
    static var gopNumber = ""
    static var claimComments = ""
    static var isNotifyLang = false
    static var noteENG = ""
    static var noteFR = ""
    static var isSubmitClaimVC = false
}

var strDeviceID : String
{
    if Platform.isSimulator
    {
        return "901D98FC-74E1-4862-860E-BD996B1CA31C"
    }
    else
    {
        return UIDevice.current.identifierForVendor!.uuidString
    }
}

