//
//  QMURLMatcher.swift
//  QMRouter
//
//  Created by mumu on 2020/11/18.
//  URL 匹配器

import Foundation

public protocol QMURLMatcher {
    
    /// 下一个匹配器（责任链模式）
    var next: QMURLMatcher? { get set }
    
    /// 判断是否匹配
    func match(_ url: QMURLPattern) -> Bool
}
