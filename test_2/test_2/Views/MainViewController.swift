//
//  ViewController.swift
//  test_2
//
//  Created by beop on 5/4/18.
//  Copyright © 2018 beop. All rights reserved.
//

import UIKit
import NetworkExtension

class MainViewController: UIViewController {

    var isWorkerInProgress: Bool = false

    var userAPIService: UserAPIService
    var vpnService: VPNService
    var startStopVPN: UIButton
    var serverList: UIButton
    var hintCommentLabel: UILabel

    let group = DispatchGroup()
    let mySerialQueue = DispatchQueue(label: "ViewController", qos: .userInitiated)

    var connnectWorkItem: DispatchWorkItem?
    var disconnectWorkItem: DispatchWorkItem?


    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        print("MainController INIT works!!!")

        self.userAPIService = UserAPIService()
        self.vpnService = VPNService()
        self.serverList = UIButton()
        self.startStopVPN = UIButton()
        self.hintCommentLabel = UILabel()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)


    }

    required init?(coder: NSCoder) {
        self.userAPIService = UserAPIService()
        self.vpnService = VPNService()
        self.serverList = UIButton()
        self.startStopVPN = UIButton()
        self.hintCommentLabel = UILabel()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//background picture
        self.view.backgroundColor = UIColor.greyRailRoad
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        imageView.contentMode = UIViewContentMode.scaleToFill
        imageView.image = UIImage.init(named: "homeBackground")!

        self.view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)

        self.loadButtons()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.topItem!.title = "RailRoad VPN"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func loadButtons() {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height

// VPN button
        let frame2 = CGRect.init(x: screenWidth / 2 - 68, y: screenHeight / 3, width: 136, height: 93)
        self.startStopVPN = UIButton(frame: frame2)
        self.startStopVPN.setImage(UIImage(named: "redSemaphore"), for: UIControlState.normal)
        self.startStopVPN.setImage(UIImage(named: "blackSemaphore"), for: UIControlState.highlighted)

        self.startStopVPN.addTarget(self, action: #selector(self.connectToVPN(_:)), for: .touchUpInside)
        self.view.addSubview(self.startStopVPN)

// Hint arrow
        let hintArrowFrame = CGRect.init(x: screenWidth / 5, y: screenHeight / 2, width: 40, height: 72)

        let hintImageView = UIImageView.init(frame: hintArrowFrame)
        hintImageView.image = UIImage.init(named: "hintArrow")

        self.view.addSubview(hintImageView)

// Hint label
        let hintCommentFrame = CGRect.init(x: screenWidth / 2 - 68, y: screenHeight / 2 + 72, width: 200, height: 30)
        self.hintCommentLabel = UILabel(frame: hintCommentFrame)

        let hintComment = NSMutableAttributedString(string: "Press red semaphore to connect", attributes:
        [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Light", size: 10)!]
        )
        hintComment.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: hintComment.length))
        hintComment.addAttribute(.foregroundColor, value: UIColor.red, range: NSRange(location: 6, length: 3))
        // set label Attribute
        hintCommentLabel.attributedText = hintComment
        self.view.addSubview(hintCommentLabel)

// servers_list
        let frame3 = CGRect.init(x: screenWidth / 2 - 75, y: screenHeight - 80, width: 150, height: 50)
        self.serverList = UIButton(frame: frame3)
        self.serverList.layer.cornerRadius = 0.13 * self.serverList.bounds.size.width

        self.serverList.backgroundColor = UIColor.clear
        self.serverList.setTitle("TEST API", for: UIControlState.normal)
        self.serverList.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.serverList.layer.borderColor = UIColor.white.cgColor
        self.serverList.layer.borderWidth = 3

        self.serverList.addTarget(self, action: #selector(self.testAPI(_:)), for: .touchUpInside)
        self.view.addSubview(self.serverList)
    }

    @objc func connectToVPN(_ sender: UIButton) {
        print("vpn butt")
        startStopVPN.imageView!.animationImages = [UIImage(named: "yellowLeftSemaphore")!, UIImage(named: "yellowRightSemaphore")!]
        startStopVPN.imageView!.animationDuration = 1
        startStopVPN.imageView!.startAnimating()

        initAsyncWorks()

        if vpnService.getVPNStatus() == VPNStatesEnum.ON && isWorkerInProgress == false {
            print("vpn is On. let it Off")
            isWorkerInProgress = true
            mySerialQueue.async(group: self.group, execute: self.disconnectWorkItem!)
        } else if vpnService.getVPNStatus() == VPNStatesEnum.OFF && isWorkerInProgress == false {
            print("vpn is Off. let it On")
            isWorkerInProgress = true
            mySerialQueue.async(group: self.group, execute: self.connnectWorkItem!)
        } else {
            print("vpn is PREPARING. trying to cancel PREPARING")
            connnectWorkItem!.cancel()
            disconnectWorkItem!.cancel()
        }

        group.notify(queue: DispatchQueue.main) {
            print("asyncDisconnectDispatchGroup notify enter")
            self.startStopVPN.imageView!.stopAnimating()
            if self.vpnService.getIsVPNOn() {
                self.startStopVPN.setImage(UIImage(named: "greenSemaphore"), for: UIControlState.normal)
            } else {
                self.startStopVPN.setImage(UIImage(named: "redSemaphore"), for: UIControlState.normal)
            }
            print("asyncDisconnectDispatchGroup notify exit")
        }
    }

    @objc func testAPI(_ sender: UIButton) {
        print("test API pressed")
        let user = User()
        print("test API end")
    }


    func initAsyncWorks() {
// TODO refactor this
        self.connnectWorkItem = DispatchWorkItem(qos: .userInitiated, flags: .enforceQoS) {

            let serverUuid: String?
            var config = ""
            do {
                if self.connnectWorkItem!.isCancelled {
                    print("connnectWorkItem got cancelled before receiveRandomVPNServer")
                    self.isWorkerInProgress = false
                    return
                }
                serverUuid = try self.userAPIService.receiveRandomVPNServer()

                if self.connnectWorkItem!.isCancelled {
                    print("connnectWorkItem got cancelled before receiveVPNConfigurationByUserAndServer")
                    self.isWorkerInProgress = false
                    return
                }
                config = try self.userAPIService.receiveVPNConfigurationByUserAndServer(serverUuid: serverUuid!)
            } catch ErrorsEnum.userAPIServiceSystemError {
// TODO show system error
                print()
                self.isWorkerInProgress = false
                return
            } catch ErrorsEnum.userAPIServiceConnectionProblem {
// TODO show connection error
                self.isWorkerInProgress = false
                return
            } catch {
// TODO show system error
                self.isWorkerInProgress = false
                return
            }

            if self.connnectWorkItem!.isCancelled {
                print("connnectWorkItem got cancelled before vpnService.connect")
                self.isWorkerInProgress = false
                return
            }
            do {
                try self.vpnService.connect(base64Config: config)
            } catch ErrorsEnum.VPNServiceSystemError {
// TODO show system error
                self.isWorkerInProgress = false
                return
            } catch {
                self.isWorkerInProgress = false
                return

            }
            do {
                try self.userAPIService.updateUserDevice(virtualIp: "1.1.1.1", deviceIp: "111.111.111.111", location: "Nigeria")
                try self.userAPIService.createConnection(serverUuid: serverUuid!, virtualIp: "1.1.1.1", deviceIp: "111.111.111.111")
                self.isWorkerInProgress = false
                return
            } catch ErrorsEnum.VPNServiceSystemError {
// TODO show system error
                self.isWorkerInProgress = false
                return
            } catch {
// TODO show system error
                self.isWorkerInProgress = false
                return
            }
        }

        self.disconnectWorkItem = DispatchWorkItem(qos: .userInitiated, flags: .enforceQoS) {
            if self.disconnectWorkItem!.isCancelled {
                print("disconnectWorkItem got cancelled before vpnService.disconnect")
                self.isWorkerInProgress = false
                return
            }
            self.vpnService.disconnect()
            self.isWorkerInProgress = false
        }

    }
}