//
//  QMRouterModuleProtocol.swift
//  QMRouter
//
//  Created by mumu on 2020/11/18.
//  protocol 映射 module 的抽象协议

import Foundation

public protocol QMRouterModuleProtocol {
    /// 所有注册的Modules
    var allRegisterModules: [QMModuleProtocol] { get }
    
    /// 注册 module
    func register<Module>(_ protocolType: Module.Type, module: Module)
    
    /// 注销 module
    func unregister<Module>(_ protocolType: Module.Type)
    
    /// 注销所有 modules
    func unregisterAllModules()
    
    /// 是否注册过 module
    func registered<Module>(for protocolType: Module.Type) -> Bool
    
    /// 获取 module
    func module<Module>(for protocolType: Module.Type) -> Module?
    
    /// 初始化 module    
    func setupModules<Module>(for protocolType: Module.Type)
    
    /// 初始化所有的 modules
    func setupAllModules()
}
