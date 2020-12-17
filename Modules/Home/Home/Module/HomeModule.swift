//
//  HomeModule.swift
//  Home
//
//  Created by mumu on 2020/11/25.
//

import Foundation
import UIKit
import QMRouter

public let whiteList: [String] = ["https://www.baidu.com", "freereader://www.weibo.com", "https://www.souhu.com"]

final public class HomeModule: NSObject, HomeModuleService, QMSharedInstanceProtocol {
    
    public static var sharedInstance: HomeModule = HomeModule()
    
    // 注册Module的优先级
    public var priority: Int = 101
    
    // 是否异步注册Module
    public var setupModuleSynchronously: Bool { return false }
        
    
    public func setup() {
        QMRouter.shared.bind(kRouteHomePage) { (params) -> Void in
            let vc = HomeViewController()
            UIViewController.getCurrentVC()?.navigationController?.pushViewController(vc, animated: true)
        }
        
        whiteList.filter({ (whiteUrl) -> Bool in
            let urlAnalysis = QMURLAnalysis(whiteUrl)
            return urlAnalysis.urlScheme != "freereader"
        }).forEach { (whiteUrl) in
            QMRouter.shared.bind(whiteUrl) { (params) -> Void in
                UIApplication.shared.open(URL(string: whiteUrl)!, options: [:], completionHandler: { (flag) in
                    
                })
            }
        }
    }
    
    public func getHomeViewController() -> UIViewController {
        return HomeViewController()
    }
}

extension HomeModule: QMApplicationLifeCycle {
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        print("didFinishLaunchingWithOptions launchOptions")
        
        return true
    }
    
    public func applicationWillTerminate(_ application: UIApplication) {
        print("applicationWillTerminate")
    }
}
