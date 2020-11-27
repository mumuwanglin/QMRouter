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
    
    /// 保存Module的字典
    public static var moduleDict = [String: QMModuleProtocol]()
    
    /// 所有注册的 module
    public static var allRegisterModules: [QMModuleProtocol] {
        return moduleDict.values.sorted { $0.priority > $1.priority }
    }

    /// 注册 module
    public static func register<Module: QMModuleProtocol & QMSharedInstanceProtocol>(_ protocolName: String, module: Module) {
        assert(!protocolName.isEmpty, "协议名不能为空")
        moduleDict[protocolName] = module
    }

    /// 注销 module
    public static func unregister(_ protocolName: String) {
        moduleDict.removeValue(forKey: protocolName)
    }

    /// 注销所有 modules
    public static func unregisterAllModules() {
        moduleDict.removeAll()
    }
    
    /// 是否注册过 module
    public static func registered(for protocolName: String) -> Bool {
        return moduleDict[protocolName] != nil
    }

    /// 获取 module
    public static func module(for protocolName: String) -> QMModuleProtocol? {
        guard  let module = moduleDict[protocolName] else {
            assert(false, "Module获取失败")
            return nil
        }
        return module
    }

    /// 初始化所有的 modules
    public static func setupAllModules() {
        allRegisterModules.forEach { (module) in
            // 判断是否需要异步测试Module
            if module.setupModuleSynchronously {
                DispatchQueue.global(qos: .default).async {
                    module.setup()
                }
            } else {
                module.setup()
            }
        }
    }
}


extension QMRouter: QMRouterHandlerProtocol {
    
    @QMProtected
    public static var routes = [String: QMRouteHandler]()
    
    /// 绑定路由
    public static func bind(_ url: String, to handler: @escaping ([String : Any]) -> Any) {
        let urlAnalysis = QMURLAnalysis(urlString: url)
        
        routes[urlAnalysis.urlString] = handler
    }
    
    /// 解绑路由
    public static func unbind(_ url: String) {
        let urlAnalysis = QMURLAnalysis(urlString: url)
        routes.removeValue(forKey: urlAnalysis.urlString)
    }
    
    /// 解绑所以路由
    public static func unbindAllURLs() {
        routes.removeAll()
    }
    
    /// 是否可以处理 url
    public static func canHandle(_ url: String) -> Bool {
        let urlAnalysis = QMURLAnalysis(urlString: url)
        
        if urlAnalysis.urlString.isEmpty {
            return false
        }
        
        guard self.routes[urlAnalysis.urlString] != nil else {
            return false
        }
        return true
    }
    
    /// 处理 handle
    public static func handle(_ url: String) -> Any? {

        return handle(url, complexParams: nil, completion: nil)
    }
    
    /// 带回调方法的handle处理
    public static func handle(_ url: String, complexParams: [String : Any]?, completion: QMRouteCompletion?) -> Any? {
        
        let urlAnalysis = QMURLAnalysis(urlString: url)
        
        let handler = self.routes[urlAnalysis.urlString]
        
        var params = [String: Any]()
        params = params.merging(urlAnalysis.components){ (current, _) in current }
        params[kQMRouterURL] = urlAnalysis.urlString
        params[kQMRouterCompletion] = completion
        
        if let block = handler {            
             return block(params)
        }

        return nil
    }
    
    /// 绑定路由完成后的回调
    public static func complete(_ params: Dictionary<String, Any>, result: Any) {
        let completion = params[kQMRouterCompletion] as? QMRouteCompletion
                
        if let block = completion {            
            block(result)
        }
    }
}
