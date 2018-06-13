//
//  ViewController.swift
//  test_2
//
//  Created by beop on 5/4/18.
//  Copyright © 2018 beop. All rights reserved.
//

import UIKit
import NetworkExtension


class ViewController: UIViewController {

    var window: UIWindow?
    var vpnManager: NEVPNManager?

    var rr: RailRoadService?
    var startVPN: UIButton?
    var serverList: UIButton?
    var settingsList: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blue

        self.loadInterface()
        //self.establishVPN()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadInterface() {
        let label_1 = UILabel.init(frame: CGRect.init(origin: CGPoint(x: 4, y: 4), size: CGSize(width: 1888, height: 55)))
        label_1.text = "Dobrii Vecher Ya Dispetcher"
        var frame = label_1.frame
        frame.origin.y = 10
        //pass the Y cordinate
        frame.origin.x = 12
        //pass the X cordinate
        label_1.frame = frame
        label_1.textColor = UIColor.white
        self.view.addSubview(label_1)

// VPN button
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height

        var frame2 = CGRect.init(x: screenWidth/2, y: screenHeight/2, width: 50, height: 50)
        self.startVPN = UIButton(frame: frame2)
        self.startVPN?.backgroundColor = UIColor.brown
        self.startVPN?.setTitle("Tap me", for: UIControlState.normal)

        self.startVPN?.addTarget(self, action: #selector(ViewController.doSomething(_:)), for: .touchUpInside)
        self.view.addSubview(self.startVPN!)

// servers_list
        var frame3 = CGRect.init(x: screenWidth/4, y: screenHeight/4, width: 100, height: 100)
        self.serverList = UIButton(frame: frame3)
        self.serverList?.backgroundColor = UIColor.red
        self.serverList?.setTitle("list", for: UIControlState.normal)

        self.serverList?.addTarget(self, action: #selector(ViewController.goToServersList(_:)), for: .touchUpInside)
        self.view.addSubview(self.serverList!)

// settings
        var frame4 = CGRect.init(x: screenWidth/2 + screenWidth/4, y: screenHeight/4, width: 100, height: 100)
        self.settingsList = UIButton(frame: frame4)
        self.settingsList?.backgroundColor = UIColor.green
        self.settingsList?.setTitle("settings", for: UIControlState.normal)

        self.settingsList?.addTarget(self, action: #selector(ViewController.goToSettingsList(_:)), for: .touchUpInside)
        self.view.addSubview(self.settingsList!)

//nav
       self.navigationController?.navigationBar.isHidden = true
    }

    @objc func doSomething(_ sender: UIButton){
      let fff = RailRoadService.init()
      fff.getVPNServers()
      fff.getMeta()
      //fff.getVPNServers(uuid: UUID.init(uuidString: "c872e7f0-76d6-4a4e-826e-c56a7c05958a")!)
      //fff.getVPNServers(status_id: 1)
      //fff.getVPNServers(type_id: 2)
      //fff.getVPNServersConditions(status_id: 1)
      //fff.getVPNServersConditions(type_id: 2)
      //fff.getVPNServersConditions(uuid: UUID.init(uuidString: "c872e7f0-76d6-4a4e-826e-c56a7c05958a")!)
      //fff.getVPNServersConditions()
        fff.getVPNServerConfig(uuid: UUID.init(uuidString: "c872e7f0-76d6-4a4e-826e-c56a7c05958a")!)
      print("vpn butt")
    }

    @objc func goToServersList (_ sender: UIButton){
        print("serversList")
        let listViewController = serversListViewController.init()
        self.navigationController?.pushViewController(listViewController, animated: true)
    }

    @objc func goToSettingsList (_ sender: UIButton){
        print("settingsList")
        let listViewController = settingsListViewController.init()
        self.navigationController?.pushViewController(listViewController, animated: true)
    }

//    private var vpnSaveHandler: (Error?) -> Void { return
//    { (error:Error?) in
//        if (error != nil) {
//            print("Could not save VPN Configurations")
//            return
//        } else {
//            do {
//                try self.vpnManager?.connection.startVPNTunnel()
//            } catch let error {
//                print("Error starting VPN Connection \(error.localizedDescription)");
//            }
//        }
//        }
//80Pmkmjubgyfrvfgb
//    }

//    func establishVPN() {
//        self.vpnManager = NEVPNManager.shared()
//        let prot = NEVPNProtocolIKEv2.init()
//        prot.serverAddress = "194.87.235.49"
//        prot.username = "user2"
//        prot.authenticationMethod = NEVPNIKEAuthenticationMethod.sharedSecret
//        prot.localIdentifier = "12345"
//        prot
////        let kcs = KeychainService()
////        kcs.save(key: "SHARED", value: "MY_SHARED_KEY")
////        kcs.save(key: "VPN_PASSWORD", value: "MY_PASSWORD"
////            p.sharedSecretReference = kcs.load(key: "SHARED")
////            p.passwordReference = kcs.load(key: "VPN_PASSWORD)
//        prot.useExtendedAuthentication = true
//        prot.disconnectOnSleep = false
//        self.vpnManager?.protocolConfiguration = prot
//        self.vpnManager?.localizedDescription = "Contensi"
//        self.vpnManager?.isEnabled = true
//
//        self.vpnManager?.loadFromPreferences(completionHandler: { (error) -> Void in
//            if let _ = error {
//                print("load Error: ", error)
//            }
//            do {
//                try NEVPNManager.shared().connection.startVPNTunnel()
//            } catch {
//                print("Fire Up Error: ", error)
//            }
//        })
//        self.vpnManager?.saveToPreferences(completionHandler: { (error) -> Void in
//            if let _ = error {
//                print("Save Error: ", error)
//            }
//            do {
//                try NEVPNManager.shared().connection.startVPNTunnel()
//            } catch {
//                print("Fire Up Error: ", error)
//            }
//        })
//
//        //self.vpnManager?.connection.startVPNTunnel()
////            self.vpnManager?.saveToPreferences()
////        let error = NSError()
////        self.vpnManager?.loadFromPreferences(completionHandler: self.vpnSaveHandler)
////        do {
////            try self.vpnManager?.connection.startVPNTunnel()
////        } catch let error {
////            print("Error starting VPN Connection")
////        }
//
//
//    }

}














