//
//  GoodsModuleService.swift
//  Mediator
//
//  Created by mumu on 2020/11/25.
//

import Foundation

// 所有商品的路由
public let kRouteAllGoodsList: String = "freereader://goods/all_goods_list"
// 商品详情的路由
public let kRouteGoodsDetail: String = "freereader://goods/detail"
// 跳转商品详情需要传递的参数
public let kRouteGoodsDetailParamId: String = "id"

// 商品类的协议,方便参数的传递
public protocol GoodsProtocol {
    var goodsId: String { get set }
    var name: String { get set }
    var price: Float { get set }
    var inventory: Int { get set }
}

// 商品模块的服务类
public protocol GoodsModuleService: QMModuleProtocol {
    func totalInventory() -> Int
    func popularGoodsList() -> Array<GoodsProtocol>
    func allGoodsList() -> Array<GoodsProtocol>
    func goodsById(goodsId: String) -> GoodsProtocol
}
