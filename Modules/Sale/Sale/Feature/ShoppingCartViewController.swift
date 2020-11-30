//
//  ShoppingCartViewController.swift
//  Sale
//
//  Created by mumu on 2020/11/26.
//

import UIKit

class ShoppingCartViewController: UIViewController {

    let shopingCartManager = ShoppingCartManager.sharedInstance
    let goodsModule = QMRouter.module(for: GoodsModuleService.self)
    
    private lazy var tableView: UITableView = {
        let tmp = UITableView()
        tmp.delegate = self
        tmp.dataSource = self
        return tmp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "购物车"
        self.view.backgroundColor = .white
        setupView()
    }

    
    func setupView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension ShoppingCartViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let goodsList = [ShoppingCartItem](shopingCartManager.cartItemDict.values)
        if section == 0 {
            return goodsList.count
        } else {
            return 1
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
        
        let itemList = [ShoppingCartItem](shopingCartManager.cartItemDict.values)
        
        
        if indexPath.section == 0 {
            let item = itemList[indexPath.row]
            
            let goods = goodsModule?.goodsById(goodsId: item.goodsId)

            cell?.textLabel?.text = "\(goods?.name ?? ""): $\(goods?.price ?? 0.0) X \(item.num)"

        } else {
            var totalPrice: Float = 0
            for item in itemList {
                let goods = goodsModule?.goodsById(goodsId: item.goodsId)
                totalPrice += (goods?.price ?? 0.0) * Float(item.num)
            }
            
            cell?.textLabel?.text = "总价格:\(totalPrice)"
        }

        return cell!
    }
}
