//
//  GoodsModule.swift
//  Goods
//
//  Created by mumu on 2020/11/25.
//

import Foundation

final public class GoodsModule: GoodsModuleService,QMSharedInstanceProtocol {
    
    public static var sharedInstance: GoodsModule = GoodsModule()
    
    public func setup() {
        QMRouter.bind(kRouteGoodsDetail) { (params) -> Any in
            let detailVC = GoodsDetailsViewController()
            detailVC.goodsId = params[kRouteGoodsDetailParamId] as? String
            
            // 注册完成后的一些操作
            QMRouter.complete(params, result: "1")
            
            return detailVC
        }
        
        QMRouter.bind(kRouteAllGoodsList) { (params) -> Any in
            return GoodsListViewController()
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
