//
//  QMURLPattern.swift
//  QMRouter
//
//  Created by mumu on 2020/11/18.
//  URL 解析类，解析 host、path、params

import Foundation

/// URL 匹配信息存储类的协议
public protocol QMURLPattern {
    
    /// 存储到路由的key
    var urlKey: String { get }
    
    /// 解析出的 scheme
    var urlScheme: String { get }
    
    /// 组成
    var components: Dictionary<String, Any> { get }
}


/// URL解析类
public class QMURLAnalysis: QMURLPattern {
    
    public var urlKey: String = ""
    
    public var urlScheme: String = ""
    
    public var components: Dictionary<String, Any> = Dictionary()
    
    public init(_ linkUrl: String) {
        if !linkUrl.isEmpty, let urlString = linkUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            
            let URL = NSURL(string: urlString)
            
            self.urlScheme = URL?.scheme ?? ""
            
            self.urlKey = "//\( URL?.host ?? "")\(URL?.path ?? "")"
  
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
                        assertionFailure("parsed \(queryParams) error: \(error)")
                        print("parsed \(queryParams) error: \(error)")
                    }
                }
            }
        }
        
        return [:]
    }
}
