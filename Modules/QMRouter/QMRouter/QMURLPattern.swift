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
    var components: Dictionary<String, Any> { get }
}


/// URL解析类
class QMURLAnalysis: QMURLPattern {

    var urlType: QMURLPatternType?
    
    var urlKey: String = ""
    
    var components: Dictionary<String, Any> = Dictionary()
    
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
  
            if let components = URLComponents.init(string: URL?.absoluteString ?? "") {
                let queryParams = extractQueryParams(components: components)
                self.components = convertParamsToJson(queryParams: queryParams, linkUrl: linkUrl, host: components.host, scheme: URL?.scheme) as? Dictionary<String, Any> ?? [:]                
            }
        }
    }
    
    
    /// 提取参数
    func extractQueryParams(components: URLComponents) -> NSMutableDictionary {
        let queryParams = NSMutableDictionary.init()
        if let queryItems = components.queryItems {
            for item in queryItems {
                if item.value == nil {
                    continue
                }
                if (queryParams[item.name] == nil) {
                    queryParams[item.name] = item.value
                } else {
                    let existingValue = queryParams[item.name]
                    queryParams[item.name] = [existingValue, item.value]
                }
            }
        }
        return queryParams
    }

    /// 转换模型
    func convertParamsToJson(queryParams: NSMutableDictionary, linkUrl: String, host: String?, scheme: String?) -> Any? {
        
        if let _ = queryParams.object(forKey: "param" as Any) as? String, let host = host, let scheme = scheme {
            if let tmpUrlString: NSString = linkUrl as NSString? {
                let tmpParamString = "\(scheme)://\(host)?param="
                let paramString = tmpUrlString.substring(from: tmpParamString.count)
                if let data = paramString.removingPercentEncoding?.data(using: .utf8) {
                    do {
                        let parsedJSON = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
                        return parsedJSON
                    } catch let error {
                        assert(false, "parsed \(queryParams) error: \(error)")
                        print("parsed \(queryParams) error: \(error)")
                    }
                }
            }
        }
        
        return [:]
    }
}
