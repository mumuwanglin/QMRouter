//
//  QMRouter.swift
//  QMRouter
//
//  Created by mumu on 2020/11/18.
//  路由类
import Foundation

let kQMRouterURL = "kQMRouterURL"
let kQMRouterCompletion = "kQMRouterCompletion"

final public class QMRouter: QMRouterModuleProtocol {
    
    // 保存Module的字典
    public static var moduleDict = [String: Any]()
    
    /// 所有注册的 module
    public static var allRegisterModules: [QMModuleProtocol] {
        let modules = moduleDict.values.compactMap { $0 as? QMModuleProtocol }
        return modules.sorted { $0.priority > $1.priority }
    }

    /// 注册 module
    public static func register<Module>(_ protocolType: Module.Type, module: Module) {
        let key = moduleKey(for: protocolType)
        moduleDict[key] = module
    }

    /// 注销 module
    public static func unregister<Module>(_ protocolType: Module.Type) {
        moduleDict.removeValue(forKey: "\(protocolType)")
    }

    /// 注销所有 modules
    public static func unregisterAllModules() {
        moduleDict.removeAll()
    }
    
    /// 是否注册过 module
    public static func registered<Module>(for protocolType: Module.Type) -> Bool {
        let key = moduleKey(for: protocolType)
        return moduleDict[key] != nil
    }

    /// 获取 module
    public static func module<Module>(for protocolType: Module.Type) -> Module? {
        let key = moduleKey(for: protocolType)
        guard  let module = moduleDict[key] else {
            return nil
        }
        return module as? Module
    }

    /// 初始化所有的 modules
    public static func setupAllModules() {
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
    
    private static func moduleKey<Module>(for protocolType: Module.Type) -> String {
        return "\(protocolType)"
    }
}


extension QMRouter: QMRouterHandlerProtocol {
    
    @QMProtected
    public static var routes = [String: QMRouteHandler]()
    
    /// 绑定路由
    public static func bind(_ url: String, to handler: @escaping ([String : Any]) -> Any) {
        let urlAnalysis = QMURLAnalysis(url)
        
        routes[urlAnalysis.urlKey] = handler
    }
    
    /// 解绑路由
    public static func unbind(_ url: String) {
        let urlAnalysis = QMURLAnalysis(url)
        routes.removeValue(forKey: urlAnalysis.urlKey)
    }
    
    /// 解绑所有路由
    public static func unbindAllURLs() {
        routes.removeAll()
    }
    
    /// 判断是否可以绑定路由
    public static func canHandle(_ url: String) -> Bool {
        let urlAnalysis = QMURLAnalysis(url)
        if url.isEmpty {
            return false
        }
        
        guard self.routes[urlAnalysis.urlKey] != nil else {
            return false
        }
        return true
    }
    
    /// 处理 handle
    public static func handle(_ url: String) -> Any? {

        return handle(url, complexParams: nil, completion: nil)
    }
    
    /// 处理带参数的 handle
    public static func handle(_ url: String, complexParams: [String : Any]?, completion: QMRouteCompletion?) -> Any? {
        
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
        
        assert(false, "路由信息获取失败,请检查URL是否匹配")
        return nil
    }
    
    /// 路由获取成功的回调
    public static func complete(_ params: Dictionary<String, Any>, result: Any) {
        let completion = params[kQMRouterCompletion] as? QMRouteCompletion
                
        if let block = completion {            
            block(result)
        }
    }
}
