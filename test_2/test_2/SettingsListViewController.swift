//
// Created by beop on 6/10/18.
// Copyright (c) 2018 beop. All rights reserved.
//

import UIKit


class SettingsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView = UITableView.init()

    let settingsItems = ["Account", "About", "Help"]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: UIScreen.main.bounds, style: UITableViewStyle.grouped)
        tableView.delegate      =   self
        tableView.dataSource    =   self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "settings_cell")
        self.view.addSubview(self.tableView)

        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Settings"

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return settingsItems.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "settings_cell")
        //cell.textLabel!.text = animals [indexPath.row]
        //cell.textLabel!.text = servers![indexPath.row]["uuid"] as? String
        //cell.detailTextLabel!.text = indexPath.row as? String

        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "settings_cell")
        cell.textLabel!.text = settingsItems[indexPath.row]
        return cell;
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print(settingsItems[indexPath.row])
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
