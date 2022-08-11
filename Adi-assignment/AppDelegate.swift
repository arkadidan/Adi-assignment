//
//  AppDelegate.swift
//  Adi-assignment
//
//  Created by arkadi.daniyelian on 11/08/2022.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var coordinator: Coordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        self.coordinator = Coordinator(window: self.window!)
        self.coordinator.start()
        return true
    }


}
