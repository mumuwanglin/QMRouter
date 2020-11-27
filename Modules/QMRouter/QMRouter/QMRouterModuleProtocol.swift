//
//  QMRouterModuleProtocol.swift
//  QMRouter
//
//  Created by mumu on 2020/11/18.
//  protocol 映射 module 的抽象协议

import Foundation

public protocol QMRouterModuleProtocol {
    
    /// 所有注册的 module
    static var allRegisterModules: [QMModuleProtocol] { get }
    
    /// 注册 module
    static func register<Module: QMModuleProtocol & QMSharedInstanceProtocol>(_ protocolName: String, module: Module)
    
    /// 注销 module
    static func unregister(_ protocolName: String)
    
    /// 注销所有 modules
    static func unregisterAllModules()
    
    /// 是否注册过 module
    static func registered(for protocolName: String) -> Bool
    
    /// 获取 module
    static func module(for protocolName: String) -> QMModuleProtocol?
    
    /// 初始化所有的 modules
    static func setupAllModules()
}
