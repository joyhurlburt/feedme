//
//  AppDelegate.swift
//  FinalProject
//
//  Created by Joy Hurlburt.
//
//


import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        let navigationBarAppearance = UINavigationBar.appearance()
        let tabBarAppearance = UITabBar.appearance()
        
        navigationBarAppearance.barStyle = UIBarStyle.Black
        navigationBarAppearance.tintColor = UIColorFromHex(0xffffff)
        navigationBarAppearance.barTintColor = UIColorFromHex(0x50E3C2)
        tabBarAppearance.barStyle = UIBarStyle.Black
        tabBarAppearance.tintColor = UIColorFromHex(0xffffff)
        tabBarAppearance.barTintColor = UIColorFromHex(0x50E3C2)
        
        return true
	}
    
    func UIColorFromHex(rgbValue:UInt32) -> UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }

	// MARK: Properties
	var window: UIWindow?
}

