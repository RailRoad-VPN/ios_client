//
// Created by beop on 6/10/18.
// Copyright (c) 2018 beop. All rights reserved.
//

import UIKit


class ServersListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView
    var refreshControl: UIRefreshControl
    var servers: [Server]?
    let us = UserAPIService.shared

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {

        self.tableView = UITableView()

        self.servers = CacheMetaService.shared.readAny(fromFile: FilesEnum.vpnServers.rawValue) as? [Server]
        self.refreshControl = UIRefreshControl()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        print_f(#file, #function, "ServesrsList INIT works!!!")


    }


    required init?(coder: NSCoder) {
        self.tableView = UITableView()
        self.refreshControl = UIRefreshControl()
        self.servers = CacheMetaService.shared.readAny(fromFile: FilesEnum.vpnServers.rawValue) as? [Server]
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: UIScreen.main.bounds, style: UITableViewStyle.plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ServersListTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 50
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.tableHeaderView = UIView(frame: .zero)
        tableView.backgroundColor = UIColor.greyRailRoad

        self.view.addSubview(self.tableView)
        self.refreshControl.addTarget(self, action: #selector(self.refreshServerList(_:)), for: UIControlEvents.valueChanged)
        self.tableView.insertSubview(self.refreshControl, aboveSubview: self.tableView)

        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshServerList(_:)), name: .refreshTableView, object: nil)
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
//    {
//        return 70
//    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationItem.title = ""
        self.navigationController?.navigationBar.topItem!.title = NSLocalizedString("servers", comment: "Servers")
        self.navigationController?.navigationBar.backgroundColor = UIColor.greyRailRoad
        if self.servers == nil {
            self.loadServerList()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (servers?.count) ?? 0

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ServersListTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        let serverRow = servers![indexPath.row] as Server

        print_f(#file, #function, "printing server rows")
        print_f(#file, #function, serverRow.condition_version)
        print_f(#file, #function, serverRow.country_code)
        print_f(#file, #function, serverRow.uuid)
        print_f(#file, #function, serverRow.bandwidth)
        let load = String(serverRow.load ?? 0)
        let num = String(serverRow.num ?? 0)
        let country = String(serverRow.country_str_code ?? "hidden country")
        let city = String(serverRow.city_name ?? "hidden city")
        let loadLabel = NSLocalizedString("load", comment: "Load")

        cell.locationAndLoad.text = country + ", " + city + " / " + loadLabel + ": " + load + "%"
        cell.serverName.text = NSLocalizedString("server_number", comment: "Server #") + num
        cell.backgroundColor = UIColor.greyRailRoad
        return cell;
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let uuid = servers![indexPath.row].uuid
        print_f(#file, #function, uuid)

    }

    @objc func refreshServerList(_ sender: Any) {
        print_f(#file, #function, "notification refreshServerList enter")
        loadServerList()
        print_f(#file, #function, "notification refreshServerList exit")

    }

    func loadServerList() {
        print_f(#file, #function, "loadServerList() enter")
        DispatchQueue.global(qos: .userInitiated).async {

            self.servers = CacheMetaService.shared.readAny(fromFile: FilesEnum.vpnServers.rawValue) as? [Server]

            if self.servers == nil {
                print_f(#file, #function, "!!!!!!!!!!servers are null!!!!!!!!!!!")
                CacheMetaService.shared.backgroundUpdateCheckGlobalMeta(once: true)
            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                print_f(#file, #function, "loadServerList() exit")

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
        print_f(#file, #function, "user stopped dragging")

    }

}
