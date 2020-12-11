//
//  AppDelegate.swift
//  App
//
//  Created by mumu on 2020/11/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // 注册Module
        registerModules()
        
        let _ = QMRouter.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }

    // 注册协议
    func registerModules() {
        QMRouter.shared.register(HomeModuleService.self, module: HomeModule.sharedInstance)
        QMRouter.shared.register(GoodsModuleService.self, module: GoodsModule.sharedInstance)
        QMRouter.shared.register(SaleModuleService.self, module: SaleModule.sharedInstance)
//        QMRouter.shared.setupModules(for: HomeModuleService.self)
//        QMRouter.shared.setupModules(for: GoodsModuleService.self)
//        QMRouter.shared.setupModules(for: SaleModuleService.self)
        QMRouter.shared.setupAllModules()
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        QMRouter.shared.applicationWillTerminate(application)
    }
}

