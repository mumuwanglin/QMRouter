## 七猫iOS组件化架构设计实践

一、Service 和 Module 的注册（负责跨模块数据交互）

1. 定义夸模块数据交互的协议

在Mediator中定义 ModuleService(继承自QMModuleProtocol) 协议

* 定义路由名称
* 定义此协议需要暴露出的方法

```
// 所有商品的路由
public let kRouteAllGoodsList: String = "freereader://goods/all_goods_list"
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

2. 在 Module 实现定义的 ModuleService 协议 和 QMSharedInstanceProtocol 协议

* 实现单例方法
* 设置初始化优先级(可选)
* 设置是否异步初始化(可选)
* 设置 setup 初始化路由(可选)
* 实现自定义协议的方法

```
final public class GoodsModule: GoodsModuleService,QMSharedInstanceProtocol {
  
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
        ```
    }
  
    public func popularGoodsList() -> Array<GoodsProtocol> {
        ```
    }
  
    public func allGoodsList() -> Array<GoodsProtocol> {
        ```
    }

    public func goodsById(goodsId: String) -> GoodsProtocol {
        ```
    }


}
```

3. 注册服务

```
QMRouter.register(GoodsModuleService.self, module: GoodsModule.sharedInstance)
```

4. 获取服务

```
let goodsModule = QMRouter.module(for: GoodsModuleService.self)
// 获取所有的商品
goodsModule?.allGoodsList()
```

二、路由的注册于获取（负责路由的跳转）

1. 获取注册的路由

在定义的Module 的 setup 方法

```
final public class GoodsModule: GoodsModuleService,QMSharedInstanceProtocol {
  
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
}
```

2. 获取注册的服务

```
let routeURL = kRouteGoodsDetail

let vc = QMRouter.handle(routeURL, complexParams: [kRouteGoodsDetailParamId: "\(String(describing: goods?.goodsId ?? ""))"]) { (params) in

}
```
