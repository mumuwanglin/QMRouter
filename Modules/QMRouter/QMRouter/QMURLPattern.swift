//
//  QMURLPattern.swift
//  QMRouter
//
//  Created by mumu on 2020/11/18.
//  URL 解析类，解析 host、path、params

import Foundation

public protocol QMURLPattern {
    /// scheme
    var scheme: String { get }
    
    /// host
    var host: String { get }
    
    /// components
    var components: Dictionary<String, String> { get }

}


/// URL解析类
class QMURLAnalysis: QMURLPattern {
    
    var scheme: String = ""
    
    var host: String = ""
    
    var components: Dictionary<String, String> = Dictionary()
    
    init(_ linkUrl: String) {
        if !linkUrl.isEmpty, let urlString = linkUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            let URL = NSURL(string: urlString)
            
            self.host = URL?.host ?? ""
            self.scheme = URL?.scheme ?? ""
            
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
}
