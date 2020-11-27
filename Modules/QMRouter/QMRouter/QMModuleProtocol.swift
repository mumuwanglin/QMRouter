//
//  QMModuleProtocol.swift
//  QMRouter
//
//  Created by mumu on 2020/11/18.
//  抽象模块协议

import Foundation

let kQMRouterModulePriority: Int = 100

/// 模块协议
public protocol QMModuleProtocol {
    
    /// 优先级
    var priority: Int { get }
    
    /// 异步初始化
    var setupModuleSynchronously: Bool { get }
    
    /// 初始化设置
    func setup()
}

public extension QMModuleProtocol {
    /// 优先级
    var priority: Int { return kQMRouterModulePriority }
    /// 异步初始化
    var setupModuleSynchronously: Bool { return false }
    /// 初始化设置
    func setup() {}
}

/// 单例类
public protocol QMSharedInstanceProtocol {
    
    /// 单例
    static var sharedInstance: Self { get }
}
