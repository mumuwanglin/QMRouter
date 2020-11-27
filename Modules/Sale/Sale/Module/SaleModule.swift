//
//  SaleModule.swift
//  Sale
//
//  Created by mumu on 2020/11/26.
//

import Foundation

final public class SaleModule: SaleModuleService, QMSharedInstanceProtocol {
    
    public static var sharedInstance: SaleModule = SaleModule()
    
    public func setup() {
        QMRouter.bind(kRouteSaleShoppingCart) { (params) -> Any in
            return ShoppingCartViewController()
        }
    }
    
    public func addShoppingCartGoods(goodsId: String) {
        ShoppingCartManager.sharedInstance.addGoods(goodsId: goodsId, num: 1)
    }
    
    public func shoppinCartGoodsNum() -> Int {
        return ShoppingCartManager.sharedInstance.shoppinCartGoodsNum()
    }
    
}
