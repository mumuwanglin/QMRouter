//
//  HomeViewController.swift
//  Home
//
//  Created by mumu on 2020/11/25.
//

import UIKit

class HomeViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let tmp = UITableView()
        tmp.delegate = self
        tmp.dataSource = self
        return tmp
    }()
    
    let goodsModule = QMRouter.module(for: "\(GoodsModuleService.self)") as? GoodsModuleService
    let saleModule = QMRouter.module(for: "\(SaleModuleService.self)") as? SaleModuleService
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "App"
        self.view.backgroundColor = .black
        self.navigationItem.backBarButtonItem?.title = ""
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

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return goodsModule?.popularGoodsList().count ?? 0
        } else if section == 1 {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        
        if indexPath.section == 0 {
            let goods = goodsModule?.popularGoodsList()[indexPath.row]
            cell?.textLabel?.text = "\(goods?.name ?? ""): $\(goods?.price ?? 0)"
        } else if indexPath.section == 1 {
            cell?.textLabel?.text = "All Goods List"
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let goods = goodsModule?.popularGoodsList()[indexPath.row]
            let routeURL = "\(kRouteGoodsDetail)?\(kRouteGoodsDetailParamId)=\(String(describing: goods?.goodsId ?? ""))"
                    
            let vc = QMRouter.handle(routeURL, complexParams: ["key":"value"]) { (params) in
                
            } as! UIViewController
            
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == 1 {
            let vc = QMRouter.handle(kRouteAllGoodsList) as! UIViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }        
    }
}
