//
//  GoodsModuleService.swift
//  Mediator
//
//  Created by mumu on 2020/11/25.
//

import Foundation


public let kRouteAllGoodsList: String = "//goods/all_goods_list"
public let kRouteGoodsDetail: String = "//goods/detail"
public let kRouteGoodsDetailParamId: String = "id"

public protocol GoodsProtocol {
    var goodsId: String { get set }
    var name: String { get set }
    var price: Float { get set }
    var inventory: Int { get set }
}


public protocol GoodsModuleService: QMModuleProtocol {
    func totalInventory() -> Int
    func popularGoodsList() -> Array<GoodsProtocol>
    func allGoodsList() -> Array<GoodsProtocol>
    func goodsById(goodsId: String) -> GoodsProtocol
}
