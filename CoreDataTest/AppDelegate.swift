//
//  AppDelegate.swift
//  CoreDataTest
//
//  Created by Arslan Abdullaev on 26.01.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: TaskViewController())
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        TaskData.shared.saveContext()
    }
}

