//
//  AppDelegate.swift
//  Chameleon
//
//  Created by Shatadru Datta on 20/02/24.
//  Copyright © 2024 Chameleon. All rights reserved.
//


import Foundation
import UIKit
import CommonCrypto
import CoreLocation

extension String
{
    // MARK:- Trimming the whitespace from a string and check empty of string
    public var isBlank: Bool {
        get {
            //			let trimmed = stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            let trimmed = trimmingCharacters(in: NSCharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    
    //let passwordRegex = "^(?=.*\\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[d$@$!%*?&#])[0-9a-zA-Z!@#$%^&*()\\-_=+{}|?>.<,:;~`’]{8,}$"
    
    func isValidPassword() -> Bool {
        let passwordRegex = "^(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d$@$!%*?&]{8,}"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
    }
   
    
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
  
    func requiredHeight(forWidth width: CGFloat, andFont font: UIFont) -> CGFloat {
        
        let label: UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = self
        label.sizeToFit()
        return label.frame.height
    }
    
    func requiredWidth(forHeight height: CGFloat, andFont font: UIFont) -> CGFloat {
        
        let label: UILabel = UILabel(frame: CGRectMake(0, 0, CGFloat.greatestFiniteMagnitude, height))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = self
        label.sizeToFit()
        return label.frame.width
    }
    
      func replace(string:String, replacement:String) -> String {
          return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
      }

      func removeWhitespace() -> String {
          return self.replace(string: " ", replacement: "")
      }


    
    // MARK: Label Justified
    func labelJustified(labelText: UILabel)
    {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .justified
        paragraphStyle.firstLineHeadIndent = 0.001
        
        let mutableAttrStr = NSMutableAttributedString(attributedString: labelText.attributedText!)
        mutableAttrStr.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, mutableAttrStr.length))
        labelText.attributedText = mutableAttrStr
    }
    
    //MARK: Random String
    static func randomString(length: Int) -> String {
        let charactersString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let charactersArray : [Character] = Array(charactersString)
        
        var string = ""
        for _ in 0..<length {
            string.append(charactersArray[Int(arc4random()) % charactersArray.count])
        }
        return string
    }
    
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func index(at position: Int, from start: Index? = nil) -> Index? {
        let startingIndex = start ?? startIndex
        return index(startingIndex, offsetBy: position, limitedBy: endIndex)
    }
    
    func character(at position: Int) -> Character? {
        guard position >= 0, let indexPosition = index(at: position) else {
            return nil
        }
        return self[indexPosition]
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func convertBase64StringToImage (imageBase64String:String) -> UIImage {
        let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
        guard let image = UIImage(data: imageData!) else { return UIImage() }
        return image
    }
    
}


// MARK: TextField Extension
extension UITextField {

   // MARK:- Set Image on the right of text fields

    func setupRightImage(imageName:String, width: CGFloat, height: CGFloat) {
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: width, height: height))
        imageView.image = UIImage(named: imageName)
        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
        imageContainerView.addSubview(imageView)
        rightView = imageContainerView
        rightViewMode = .always
        self.tintColor = .lightGray
    }

   // MARK:- Set Image on left of text fields

    func setupLeftImage(imageName: String, width: CGFloat, height: CGFloat){
       let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: width, height: height))
       imageView.image = UIImage(named: imageName)
       let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 55, height: 40))
       imageContainerView.addSubview(imageView)
       leftView = imageContainerView
       leftViewMode = .always
       self.tintColor = .lightGray
     }
  }



//MARK: Array
extension Array where Element: Comparable {
    
    mutating func removeObject(object: Element) {
        if let index = self.firstIndex(of: object) {
            self.remove(at: index)
        }
    }
    
    mutating func removeObjects(objectArray: [Element])
    {
        for object in objectArray {
            self.removeObject(object: object)
        }
    }
}

extension Array {
    mutating func rearrange(from: Int, to: Int) {
        insert(remove(at: from), at: to)
    }
    func containsStr<T>(obj: T) -> Bool where T : Equatable {
        return self.filter({$0 as? T == obj}).count > 0
    }
}


extension Dictionary {
    func allKeys() -> [String] {
        guard self.keys.first is String else {
            debugPrint("This function will not return other hashable types. (Only strings)")
            return []
        }
        return self.compactMap { (anEntry) -> String? in
            guard let temp = anEntry.key as? String else { return nil }
            return temp }
        /*
         return self.flatMap { (anEntry) -> String? in
         guard let temp = anEntry.key as? String else { return nil }
         return temp }*/
    }
    
    func nonNullKeys() -> [String] {
        var dict = self
        let allKe = allKeys()
        
        var finalKeys = [String]()
        
        
        let keysToRemove = Array(dict.keys).filter { dict[$0] is NSNull }
        
        for strKey in allKe {
            if !keysToRemove.containsStr(obj: strKey) {
                finalKeys.append(strKey)
            }
        }
        return finalKeys
    }
    
    func keyExists(_ key: String?) -> Bool {
        let anArray = nonNullKeys()//allKeys()
        
        if anArray.containsStr(obj: key) {
            return true
        }
        //        for i in 0..<anArray.count
        //        {
        //            if ((anArray[i] as AnyObject).caseInsensitiveCompare(key ?? "")).rawValue == 0 {
        //                return true
        //            }
        //        }
        return false
    }
    
    func getValForKey(strkey: String?) -> Any? {
        if keyExists(strkey) {
            let dict = self as! Dictionary<String, Any>
            if let val = dict[strkey!] {
                return val
            }
        }
        
        return nil
    }
    
    func getStringForKey(_ key: String?) -> String? {
        let strVal = getValForKey(strkey: key)
        if strVal == nil {
            return ""
        }
        return "\(strVal ?? "")"
    }
    
    func getJsonString() -> String {
        let jsonData: Data? = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        let error: Error? = nil
        if jsonData != nil && error == nil {
            var strTempCommand = ""
            if let aData = jsonData {
                strTempCommand = String(data: aData, encoding: .utf8)!
                return strTempCommand
            }
        }
        
        return ""
    }
    
    func removeNullValueKeys() -> Dictionary {
        var dict = self
        let keysToRemove = Array(dict.keys).filter { dict[$0] is NSNull }
        for key in keysToRemove {
            dict.removeValue(forKey: key)
        }
        return dict
    }
}


extension UIButton {
    // MARK Button and image alignment Like tabbar,
    func alignImageAndTitleVertically(padding: CGFloat) {
        let imageSize = self.imageView!.frame.size
        let titleSize = self.titleLabel!.frame.size
        let totalHeight = imageSize.height + titleSize.height + padding
        
        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageSize.height),
            left: 0,
            bottom: 0,
            right: -titleSize.width
        )
        
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: -imageSize.width,
            bottom: -(totalHeight - titleSize.height),
            right: 0
        )
    }
    
}



//MARK:- CALayer

extension CALayer {
    
    var borderUIColor: UIColor {
        set {
            self.borderColor = newValue.cgColor
        }
        
        get {
            return UIColor(cgColor: self.borderColor!)
        }
    }
}

//MARK: -  NSDate
extension NSDate {
    
    func dateToStringWithCustomFormat(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter.string(from: self as Date)
    }
    
    class func dateFromTimeInterval(timeInterval: Double) -> NSDate {
        // Convert to Date
        return NSDate(timeIntervalSince1970: timeInterval)
    }
    
    func getFormattedStringWithFormat() -> String? {
        return "\(getDay())\(getDateSuffixForDate()!) \(getThreeCharacterMonth()) '\(getTwoDigitYear())"
    }
    
    func getDateSuffixForDate() -> (String?) {
        let ones = getDay() % 10
        let tens = (getDay() / 10) % 10
        if (tens == 1) {
            return "th"
        } else if (ones == 1) {
            return "st"
        } else if (ones == 2) {
            return "nd"
        } else if (ones == 3) {
            return "rd"
        } else {
            return "th"
        }
    }
    
    func getDay() -> (Int) {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let components = calendar?.components(.day, from: self as Date)
        return components!.day!
    }
    
    func getMonth() -> (String) {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let components = calendar?.components(.month, from: self as Date)
        let dateFormatter = DateFormatter()
        return dateFormatter.monthSymbols[(components?.month)! - 1]
    }
    
    func getThreeCharacterMonth() -> (String) {
        //        return getMonth().substring(to: getMonth().startIndex.advancedBy(3))
        let secondCharIndex = getMonth().index(after: getMonth().startIndex)
        return getMonth().substring(from: secondCharIndex)
        
        
    }
    
    func getYear() -> (Int) {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let components = calendar?.components(.year, from: self as Date)
        return components!.year!
    }
    
    func getTwoDigitYear() -> (Int) {
        return getYear() % 100
    }
    
    class func convertTimeStampToDate(timeInterval: Double)->String{
        let date = NSDate(timeIntervalSince1970: timeInterval)
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd MMM, YYYY"
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        return dateString
    }
    
    class func convertDateFormatterFromTimestamp(date: String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"//this your string date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let date = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = "yyyy MMM EEEE HH:mm"///this is what you want to convert format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let timeStamp = dateFormatter.string(from: date!)
        return timeStamp
    }
    
    
    
    class func getTimeStamp() -> String{
        return "\(NSDate().timeIntervalSince1970 * 1000)"
        
    }
    
}


extension DateFormatter {
    
    convenience init (format: String) {
        self.init()
        dateFormat = format
        locale = Locale.current
    }
}


extension Date {
    
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}


extension Date {
    
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    

    static func timezone() -> String {
        return TimeZone.current.abbreviation() ?? "IST"
    }
    
    static func getCurrentDate() -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date())

    }
    
    static func getCurrentTime() -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        return dateFormatter.string(from: Date())

    }
    
    
    
    var dayAfter: Date {
          return Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    }
    
    static func getTomorrowDate() -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date().dayAfter)

    }
    
    static func getTimeStamp() -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.string(from: Date())

    }
    
    var europeanDateFormattedEn_US : String {
        Formatter.date.calendar = Calendar(identifier: .iso8601)
        Formatter.date.locale   = Locale(identifier: "en_US_POSIX")
        Formatter.date.timeZone = .current
        Formatter.date.dateFormat = "yyyy-MM-dd"
        return Formatter.date.string(from: self)
    }
    
    var europeanTimeFormattedEn_US : String {
        Formatter.date.calendar = Calendar(identifier: .iso8601)
        Formatter.date.locale   = Locale(identifier: "en_US_POSIX")
        Formatter.date.timeZone = .current
        Formatter.date.dateFormat = "HH:mm:ss"
        return Formatter.date.string(from: self)
    }
    
    public func addMinute(_ minute: Int) -> Date? {
        var comps = DateComponents()
        comps.minute = minute
        let calendar = Calendar.current
        let result = calendar.date(byAdding: comps, to: self)
        return result ?? nil
    }
}

extension String {
    func toDate (format: String) -> Date? {
        return DateFormatter(format: format).date(from: self)
    }
    func toDateString (outputFormat:String) -> String? {
        if let date = toDate(format: "yyyy.MM.dd'T'HH:mm:ss") {
            return DateFormatter(format: outputFormat).string(from: date)
        }
        return nil
    }
    
    var date: Date? {
        return Formatter.date.date(from: self)
    }
    
    func dateFormatted(with dateFormat: String = "yyyy-MM-dd", calendar: Calendar = Calendar(identifier: .iso8601), defaultDate: Date? = nil, locale: Locale = Locale(identifier: "en_US_POSIX"), timeZone: TimeZone = .current) -> Date? {
        Formatter.date.calendar = calendar
        Formatter.date.defaultDate = defaultDate ?? calendar.date(bySettingHour: 12, minute: 0, second: 0, of: Date())
        Formatter.date.locale = locale
        Formatter.date.timeZone = timeZone
        Formatter.date.dateFormat = dateFormat
        return Formatter.date.date(from: self)
    }
    
    func timeConversion12(time24: String) -> String {
        let dateAsString = time24
        let df = DateFormatter()
        df.dateFormat = "HH:mm:ss"

        let date = df.date(from: dateAsString)
        df.dateFormat = "h:mm a"

        let time12 = df.string(from: date!)
        return time12
    }
    
    func timeConversion24(time12: String) -> String {
        let dateAsString = time12
        let df = DateFormatter()
        df.dateFormat = "hh:mm:ssa"

        let date = df.date(from: dateAsString)
        df.dateFormat = "HH:mm:ss"

        let time24 = df.string(from: date!)
        return time24
    }
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }

        return String(data: data, encoding: .utf8)
    }

    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
}


extension Formatter {
    static let date = DateFormatter()
}




extension Array {
    mutating func removeObject<U: Equatable>(object: U) {
        var index: Int?
        for (idx, objectToCompare) in enumerated() {
            if let to = objectToCompare as? U {
                if object == to {
                    index = idx
                }
            }
        }
        
        if(index != nil) {
            self.remove(at: index!)
        }
    }
}


//MARK:- UIImageExtension
extension UIImage {
    
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    
    func save(at directory: FileManager.SearchPathDirectory,
              pathAndImageName: String,
              createSubdirectoriesIfNeed: Bool = true,
              compressionQuality: CGFloat = 1.0)  -> URL? {
        do {
        let documentsDirectory = try FileManager.default.url(for: directory, in: .userDomainMask,
                                                             appropriateFor: nil,
                                                             create: false)
        return save(at: documentsDirectory.appendingPathComponent(pathAndImageName),
                    createSubdirectoriesIfNeed: createSubdirectoriesIfNeed,
                    compressionQuality: compressionQuality)
        } catch {
            print("-- Error: \(error)")
            return nil
        }
    }

    func save(at url: URL,
              createSubdirectoriesIfNeed: Bool = true,
              compressionQuality: CGFloat = 1.0)  -> URL? {
        do {
            if createSubdirectoriesIfNeed {
                try FileManager.default.createDirectory(at: url.deletingLastPathComponent(),
                                                        withIntermediateDirectories: true,
                                                        attributes: nil)
            }
            guard let data = jpegData(compressionQuality: compressionQuality) else { return nil }
            try data.write(to: url)
            return url
        } catch {
            print("-- Error: \(error)")
            return nil
        }
    }
    
    func toBase64() -> String? {
        guard let imageData = self.pngData() else { return nil }
        return imageData.base64EncodedString(options: .lineLength64Characters)
    }
}


// load from path

extension UIImage {
    convenience init?(fileURLWithPath url: URL, scale: CGFloat = 1.0) {
        do {
            let data = try Data(contentsOf: url)
            self.init(data: data, scale: scale)
        } catch {
            print("-- Error: \(error)")
            return nil
        }
    }
}


//MARK:- UIColor
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
    
    static var bgColor = UIColor.init(hexString: "#F8F9FF")
    static var blueColor = UIColor.init(hexString: "#123393")
    static var textFieldColor = UIColor.init(hexString: "#F2F4FE")
    static var fontColor = UIColor.init(hexString: "#525D85")
    static var greenColor = UIColor.init(hexString: "#8CC96F")
    static var greenBorderColor = UIColor.init(hexString: "#7AB75F")
    static var yellowColor = UIColor.init(hexString: "#F19D38")
    static var yellowBorderColor = UIColor.init(hexString: "#CC852F")
    static var redColor = UIColor.init(hexString: "#CC514B")
}

//MARK: CGFloat
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}


// MARK: - Alert Controller
extension UIViewController {
    
    
    func presentAlertWithTitle(title: String, message : String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Ok", style: .default) {
            (action: UIAlertAction) in
            
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentAlertForLogout(title: String, message : String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "Ok", style: .default) {
            (action: UIAlertAction) in
            NavigationHelper.helper.logoutFromApp()
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func presentAlertActionWithBack(title: String, message : String, text: String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction) in
            self.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func presentAlertActionWithPush(title: String, message : String, text: String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) {
            (action: UIAlertAction) in
            
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(withTitle strTitle: String?, message strMsg: String?, buttons arrBtnsTitles: Array<String>, onButtonTap: @escaping (_ buttonIndex: Int) -> Void)
    {
        let alertController = UIAlertController(title: strTitle, message: strMsg, preferredStyle: .alert)
        
        if arrBtnsTitles.count > 0
        {
            for strBtnTitle in arrBtnsTitles
            {
                if strBtnTitle.count > 0
                {
                    alertController.addAction(UIAlertAction(title: strBtnTitle, style: .default, handler: { action in
                        let index: Int? = (arrBtnsTitles as NSArray?)?.index(of: action.title as Any)
                        onButtonTap(index!)
                    }))
                }
            }
        }
        else
        {
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            }))
        }
        present(alertController, animated: true)
    }
    
    // MARK: - Check If NavigationController Contains VC Then Push Or Pop
    func navigate(withAnimation animate: Bool)
    {
        var popToVC = false
        let arrVCs = NavigationHelper.helper.contentNavController!.viewControllers
        
        for index in 0...(arrVCs.count-1)
        {
            let vc = arrVCs[index]
            
            if (vc.restorationIdentifier == self.restorationIdentifier)
            {
                popToVC = true
                NavigationHelper.helper.contentNavController!.popToViewController(vc, animated: animate)
                break
            }
        }
        if popToVC
        {
            print("Popped ...")
        }
        else// if let aController UIViewControllerer
        {
            print("Pushed ...")
            
            NavigationHelper.helper.contentNavController!.pushViewController(self, animated: animate)
        }
    }
}


extension UINavigationController {
  func popToViewController(ofClass: AnyClass, animated: Bool = true) {
    if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
      popToViewController(vc, animated: animated)
    }
  }
}


// MARK: - ImageViewController
extension UIImageView {
    public func imageFromURL(urlString: String) {
        
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        activityIndicator.startAnimating()
        if self.image == nil{
            self.addSubview(activityIndicator)
        }
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                activityIndicator.removeFromSuperview()
                self.image = image
            })
            
        }).resume()
    }
    
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}


//MARK: UITextField
extension UITextField{
    
    func addDoneButtonToKeyboard(myAction:Selector?){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: myAction)
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
}


//MARK: DropShadow using UIView
extension UIView {
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func fadeIn(duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    
    /**
     Fade out a view with a duration
     
     - parameter duration: custom animation duration
     */
    func fadeOut(duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }

}


extension UserDefaults
{
    static func saveString(value strVal:String, forKey strKey:String)
    {
        self.standard.set(strVal as Any, forKey: strKey)
        
        self.standard.synchronize()
    }
    
    static func  getString(forKey strKey:String) -> String
    {
        let val = self.standard.object(forKey: strKey)
        
        return "\(val ?? "")"
    }
}


struct AES {

    // MARK: - Value
    // MARK: Private
    private let key: Data
    private let iv: Data


    // MARK: - Initialzier
    init?(key: String, iv: String) {
        guard key.count == kCCKeySizeAES128 || key.count == kCCKeySizeAES256, let keyData = key.data(using: .utf8) else {
            debugPrint("Error: Failed to set a key.")
            return nil
        }

        guard iv.count == kCCBlockSizeAES128, let ivData = iv.data(using: .utf8) else {
            debugPrint("Error: Failed to set an initial vector.")
            return nil
        }


        self.key = keyData
        self.iv  = ivData
    }


    // MARK: - Function
    // MARK: Public
    func encrypt(string: String) -> Data? {
        return crypt(data: string.data(using: .utf8), option: CCOperation(kCCEncrypt))
    }

    func decrypt(data: Data?) -> String? {
        guard let decryptedData = crypt(data: data, option: CCOperation(kCCDecrypt)) else { return nil }
        return String(bytes: decryptedData, encoding: .utf8)
    }

    func crypt(data: Data?, option: CCOperation) -> Data? {
        guard let data = data else { return nil }

        let cryptLength = data.count + kCCBlockSizeAES128
        var cryptData   = Data(count: cryptLength)

        let keyLength = key.count
        let options   = CCOptions(kCCOptionPKCS7Padding)

        var bytesLength = Int(0)

        let status = cryptData.withUnsafeMutableBytes { cryptBytes in
            data.withUnsafeBytes { dataBytes in
                iv.withUnsafeBytes { ivBytes in
                    key.withUnsafeBytes { keyBytes in
                    CCCrypt(option, CCAlgorithm(kCCAlgorithmAES), options, keyBytes.baseAddress, keyLength, ivBytes.baseAddress, dataBytes.baseAddress, data.count, cryptBytes.baseAddress, cryptLength, &bytesLength)
                    }
                }
            }
        }

        guard UInt32(status) == UInt32(kCCSuccess) else {
            debugPrint("Error: Failed to crypt data. Status \(status)")
            return nil
        }

        cryptData.removeSubrange(bytesLength..<cryptData.count)
        return cryptData
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }

}

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ state: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.administrativeArea, $0?.first?.country, $1) }
    }
}

// MARK: CustomPoppinsFont
extension UIFont {
    public enum PoppinsType: String {
        case medium = "-Medium"
        case black = "-Black"
        case extraboldItalic = "-ExtraboldItalic"
        case semiboldItalic = "-SemiboldItalic"
        case semibold = "-SemiBold"
        case regular = ""
        case lightItalic = "Light-Italic"
        case light = "-Light"
        case italic = "-Italic"
        case extraBold = "-Extrabold"
        case boldItalic = "-BoldItalic"
        case bold = "-Bold"
    }
    static func Poppins(_ type: PoppinsType = .regular, size: CGFloat = UIFont.systemFontSize) -> UIFont {
        return UIFont(name: "Poppins\(type.rawValue)", size: size)!
    }
    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }
    var isItalic: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitItalic)
    }
}

// MARK: KeyboardHandlerTableViewCell
extension UITableView {
    func setBottomInset(to value: CGFloat) {
        let edgeInset = UIEdgeInsets(top: 0, left: 0, bottom: value, right: 0)
        self.contentInset = edgeInset
        self.scrollIndicatorInsets = edgeInset
    }
    
    func reloadData(completion:@escaping ()->()) {
        UIView.animate(withDuration: 0, animations: reloadData)
            { _ in completion() }
    }
}
