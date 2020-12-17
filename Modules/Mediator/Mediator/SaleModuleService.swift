//
//  SaleModuleService.swift
//  Mediator
//
//  Created by mumu on 2020/11/26.
//

import Foundation

// 购物车的路由
public let kRouteSaleShoppingCart: String = "freereader://sale/shopping_chart"

// 购物车模块的服务类
public protocol SaleModuleService: QMModuleProtocol {
    func addShoppingCartGoods(goodsId: String)
    func shoppinCartGoodsNum() -> Int
}
