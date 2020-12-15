## 七猫iOS组件化架构设计实践

1. 在Mediator中自定义 ModuleService(继承自QMModuleProtocol) 协议
```
// 所有商品的路由
public let kRouteAllGoodsList: String = "qmrouter://goods/all_goods_list"
// 商品详情的路由
public let kRouteGoodsDetail: String = "qmrouter://goods/detail"
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
```
2. 在子模块实现自定义的 ModuleService 协议 和 QMSharedInstanceProtocol 协议
*  实现单例方法
*  设置初始化优先级(可选)
*  设置是否异步初始化(可选)
*  设置 setup 初始化路由(可选)
*  实现自定义协议的方法
```
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
```
3. 注册服务
```
QMRouter.register(GoodsModuleService.self, module: GoodsModule.sharedInstance)
```
4. 获取注册的路由
```
let routeURL = kRouteGoodsDetail
                    
let vc = QMRouter.handle(routeURL, complexParams: [kRouteGoodsDetailParamId: "\(String(describing: goods?.goodsId ?? ""))"]) { (params) in
                
} as! UIViewController
```
5. 获取注册的服务
```
let goodsModule = QMRouter.module(for: GoodsModuleService.self)
// 获取所有的商品
goodsModule?.allGoodsList()
```