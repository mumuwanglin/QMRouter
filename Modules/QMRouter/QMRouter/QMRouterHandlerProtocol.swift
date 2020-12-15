//
//  QMRouterHandlerProtocol.swift
//  QMRouter
//
//  Created by mumu on 2020/11/18.
//  url 映射 handler 的抽象协议

import Foundation

/// 路由处理类型
public typealias QMRouteHandler = ([String: Any]) -> Any?

/// 结束回调
public typealias QMRouteCompletion = (Any) -> Void

/// handler 协议
public protocol QMRouterHandlerProtocol {
    
    /// 给 url 绑定 handler
    func bind(_ url: String, to handler: @escaping QMRouteHandler)
    
    /// 给 url 解绑
    func unbind(_ url: String)
    
    /// 解绑所有 urls
    func unbindAllURLs()
    
    /// 是否可以处理 url
    func canHandle(_ url: String) -> Bool
    
    /// 处理 handle
    func handle(_ url: String) -> Any?
    
    /// 处理 url
    func handle(_ url: String, complexParams: [String: Any]? , completion: QMRouteCompletion?) -> Any?
    
    func complete(_ params: Dictionary<String, Any>, result: Any)
}
