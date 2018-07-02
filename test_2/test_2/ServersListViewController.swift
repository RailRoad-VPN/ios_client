//
// Created by beop on 6/10/18.
// Copyright (c) 2018 beop. All rights reserved.
//

import UIKit


class ServersListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView
    var refreshControl: UIRefreshControl
    var railRoadService: RailRoadService
    var servers: [[String: Any]]?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {

        self.tableView = UITableView()

        self.railRoadService = RailRoadService()
        self.servers = self.railRoadService.readDictArray(fromFile: FilesEnum.vpnServers.rawValue)
        self.refreshControl = UIRefreshControl()

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        print("ServesrsList INIT works!!!")


    }


    required init?(coder: NSCoder) {
        self.tableView = UITableView()
        self.railRoadService = RailRoadService()
        self.refreshControl = UIRefreshControl()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: UIScreen.main.bounds, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ServersListTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 50

        self.tableView.backgroundColor = UIColor.greyRailRoad
        self.view.addSubview(self.tableView)
        self.refreshControl.addTarget(self, action: #selector(self.refreshServerList(_:)), for: UIControlEvents.valueChanged)
        self.tableView.insertSubview(self.refreshControl, aboveSubview: self.tableView)

        //self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Servers"


        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshServerList(_:)), name: .refreshTableView, object: nil)


    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return servers!.count

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ServersListTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        //cell.textLabel!.text = animals [indexPath.row]
//debug
        //cell.textLabel!.text = servers![indexPath.row]["uuid"] as? String
        //cell.detailTextLabel!.text = indexPath.row as? String

        let serverRow = servers![indexPath.row] as? [String: Any]
        let load = String(serverRow!["load"] as! Int)
        let geo = serverRow!["geo"] as? [String: Any]
        let num = serverRow!["num"] as! Int
        //todo country, city:
        let country = String(geo!["country_code"] as! Int)
        let city = String(geo!["city_id"] as! Int)
        cell.locationAndLoad.text = country + ", " + city + " / Load: " + load + "%"
        cell.serverName.text = "Server #" + String(num)
        cell.backgroundColor = UIColor.greyRailRoad
//        let expl = UIImageView.init(frame: CGRect.init(x: 10, y: 10, width: 50, height: 50))
//        expl.image = UIImage.init(named: "image936")
//        cell.contentView.addSubview(expl)
        return cell;
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let uuid = servers![indexPath.row]["uuid"] as? String
        let config = RailRoadService.init().getVPNServerConfig(uuid: UUID.init(uuidString: uuid!)!)
        print(config)

    }

    @objc func refreshServerList(_ sender: Any) {
        print("NOTIFICATION WORKS!!!!!!!!")
        var t = 0
        DispatchQueue.global(qos: .background).async {
            self.railRoadService.updateRequestVPNServers(once: true)
            self.servers = self.railRoadService.readDictArray(fromFile: FilesEnum.vpnServers.rawValue)

            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()

            }
        }
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //self.navigationController?.navigationBar.isHidden = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("user stopped dragging")

    }

}
