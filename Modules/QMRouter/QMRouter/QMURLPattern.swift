//
//  QMURLPattern.swift
//  QMRouter
//
//  Created by mumu on 2020/11/18.
//  URL 解析类，解析 host、path、params

import Foundation

public protocol QMURLPattern {
    
    /// url
    var urlString: String { get }
    
    /// 组成
    var components: Dictionary<String, String> { get }
}


/// URL解析类
class QMURLAnalysis: QMURLPattern {
    
    var urlString: String = ""
    
    var components: Dictionary<String, String> = Dictionary()
    
    init(urlString: String) {
        let URL = NSURL(string: urlString)
        
        self.urlString = "\(String(describing: URL?.host  ?? ""))\(String(describing: URL?.path  ?? ""))"
        
        let query = URL?.query
        
        if query != nil {
            let querryArray = query?.components(separatedBy: "&") ?? []
            
            for queryComponent in querryArray {
                let queryComponentPartArray = queryComponent.components(separatedBy: "=")
                if queryComponentPartArray.count >= 2 {
                    self.components.updateValue(queryComponentPartArray[1] as String, forKey: queryComponentPartArray[0])
                }
            }
        }
    }
    
}
