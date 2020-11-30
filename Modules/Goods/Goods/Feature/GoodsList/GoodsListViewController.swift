//
//  GoodsListViewController.swift
//  Goods
//
//  Created by mumu on 2020/11/27.
//

import UIKit

class GoodsListViewController: UIViewController {

    let goodsModule = QMRouter.module(for: GoodsModuleService.self)
    let saleModule = QMRouter.module(for: SaleModuleService.self)
    
    private lazy var tableView: UITableView = {
        let tmp = UITableView()
        tmp.delegate = self
        tmp.dataSource = self
        return tmp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "All Goods List"
        self.view.backgroundColor = .black
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateShoppingCartBarButtonItem()
    }

    func setupView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func updateShoppingCartBarButtonItem() {
        if let saleModule = saleModule {
            let title = "购物车(\(saleModule.shoppinCartGoodsNum()))"
            
            let item = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(goToShoppingCart))
            self.navigationItem.rightBarButtonItem = item
        }
    }

    @objc func goToShoppingCart() {
        let shopingCartVC = QMRouter.handle(kRouteSaleShoppingCart) as! UIViewController
        self.navigationController?.pushViewController(shopingCartVC, animated: true)
    }
}

extension GoodsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goodsModule?.allGoodsList().count ?? 0
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        let goods = goodsModule?.allGoodsList()[indexPath.row]
        cell?.textLabel?.text = "\(goods?.name ?? ""): $\(goods?.price ?? 0)"
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let goods = goodsModule?.popularGoodsList()[indexPath.row]
        let routeURL = "\(kRouteGoodsDetail)?\(kRouteGoodsDetailParamId)=\(String(describing: goods?.goodsId ?? ""))"
                
        let vc = QMRouter.handle(routeURL, complexParams: ["key":"value"]) { (params) in
            
        } as! UIViewController
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
