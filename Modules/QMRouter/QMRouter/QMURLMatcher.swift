//
//  QMURLMatcher.swift
//  QMRouter
//
//  Created by mumu on 2020/11/18.
//  URL 匹配器

import Foundation

public protocol QMURLHandler: class {
    
    var next: QMURLHandler? { get set }

    func handle(_ urlString: String) -> String?
}
