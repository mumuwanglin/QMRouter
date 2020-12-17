//
//  GoodsModule.swift
//  Goods
//
//  Created by mumu on 2020/11/25.
//

import Foundation

final public class GoodsModule: NSObject, GoodsModuleService,QMSharedInstanceProtocol {
    
    public static var sharedInstance: GoodsModule = GoodsModule()
    
    public func setup() {
        QMRouter.shared.bind(kRouteGoodsDetail) { (params) -> Void in
            let detailVC = GoodsDetailsViewController()
            detailVC.goodsId = params[kRouteGoodsDetailParamId] as? String
            
            // 注册完成后的一些操作
            QMRouter.shared.complete(params, result: "我是成功回调的参数")
            
            UIViewController.getCurrentVC()?.navigationController?.pushViewController(detailVC, animated: true)
        }
        
        QMRouter.shared.bind(kRouteAllGoodsList) { (params) -> Void in
            let vc = GoodsListViewController()
            UIViewController.getCurrentVC()?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    public func totalInventory() ->Int {
        let list = self.allGoodsList()
        var count = 0
        for temp in list {
            count += temp.inventory
        }
        return count
    }
    
    public func popularGoodsList() -> Array<GoodsProtocol> {
        var list = [GoodsProtocol]()
        for i in 0..<10 {
            let goods = GoodsModel()
            goods.goodsId = "\(i)"
            goods.name = "GoodsName_\(i)"
            goods.price = Float(i+1)
            goods.inventory = 66*i
            list.append(goods)
        }
        return list
    }
    
    public func allGoodsList() -> Array<GoodsProtocol> {
        var list = [GoodsProtocol]()
        for i in 0..<20 {
            let goods = GoodsModel()
            goods.goodsId = "\(i)"
            goods.name = "GoodsName_\(i)"
            goods.price = Float(i)
            goods.inventory = 66*i
            list.append(goods)
        }
        return list
    }
    
    public func goodsById(goodsId: String) -> GoodsProtocol {
        let goods = GoodsModel()
        goods.goodsId = goodsId
        goods.name = "GoodsName_\(goodsId)"
        goods.price = Float(goodsId) ?? 0.0
        goods.inventory = 66
        return goods
    }
    
    
}

extension GoodsModule: QMApplicationLifeCycle {
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        print("didFinishLaunchingWithOptions launchOptions")
        
        return true
    }
}
