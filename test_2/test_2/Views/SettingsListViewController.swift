//
// Created by beop on 6/10/18.
// Copyright (c) 2018 beop. All rights reserved.
//

import UIKit


class SettingsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView = UITableView.init()

    let settingsItems = ["Profile", "Support", "FAQ", "Log out"]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: UIScreen.main.bounds, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "settings_cell")
        tableView.backgroundColor = UIColor.greyRailRoad
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.tableHeaderView = UIView(frame: .zero)
        self.view.addSubview(self.tableView)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem!.title = "Settings"
        self.navigationController?.navigationBar.backgroundColor = UIColor.greyRailRoad
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsItems.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "settings_cell")
        cell.textLabel!.text = settingsItems[indexPath.row]
        cell.textLabel!.textColor = UIColor.white
        cell.backgroundColor = UIColor.greyRailRoad
        return cell;
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print_f(#file, #function, settingsItems[indexPath.row])
        if indexPath.row == 0 {
            guard let url = URL(string: "https://rroadvpn.net/en/profile") else {
                return
            }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else if indexPath.row == 3 {
            let us = UserAPIService()
            let vpns = VPNService()
            do {
                try vpns.disconnect()
                try us.deleteUserDevice()
                try CacheMetaService.shared.clearSettings()
                self.navigationController!.setViewControllers([PinViewController()], animated: true)
            } catch {

            }
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
