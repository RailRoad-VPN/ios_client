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

    var vpnManager: NEVPNManager?

    var railRoadService: RailRoadService
    var startVPN: UIButton
    var serverList: UIButton
    var settingsList: UIButton

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {

        self.railRoadService = RailRoadService()
        self.serverList = UIButton()
        self.settingsList = UIButton()
        self.startVPN = UIButton()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        print("MainController INIT works!!!")
//todo move everything here


    }

    required init?(coder: NSCoder) {
        self.railRoadService = RailRoadService()
        self.serverList = UIButton()
        self.settingsList = UIButton()
        self.startVPN = UIButton()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//nav
        self.navigationController!.navigationBar.topItem!.title = "RailRoad VPN"
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.isTranslucent = true

//background picture
        self.view.backgroundColor = UIColor.greyRailRoad

        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        imageView.contentMode = UIViewContentMode.scaleToFill
//        imageView.
        imageView.image = UIImage.init(named: "homeBackground")!

        self.view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
//        self.view.backgroundColor = UIColor.init(patternImage: )


        loadButtons()

//        print("INIT")
        DispatchQueue.global(qos: .background).async {
            self.railRoadService.updateRequestVPNServers()
        }
        //self.establishVPN()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadButtons() {
//        let label_1 = UILabel.init(frame: CGRect.init(origin: CGPoint(x: 4, y: 4), size: CGSize(width: 1888, height: 55)))
//        label_1.text = "Dobrii Vecher Ya Dispetcher"
//        var frame = label_1.frame
//        frame.origin.y = 10
//        //pass the Y cordinate
//        frame.origin.x = 12
//        //pass the X cordinate
//        label_1.frame = frame
//        label_1.textColor = UIColor.white
//        self.view.addSubview(label_1)

        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height

// VPN button
//        var frame2 = CGRect.init(x: screenWidth / 2, y: screenHeight / 2, width: 100, height: 100)
        var frame2 = CGRect.init(x: screenWidth / 2 - 50, y: screenHeight / 7, width: 100, height: 100)
        self.startVPN = UIButton(frame: frame2)
//        self.startVPN.setBackgroundImage(UIImage(named: "redSemaphore"), for: UIControlState.normal)
        self.startVPN.setImage(UIImage(named: "redSemaphore"), for: UIControlState.normal)
//        self.startVPN.setBackgroundImage(UIImage(named: "blackSemaphore"), for: UIControlState.highlighted)
        self.startVPN.setImage(UIImage(named: "blackSemaphore"), for: UIControlState.highlighted)
//        self.startVPN.setTitle("Tap me", for: UIControlState.normal)

        self.startVPN.addTarget(self, action: #selector(self.doSomething(_:)), for: .touchUpInside)
        self.view.addSubview(self.startVPN)

// servers_list
        var frame3 = CGRect.init(x: screenWidth / 2 - 75, y: screenHeight - 80, width: 150, height: 50)
        self.serverList = UIButton(frame: frame3)
        self.serverList.layer.cornerRadius = 0.13 * self.serverList.bounds.size.width

        self.serverList.backgroundColor = UIColor.clear
        self.serverList.setTitle("All servers", for: UIControlState.normal)
        self.serverList.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.serverList.layer.borderColor = UIColor.white.cgColor
        self.serverList.layer.borderWidth = 3

        self.serverList.addTarget(self, action: #selector(self.goToServersList(_:)), for: .touchUpInside)
        self.view.addSubview(self.serverList)

// settings
//        var frame4 = CGRect.init(x: screenWidth / 2 + screenWidth / 4, y: screenHeight / 4, width: 100, height: 100)
//        self.settingsList = UIButton(frame: frame4)
//        self.settingsList?.backgroundColor = UIColor.green
//        self.settingsList?.setTitle("settings", for: UIControlState.normal)
//
//        self.settingsList?.addTarget(self, action: #selector(self.goToSettingsList(_:)), for: .touchUpInside)
//        self.view.addSubview(self.settingsList!)

    }

//    func loadTestView() {
//        //todo
//
//        let navSubViews = navigationController!.view.subviews
//        let lastFrame = navSubViews.last!.frame
//        let width = lastFrame.size.width
//        let height = lastFrame.origin.y + lastFrame.size.height
//
//        let testFrame = CGRect.init(x: 0, y: height, width: width, height: 100)
//        let testView = UIView(frame: testFrame)
//        testView.backgroundColor = UIColor.purple
//
//        let testLabel = UILabel(frame: CGRect.init(x: 0, y: height, width: width, height: 50))
//        testLabel.text = "UNDER CONSTRUCTION"
//        testLabel.textColor = UIColor.green
//
//        self.view.addSubview(testView)
//        testView.addSubview(testLabel)
//
//    }


    @objc func doSomething(_ sender: UIButton) {
        print("vpn butt")

        startVPN.isUserInteractionEnabled = false
        startVPN.imageView!.animationImages = [UIImage(named: "blackSemaphore")!, UIImage(named: "yellowSemaphore")!]
        startVPN.imageView!.animationDuration = 1
        startVPN.imageView!.startAnimating()

        if railRoadService.isVpnOn == false {
            DispatchQueue.global(qos: .userInitiated).async {
                self.railRoadService.connectToVPN()
                DispatchQueue.main.sync {
                    self.startVPN.imageView!.stopAnimating()
                    self.startVPN.setImage(UIImage(named: "greenSemaphore"), for: UIControlState.normal)
                    self.startVPN.isUserInteractionEnabled = true

                }
            }

        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                self.railRoadService.disconnectFromVPN()
                DispatchQueue.main.sync {
                    self.startVPN.imageView!.stopAnimating()
                    self.startVPN.setImage(UIImage(named: "redSemaphore"), for: UIControlState.normal)
                    self.startVPN.isUserInteractionEnabled = true
                }
            }
        }
    }

    @objc func goToServersList(_ sender: UIButton) {
          print("serversList")
        let listViewController = ServersListViewController.init()
        self.navigationController?.pushViewController(listViewController, animated: true)
    }

    @objc func goToSettingsList(_ sender: UIButton) {
        print("settingsList")
        let listViewController = SettingsListViewController.init()
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














