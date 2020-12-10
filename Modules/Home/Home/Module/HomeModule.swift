//
//  HomeModule.swift
//  Home
//
//  Created by mumu on 2020/11/25.
//

import Foundation

final public class HomeModule: NSObject, HomeModuleService, QMSharedInstanceProtocol {
    
    public static var sharedInstance: HomeModule = HomeModule()
    
    // 注册Module的优先级
    public var priority: Int = 101
    
    // 是否异步注册Module
    public var setupModuleSynchronously: Bool { return false }
        
    
    public func setup() {
        QMRouter.shared.bind(kRouteHomePage) { (params) -> Any in
            return HomeViewController()
        }
    }
}

extension HomeModule: QMApplicationLifeCycle {
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        print("didFinishLaunchingWithOptions launchOptions")
        
        return true
    }
}
