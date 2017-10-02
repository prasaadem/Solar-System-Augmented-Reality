//
//  AppDelegate.swift
//  Solar System
//
//  Created by Aditya Emani on 9/20/17.
//  Copyright © 2017 Aditya Emani. All rights reserved.
//

import UIKit

var planetInfo:[String:Any] = [:]
var solarSystem:[String:Any] = [:]

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        Chameleon.setGlobalThemeUsingPrimaryColor(UIColor(red:0.25, green:0.29, blue:0.41, alpha:1.0), with: .dark)
//        UIButton.appearance(whenContainedInInstancesOf: [ViewController.self]).backgroundColor = UIColor.clear
        if let font = UIFont(name: "AppleSDGothicNeo-Light", size: 20) {
            let navigationBarAppearace = UINavigationBar.appearance()
            navigationBarAppearace.titleTextAttributes = [NSAttributedStringKey.font:font]
            navigationBarAppearace.tintColor = UIColor(red:0.74, green:0.89, blue:0.96, alpha:1.0)
        }
        
        getDataFromPlistFile()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    func getDataFromPlistFile(){
        //planetInfo for populating planet Info
        if let path = Bundle.main.path(forResource: "planetInfo", ofType: "plist") {
            if let dic = NSDictionary(contentsOfFile: path) as? [String: Any] {
                planetInfo = dic
            }
        }
        
        //solarSystem.plist for building solar system
        if let path = Bundle.main.path(forResource: "solarSystem", ofType: "plist") {
            if let dic = NSDictionary(contentsOfFile: path) as? [String: Any] {
                solarSystem = dic
            }
        }
        
    }

    

}

