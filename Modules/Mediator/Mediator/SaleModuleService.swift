//
//  SaleModuleService.swift
//  Mediator
//
//  Created by mumu on 2020/11/26.
//

import Foundation

public let kRouteSaleShoppingCart: String = "qmrouter://sale/shopping_chart"

public protocol SaleModuleService: QMModuleProtocol {
    func addShoppingCartGoods(goodsId: String)
    func shoppinCartGoodsNum() -> Int
}
