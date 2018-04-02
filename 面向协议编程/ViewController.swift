//
//  ViewController.swift
//  面向协议编程
//
//  Created by tanxiaokang on 2018/4/214.
//  Copyright © 2018年 runze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let request = UserRequest(name: "onevcat")
//        request.send { user in
//            if let user = user {
//                print("\(user.message) from \(user.name)")
//            }
//        }
        
        URLSessionClient().send(UserRequest(name: "onevcat")) { user in
            if let user = user {
                print("\(user.message) from \(user.name)")
            }
        }
        LocalFileClient().send(UserRequest(name: "onevcat")) { user in
            print(user?.name ?? "")
        }
    }
}

