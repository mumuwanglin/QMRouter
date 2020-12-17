//
//  UIViewControllerExt.swift
//  QMRouter
//
//  Created by mumu on 2020/12/17.
//

import UIKit

// MARK:  获取当前控制器
public extension UIViewController {
    
    static func getCurrentVC() -> UIViewController? {
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController,
            let currentVC = findCurrentViewController(rootController: rootVC) {
            return currentVC
        } else if let rootVC = UIApplication.shared.windows.first?.rootViewController {
            return findCurrentViewController(rootController: rootVC)
        }
        return nil
    }
    
    private class func findCurrentViewController(rootController: UIViewController?) -> UIViewController? {
        guard let viewController = rootController else {
            return nil
        }
        if let naviVC = viewController as? UINavigationController {
            return self.findCurrentViewController(rootController: naviVC.viewControllers.last)
        } else if let tabVC = viewController as? UITabBarController {
            return self.findCurrentViewController(rootController: tabVC.selectedViewController)
        } else if let presentedVC = viewController.presentedViewController {
            return self.findCurrentViewController(rootController: presentedVC)
        }
        return rootController
    }
    
}
