//
//  QMURLMatcher.swift
//  QMRouter
//
//  Created by mumu on 2020/11/18.
//  URL 匹配器

import Foundation

public protocol QMURLMatcher: class {
//    
//    /// 下一个匹配器（责任链模式）
//    var next: QMURLMatcher? { get set }
//    
//    /// 判断是否匹配
//    func match(_ url: QMURLPattern) -> Bool
    @discardableResult
    func setNext(handler: QMURLMatcher) -> QMURLMatcher

    func handle(request: String) -> String?

    var nextHandler: QMURLMatcher? { get set }
}

extension QMURLMatcher {
    func setNext(handler: QMURLMatcher) -> QMURLMatcher {
        self.nextHandler = handler
        
        return handler
    }
    
    func handle(request: String) -> String? {
        return nextHandler?.handle(request: request)
    }
}

class QMURLMactchClient {
    
    static func matchURL(matcher: QMURLMatcher) {
        
    }
    
}

