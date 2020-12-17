//
//  HomeModuleService.swift
//  Mediator
//
//  Created by mumu on 2020/11/25.
//

import Foundation
import UIKit

// 首页的路由
public let kRouteHomePage: String = "freereader://home/home_page"

// 首页的服务类
public protocol HomeModuleService: QMModuleProtocol {
    func getHomeViewController() -> UIViewController
}
