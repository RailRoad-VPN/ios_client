//
// Created by beop on 6/10/18.
// Copyright (c) 2018 beop. All rights reserved.
//

import UIKit


class serversListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView = UITableView.init()
    let servers = RailRoadService.init().getVPNServers()

    let animals = ["1", "2", "3"]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: UIScreen.main.bounds, style: UITableViewStyle.plain)
        tableView.delegate      =   self
        tableView.dataSource    =   self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.tableView)

        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Servers"

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return servers!.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        //cell.textLabel!.text = animals [indexPath.row]
        cell.textLabel!.text = servers![indexPath.row]["uuid"] as? String
        cell.detailTextLabel!.text = indexPath.row as? String
        return cell;
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let uuid = servers![indexPath.row]["uuid"] as? String
        let config = RailRoadService.init().getVPNServerConfig(uuid: UUID.init(uuidString: uuid!)!)
        print(config)

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
