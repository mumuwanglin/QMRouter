//
//  MineModule.swift
//  Mine
//
//  Created by mumu on 2020/12/24.
//

import Foundation

final public class MineModule: NSObject, MineModuleService, QMSharedInstanceProtocol {
    
    public static var sharedInstance: MineModule = MineModule()
    
    public func setup() {
        QMRouter.shared.bind(kRouteMineLogin) { (params) -> Void in
            let vc = LoginViewController()
            UIViewController.getCurrentVC()?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
