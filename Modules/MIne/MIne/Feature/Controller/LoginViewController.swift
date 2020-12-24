//
//  LoginViewController.swift
//  Mine
//
//  Created by mumu on 2020/12/24.
//

import UIKit
@_exported import SnapKit

class LoginViewController: UIViewController {

    private lazy var nameTf: UITextField = {
        let tmp = UITextField()
        tmp.text = "mumu"
        tmp.borderStyle = .roundedRect
        return tmp
    }()
    
    private lazy var passworTf: UITextField = {
        let tmp = UITextField()
        tmp.text = "123456"
        tmp.borderStyle = .roundedRect
        return tmp
    }()
    
    private lazy var loginBtn: UIButton = {
        let tmp = UIButton(type: .custom)
        tmp.backgroundColor = .systemBlue
        tmp.setTitle("Login", for: .normal)
        tmp.setTitleColor(.white, for: .normal)
        tmp.addTarget(self, action: #selector(loginBtnClick), for: .touchUpInside)
        return tmp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Login"
        self.view.backgroundColor = .white
        
        setupView()
        setupLayout()
    }
    
    func setupView() {
        view.addSubview(nameTf)
        view.addSubview(passworTf)
        view.addSubview(loginBtn)
    }
    
    func setupLayout() {
        nameTf.snp.makeConstraints { (make) in
            make.top.equalTo(200)
            make.left.equalTo(50)
            make.right.equalTo(-50)
            make.height.equalTo(50)
        }
        
        passworTf.snp.makeConstraints { (make) in
            make.top.equalTo(nameTf).offset(70)
            make.left.equalTo(50)
            make.right.equalTo(-50)
            make.height.equalTo(50)
        }
        
        loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(passworTf).offset(70)
            make.left.equalTo(50)
            make.right.equalTo(-50)
            make.height.equalTo(50)
        }
    }
    
    @objc private func loginBtnClick() {
        if nameTf.text == "mumu" && passworTf.text == "123456" {
            UserDefaults.standard.set(true, forKey: "loginstate")
            self.navigationController?.popViewController(animated: true)
        } else {
            print("Login Fail")
        }
    }
}
