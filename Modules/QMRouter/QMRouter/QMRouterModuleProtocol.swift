//
//  QMRouterModuleProtocol.swift
//  QMRouter
//
//  Created by mumu on 2020/11/18.
//  protocol 映射 module 的抽象协议

import Foundation

public protocol QMRouterModuleProtocol {
    /// 所有注册的Modules
    static var allRegisterModules: [QMModuleProtocol] { get }
    
    /// 注册 module
    static func register<Module>(_ protocolType: Module.Type, module: Module)
    
    /// 注销 module
    static func unregister<Module>(_ protocolType: Module.Type)
    
    /// 注销所有 modules
    static func unregisterAllModules()
    
    /// 是否注册过 module
    static func registered<Module>(for protocolType: Module.Type) -> Bool
    
    /// 获取 module
    static func module<Module>(for protocolType: Module.Type) -> Module?
    
    /// 初始化所有的 modules
    static func setupAllModules()
}
