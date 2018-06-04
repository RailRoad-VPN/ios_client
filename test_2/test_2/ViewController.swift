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


        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height

        var frame2 = CGRect.init(x: screenWidth/2, y: screenHeight/2, width: 50, height: 50)
        self.startVPN = UIButton(frame: frame2)
        self.startVPN?.backgroundColor = UIColor.brown
        self.startVPN?.setTitle("Tap me", for: UIControlState.normal)

        self.startVPN?.addTarget(self, action: #selector(ViewController.doSomething(_:)), for: .touchUpInside)
        self.view.addSubview(self.startVPN!)
    }

    @objc func doSomething(_ sender: UIButton){
      let fff = RailRoadService.init()
        fff.getVPNServers()
      print("SHITSHISTHSI")
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
//
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














