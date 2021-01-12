//
//  AppDelegate.swift
//  Countries
//
//  Created by Sachendra Singh on 11/01/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow()
        window?.rootViewController = UINavigationController(rootViewController: CountriesViewController(withPresenter: CountriesPresenter()))
        window?.makeKeyAndVisible()
        
        return true
    }

}

