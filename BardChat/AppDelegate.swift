//
//  AppDelegate.swift
//  BardChat
//
//  Created by parkminwoo on 2023/05/26.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = BardChatViewController()
        window?.makeKeyAndVisible()
        return true
    }
}
