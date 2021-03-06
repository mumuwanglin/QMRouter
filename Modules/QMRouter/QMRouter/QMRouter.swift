//
//  QMRouter.swift
//  QMRouter
//
//  Created by mumu on 2020/11/18.
//  路由类
import Foundation
import UIKit

let kQMRouterURL = "kQMRouterURL"
let kQMRouterCompletion = "kQMRouterCompletion"

final public class QMRouter: NSObject, QMRouterModuleProtocol {
    
    public static let shared = QMRouter()
    
    /// 保存路由的字典
    @QMProtected
    public var routes = [String: QMRouteHandler]()
    
    /// 保存Module的字典
    public var moduleDict = [String: Any]()
    
    /// 所有注册的 Module
    public var allRegisterModules: [QMModuleProtocol] {
        // 只有遵循 QMModuleProtocol 的Module才会被初始化
        let modules = moduleDict.values.compactMap { $0 as? QMModuleProtocol }
        // module 根据 priority 排序
        return modules.sorted { $0.priority > $1.priority }
    }

    /// 注册 module
    public func register<Module>(_ protocolType: Module.Type, module: Module) {
        let key = moduleKey(for: protocolType)
        moduleDict[key] = module
    }

    /// 注销 module
    public func unregister<Module>(_ protocolType: Module.Type) {
        moduleDict.removeValue(forKey: moduleKey(for: protocolType))
    }

    /// 注销所有 modules
    public func unregisterAllModules() {
        moduleDict.removeAll()
    }
    
    /// 是否注册过 module
    public func registered<Module>(for protocolType: Module.Type) -> Bool {
        let key = moduleKey(for: protocolType)
        return moduleDict[key] != nil
    }

    /// 获取 module
    public func module<Module>(for protocolType: Module.Type) -> Module? {
        let key = moduleKey(for: protocolType)
        guard  let module = moduleDict[key] else {
            assertionFailure("Module 获取失败")
            return nil
        }
        return module as? Module
    }

    /// 初始化所有的 modules
    public func setupAllModules() {
        allRegisterModules.forEach { (module) in            
            if module.setupModuleSynchronously {
                DispatchQueue.global(qos: .default).async {
                    module.setup()
                }
            } else {
                module.setup()
            }
        }
    }
    
    private func moduleKey<Module>(for protocolType: Module.Type) -> String {
        return "\(protocolType)"
    }
}


extension QMRouter: QMRouterHandlerProtocol {
        
    /// 绑定路由
    public func bind(_ url: String, to handler: @escaping ([String : Any]) -> Void) {
        let urlAnalysis = QMURLAnalysis(url)
        
        routes[urlAnalysis.urlKey] = handler
    }
    
    /// 解绑路由
    public func unbind(_ url: String) {
        let urlAnalysis = QMURLAnalysis(url)
        routes.removeValue(forKey: urlAnalysis.urlKey)
    }
    
    /// 解绑所有路由
    public func unbindAllURLs() {
        routes.removeAll()
    }
    
    /// 判断是否可以绑定路由
    public func canHandle(_ url: String) -> Bool {
        let urlAnalysis = QMURLAnalysis(url)
        if url.isEmpty {
            return false
        }
        
        guard self.routes[urlAnalysis.urlKey] != nil else {
            return false
        }
        return true
    }
    
    /// 处理带参数的 handle
    @discardableResult
    public func handle(_ url: String, complexParams: [String : Any]? = nil, completion: QMRouteCompletion? = nil) -> Any? {
        
        let urlAnalysis = QMURLAnalysis(url)
        
        let handler = self.routes[urlAnalysis.urlKey]
        
        var params = [String: Any]()
        params = params.merging(complexParams ?? [:]){ (current, _) in current }
        params = params.merging(urlAnalysis.components){ (current, _) in current }
        params[kQMRouterURL] = urlAnalysis.urlKey
        params[kQMRouterCompletion] = completion
        
        if let block = handler {            
             return block(params)
        }
        
        assertionFailure("路由信息获取失败,请检查URL是否匹配")
        return nil
    }
    
    /// 路由获取成功的回调
    public func complete(_ params: Dictionary<String, Any>, result: Any) {
        let completion = params[kQMRouterCompletion] as? QMRouteCompletion
                
        if let block = completion {            
            block(result)
        }
    }
}

/// Application 生命周期方法
extension QMRouter: QMApplicationLifeCycle {
    /// 所有实现 Application 协议的 Module
    public var allApplicationModules: [QMApplicationLifeCycle] {
        let modules = moduleDict.values.compactMap { $0 as? QMApplicationLifeCycle}
        return modules
    }
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        allApplicationModules.forEach { (module) in
            let _ = module.application?(application, didFinishLaunchingWithOptions: launchOptions)
        }
        return true
    }
    
    public func applicationWillTerminate(_ application: UIApplication) {
        allApplicationModules.forEach { (module) in
            module.applicationWillTerminate?(application)
        }
    }
    
}
