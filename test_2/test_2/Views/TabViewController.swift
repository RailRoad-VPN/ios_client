//
// Created by beop on 12/15/18.
// Copyright (c) 2018 beop. All rights reserved.
//

import Foundation
import UIKit

class TabViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.blue], for: .selected)

        let mainViewController = MainViewController()
        let vpnTab = UIImage(named: "VPNTab")!
        mainViewController.tabBarItem = UITabBarItem(title: "VPN", image: vpnTab.withRenderingMode(.alwaysOriginal),
                selectedImage: vpnTab
        )

        let serversListViewController = ServersListViewController()
        let serverListTab = UIImage(named: "serversListTab")!
        serversListViewController.tabBarItem = UITabBarItem(title: "Servers", image: serverListTab.withRenderingMode(.alwaysOriginal),
                selectedImage: serverListTab
        )

        let settingsViewController = SettingsListViewController()
        let settingsTab = UIImage(named: "settingsTab")!
        settingsViewController.tabBarItem = UITabBarItem(title: "Settings", image: settingsTab.withRenderingMode(.alwaysOriginal),
                selectedImage: settingsTab
        )
        let tabBarList = [mainViewController, serversListViewController, settingsViewController]

        self.tabBar.barTintColor = UIColor.black
        self.viewControllers = tabBarList
        print_f(#file, #function, "tabbar controller wtf?")
    }
}