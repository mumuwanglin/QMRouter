//
//  HomeModule.swift
//  Home
//
//  Created by mumu on 2020/11/25.
//

import Foundation

final public class HomeModule: HomeModuleService, QMSharedInstanceProtocol {
    
    public static var sharedInstance: HomeModule = HomeModule()
    
    // 注册Module的优先级
    public var priority: Int = 101
    
    // 是否异步注册Module
    public var setupModuleSynchronously: Bool { return false }
        
    
    public func setup() {
        QMRouter.bind(kRouteHomePage) { (params) -> Any in
            return HomeViewController()
        }
    }
}
