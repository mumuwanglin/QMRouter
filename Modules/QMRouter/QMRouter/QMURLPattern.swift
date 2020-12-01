//
//  QMURLPattern.swift
//  QMRouter
//
//  Created by mumu on 2020/11/18.
//  URL 解析类，解析 host、path、params

import Foundation

public enum QMURLPatternType: String {
    case web = "freereader"     // 前端跳转的路由
    case router = "qmrouter"    // APP内自定义跳转的路由
    case openURL = "openurl"    // UIApplication打开URL
}

public protocol QMURLPattern {
    /// 路由类型
    var urlType: QMURLPatternType? { get }
    
    /// 存储到路由的key
    var urlKey: String { get }
    
    /// 组成
    var components: Dictionary<String, String> { get }
}


/// URL解析类
class QMURLAnalysis: QMURLPattern {

    var urlType: QMURLPatternType?
    
    var urlKey: String = ""
    
    var components: Dictionary<String, String> = Dictionary()
    
    init(_ linkUrl: String) {
        if !linkUrl.isEmpty, let urlString = linkUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            
            let URL = NSURL(string: urlString)
            
            self.urlKey = "//\( URL?.host ?? "")\(URL?.path ?? "")"
            
            if URL?.scheme == QMURLPatternType.router.rawValue {
                self.urlType = .router
            } else if URL?.scheme == QMURLPatternType.web.rawValue {
                self.urlType = .web
            } else {
                self.urlType = .openURL
            }
            
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
