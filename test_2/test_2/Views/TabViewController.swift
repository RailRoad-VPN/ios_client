//
// Created by beop on 12/15/18.
// Copyright (c) 2018 beop. All rights reserved.
//

import Foundation
import UIKit

class TabViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()




        let mainViewController = MainViewController()
        mainViewController.tabBarItem = UITabBarItem(title: "VPN", image: .none, tag: 0)

        let serversListViewController = ServersListViewController()
        serversListViewController.tabBarItem = UITabBarItem(title: "Servers", image: .none, tag: 1)

        let settingsViewContoller = SettingsListViewController()
        settingsViewContoller.tabBarItem = UITabBarItem(title: "Settings", image: .none, tag: 2)
        let tabBarList = [mainViewController, serversListViewController, settingsViewContoller]

        self.viewControllers = tabBarList
        print("tabbar controller wtf?")
    }
}