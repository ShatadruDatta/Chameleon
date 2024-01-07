//
//  AppDelegate.swift
//  expaTPA
//
//  Created by Shatadru Datta on 11/03/20.
//  Copyright © 2020 Procentris. All rights reserved.
//



import Foundation
import UIKit

//MARK: - DEVICE SETTINGS -
struct DeviceSettings{
    
    static var token                   = String()
    static var udid                    = String()
    static var bundleID                = String()
    static var version                 = String()
    static var platformType            = "1"
    static var activeStatus            = "1"
    static var inactiveStatus          = "0"
    static var shorthandBundleID       = "com.redappletech."
    
    static func getApplicationVersionNumber() ->String {
        
        let nsObject: AnyObject? = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as AnyObject?
        let version = nsObject as! String
        return version
    }
    
    static func dispatchQueueName(_ string : String) ->String {
        let resultStr = "\(shorthandBundleID).\(string)"
        return resultStr
    }
    
}
enum AppConfiguration {
    case Debug
    case TestFlight
    case AppStore
}

struct Config {
    // This is private because the use of 'appConfiguration' is preferred.
    private static let isTestFlight = Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt"
    
    // This can be used to add debug statements.
    static var isDebug: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }
    
    static var appConfiguration: AppConfiguration {
        if isDebug {
            return .Debug
        } else if isTestFlight {
            return .TestFlight
        } else {
            return .AppStore
        }
    }
    
}


//MARK: - DEVICE TYPE -
enum UIUserInterfaceIdiom : Int {
    case unspecified
    case phone
    case pad
}

struct ScreenSize {
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType {
    static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
    static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
    static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
    static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
    static let IS_IPHONE_7          = IS_IPHONE_6
    static let IS_IPHONE_7P         = IS_IPHONE_6P
    
    static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad//UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
    
    static let IS_ALL_IPAD          = UIDevice.current.userInterfaceIdiom == .pad
    static let IS_ALL_IPHONE        = UIDevice.current.userInterfaceIdiom == .phone
}

//MARK: - iOS TYPE -
struct Version {
    static let SYS_VERSION_FLOAT = (UIDevice.current.systemVersion as NSString).floatValue
    static let iOS7 = (Version.SYS_VERSION_FLOAT < 8.0 && Version.SYS_VERSION_FLOAT >= 7.0)
    static let iOS8 = (Version.SYS_VERSION_FLOAT >= 8.0 && Version.SYS_VERSION_FLOAT < 9.0)
    static let iOS9 = (Version.SYS_VERSION_FLOAT >= 9.0 && Version.SYS_VERSION_FLOAT < 10.0)
    static let iOS10 = (Version.SYS_VERSION_FLOAT >= 10.0)
}

//MARK: - COLOR -
struct Color {
    static let AppAlertView_BLUE = UIColor(red: 92.0/255.0, green: 155.0/255.0, blue: 231.0/255.0, alpha: 1.0)
}

//MARK: - FONTS TYPE -
struct Fonts{
    
    /// BOLD
    static let Bariol_BOLD_11 = UIFont(name: "Bariol-Bold", size: 11)
    
    ///Business
    
    static  func universalEmailAndPasswordRegularFont() -> UIFont{
        
        var typeFont = UIFont()
        
        if (DeviceType.IS_IPHONE_4_OR_LESS){
            typeFont = Fonts.Bariol_BOLD_11!
        }else if (DeviceType.IS_IPHONE_5){
            typeFont = Fonts.Bariol_BOLD_11!
        }else if (DeviceType.IS_IPHONE_6 || DeviceType.IS_IPHONE_7){
            typeFont = Fonts.Bariol_BOLD_11!
        }else if (DeviceType.IS_IPHONE_6P || DeviceType.IS_IPHONE_7P){
            typeFont = Fonts.Bariol_BOLD_11!
        }else{
            typeFont = Fonts.Bariol_BOLD_11!
        }
        return typeFont
    }

}

struct CustomFloat {
    static func alertViewMoveUpHeight() -> CGFloat{
        if DeviceType.IS_IPHONE_4_OR_LESS{
            return 90.0
        }else if DeviceType.IS_IPHONE_5{
            return 60.0
        }else{
            return 0.0
        }
    }
}
