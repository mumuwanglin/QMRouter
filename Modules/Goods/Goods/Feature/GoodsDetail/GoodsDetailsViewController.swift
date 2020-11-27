//
//  GoodsDetailsViewController.swift
//  Goods
//
//  Created by mumu on 2020/11/26.
//

import UIKit

public class GoodsDetailsViewController: UIViewController {

    public let saleModule = QMRouter.module(for: "\(SaleModuleService.self)") as? SaleModuleService
    
    public var goodsId: String?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Goods Detail"
        self.navigationItem.backBarButtonItem?.title = ""
        let goods = GoodsModule.sharedInstance.goodsById(goodsId: goodsId ?? "")
        self.title = goods.name
        self.view.backgroundColor = .white
        setupUI()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateShoppingCartBarButtonItem()
    }
    
    func setupUI() {
        let btn = UIButton(type: .roundedRect)
        btn.setTitle("加入购物车", for: .normal)
        btn.frame = CGRect(x: 100, y: 400, width: self.view.frame.size.width - 200, height: 100)
        btn.addTarget(self, action: #selector(addToShoppingCart), for: .touchUpInside)
        view.addSubview(btn)
        
    }
    
    func updateShoppingCartBarButtonItem() {
        if let saleModule = saleModule {
            let title = "购物车(\(saleModule.shoppinCartGoodsNum()))"
            
            let item = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(goToShoppingCart))
            self.navigationItem.rightBarButtonItem = item
        }        
    }
    
    @objc func addToShoppingCart() {
        saleModule?.addShoppingCartGoods(goodsId: goodsId ?? "")
        updateShoppingCartBarButtonItem()
    }
    
    @objc func goToShoppingCart() {
        let shopingCartVC = QMRouter.handle(kRouteSaleShoppingCart) as! UIViewController
        self.navigationController?.pushViewController(shopingCartVC, animated: true)
    }
}
