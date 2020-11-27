//
//  ShoppingCartManager.swift
//  Sale
//
//  Created by mumu on 2020/11/26.
//

import Foundation

class ShoppingCartItem {
    var goodsId: String
    var num: Int
    
    init(goodsId: String, num: Int) {
        self.goodsId = goodsId
        self.num = num
    }
}

class ShoppingCartManager {
    public static let sharedInstance: ShoppingCartManager = ShoppingCartManager()
    
    public var cartItemDict = [String: ShoppingCartItem]()
    
    func addGoods(goodsId: String, num: Int) {
        var item = cartItemDict[goodsId]
        if item == nil {
            item = ShoppingCartItem(goodsId: goodsId, num: 1)
            cartItemDict[goodsId] = item
        }else {
            item?.num += num
        }
    }
    
    func shoppinCartGoodsNum() -> Int {
        var sum = 0
        for temp in cartItemDict.values {
            sum += temp.num
        }
        return sum
    }
}
