//
// Created by beop on 6/10/18.
// Copyright (c) 2018 beop. All rights reserved.
//

import UIKit


class serversListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView = UITableView.init()
    let servers = NSKeyedUnarchiver.unarchiveObject(withFile:
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("vpnServers.dict2").path
    ) as? [[String: Any]]

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: UIScreen.main.bounds, style: UITableViewStyle.plain)
        tableView.delegate      =   self
        tableView.dataSource    =   self
        tableView.register(ServersListTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 50
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
        let cell = ServersListTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        //cell.textLabel!.text = animals [indexPath.row]
//debug
        //cell.textLabel!.text = servers![indexPath.row]["uuid"] as? String
        //cell.detailTextLabel!.text = indexPath.row as? String
          cell.serverName.text = "Server #" + String(indexPath.row)
        let serverRow = servers![indexPath.row] as? [String: Any]
        let load = String(serverRow!["load"] as! Int)
        let geo = serverRow!["geo"] as? [String: Any]
        //todo country, city:
        let country = String(geo!["country_code"] as! Int)
        let city = String(geo!["city_id"] as! Int)
        cell.locationAndLoad.text = country + ", " + city + " / Load: " + load + "%"

//        let expl = UIImageView.init(frame: CGRect.init(x: 10, y: 10, width: 50, height: 50))
//        expl.image = UIImage.init(named: "image936")
//        cell.contentView.addSubview(expl)
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
