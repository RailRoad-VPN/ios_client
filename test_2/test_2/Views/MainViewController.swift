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
        print_f(#file, #function, "MainController INIT works!!!")

        self.userAPIService = UserAPIService.shared
        self.vpnService = VPNService.shared
        self.serverList = UIButton()
        self.startStopVPN = UIButton()
        self.hintCommentLabel = UILabel()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)


    }

    required init?(coder: NSCoder) {
        self.userAPIService = UserAPIService.shared
        self.vpnService = VPNService.shared
        self.serverList = UIButton()
        self.startStopVPN = UIButton()
        self.hintCommentLabel = UILabel()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        WorkThread.shared.eternalCheckUserValid()

//background picture
        self.view.backgroundColor = UIColor.greyRailRoad
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        imageView.contentMode = UIViewContentMode.scaleToFill
        imageView.image = UIImage.init(named: "homeBackground")!

        self.view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)

        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshImageButton(_:)), name: .VPNConnected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshImageButton(_:)), name: .VPNDisconnected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.startSemaphoreAnimation(_:)), name: .VPNServiceWorkInProgress, object: nil)
        self.loadButtons()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.navigationBar.topItem!.title = NSLocalizedString("railroad_vpn", comment: "RailRoad VPN")
        self.navigationController?.navigationBar.topItem!.title = nil
        self.navigationController?.navigationBar.backgroundColor = nil
        self.navigationController?.navigationBar.isTranslucent = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
// TODO need to be uncommented, but there is a bug
//        self.navigationController?.navigationBar.isTranslucent = false
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
        // set label Attribute
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

        self.setButtonAndHintColor()
    }

    private func setButtonAndHintColor() {
        var hintComment: NSMutableAttributedString
        if VPNService.shared.getIsVPNOn() {
            self.startStopVPN.setImage(UIImage(named: "greenSemaphore"), for: UIControlState.normal)
            hintComment = NSMutableAttributedString(string: NSLocalizedString("press_green_semaphore_to_disconnect", comment: "Press green semaphore to disconnect"), attributes:
            [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Light", size: 10)!]
            )
            hintComment.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: hintComment.length))
            hintComment.addAttribute(.foregroundColor, value: UIColor.green, range: NSRange(location: 6, length: 5))
        } else {
            self.startStopVPN.setImage(UIImage(named: "redSemaphore"), for: UIControlState.normal)
            hintComment = NSMutableAttributedString(string: NSLocalizedString("press_red_semaphore_to_connect", comment: ""), attributes:
            [NSAttributedStringKey.font: UIFont(name: "HelveticaNeue-Light", size: 10)!]
            )
            hintComment.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: hintComment.length))
            hintComment.addAttribute(.foregroundColor, value: UIColor.red, range: NSRange(location: 6, length: 3))
        }
        self.hintCommentLabel.attributedText = hintComment
    }

    @objc func connectToVPN(_ sender: UIButton) {
        print_f(#file, #function, "vpn butt")
        self.startSemaphoreAnimation(self)
        initAsyncWorks()

        if vpnService.getVPNStatus() == VPNStatesEnum.ON && isWorkerInProgress == false {
            print_f(#file, #function, "vpn is On. let it Off")
            isWorkerInProgress = true
            mySerialQueue.async(group: self.group, execute: self.disconnectWorkItem!)
        } else if vpnService.getVPNStatus() == VPNStatesEnum.OFF && isWorkerInProgress == false {
            print_f(#file, #function, "vpn is Off. let it On")
            isWorkerInProgress = true
            mySerialQueue.async(group: self.group, execute: self.connnectWorkItem!)
        } else {
            print_f(#file, #function, "vpn is PREPARING. trying to cancel PREPARING")
            connnectWorkItem!.cancel()
            disconnectWorkItem!.cancel()
        }

        group.notify(queue: DispatchQueue.main) {
            print_f(#file, #function, "asyncDisconnectDispatchGroup notify enter")
            self.refreshImageButton(self)
            print_f(#file, #function, "asyncDisconnectDispatchGroup notify exit")
        }
    }

    @objc func refreshImageButton(_ sender: Any) {
        print_f(#file, #function, "refreshImageButton start. Broadcast or not")
        self.startStopVPN.imageView!.stopAnimating()
        self.setButtonAndHintColor()
        print_f(#file, #function, "refreshImageButton end")
    }

    @objc func startSemaphoreAnimation(_ sender: Any) {
        print_f(#file, #function, "startSemaphoreAnimation start. Broadcast or not")
        self.startStopVPN.imageView!.animationImages = [UIImage(named: "yellowLeftSemaphore")!, UIImage(named: "yellowRightSemaphore")!]
        self.startStopVPN.imageView!.animationDuration = 1
        self.startStopVPN.imageView!.startAnimating()
        print_f(#file, #function, "startSemaphoreAnimation end")
    }

    @objc func testAPI(_ sender: UIButton) {
        print_f(#file, #function, "test API pressed")
        do {
            try UserAPIService.shared.createTicket(description: "test1")
        } catch let e {
            print_f(#file, #function, e.localizedDescription)
        }
//        print_f(#file, #function, Date(), self, #function, "test API end", separator: ": ", to: &Log.log)
        print_f(#file, #function, "test API end")
    }


    func initAsyncWorks() {
// TODO refactor this
        self.connnectWorkItem = DispatchWorkItem(qos: .userInitiated, flags: .enforceQoS) {
            if (UserAPIService.shared.user.getIsLocked() == true
                    || UserAPIService.shared.user.getIsExpired() == true
                    || UserAPIService.shared.user.getIsEnabled() == false
                    || UserAPIService.shared.user.getUserDevice()?.getIsActive() == false) {
                WorkThread.shared.backgroundIskUserValid()
                if (UserAPIService.shared.user.getIsLocked() == true
                        || UserAPIService.shared.user.getIsExpired() == true
                        || UserAPIService.shared.user.getIsEnabled() == false
                        || UserAPIService.shared.user.getUserDevice()?.getIsActive() == false) {
                    print_f(#file, #function, "checking user before connect. User is not okay")
                    self.isWorkerInProgress = false
                    return
                }

            }

            let serverUuid: String?
            var config = ""
            do {
                if self.connnectWorkItem!.isCancelled {
                    print_f(#file, #function, "connnectWorkItem got cancelled before receiveRandomVPNServer")
                    self.isWorkerInProgress = false
                    return
                }
                serverUuid = try self.userAPIService.receiveRandomVPNServer()

                if self.connnectWorkItem!.isCancelled {
                    print_f(#file, #function, "connnectWorkItem got cancelled before receiveVPNConfigurationByUserAndServer")
                    self.isWorkerInProgress = false
                    return
                }
                config = try self.userAPIService.receiveVPNConfigurationByUserAndServer(serverUuid: serverUuid!)
            } catch ErrorsEnum.userAPIServiceSystemError {
// TODO show system error
                print_f(#file, #function, "")
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
                print_f(#file, #function, "connnectWorkItem got cancelled before vpnService.connect")
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
                let connectionUUID = try self.userAPIService.createConnection(serverUuid: serverUuid!, virtualIp: "1.1.1.1", deviceIp: "111.111.111.111")
                let connection = Connection.init(uuid: connectionUUID, serverUUID: serverUuid!)
                CacheMetaService.shared.save(any: connection, toFile: FilesEnum.currentConnection.rawValue)
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
                print_f(#file, #function, "disconnectWorkItem got cancelled before vpnService.disconnect")
                self.isWorkerInProgress = false
                return
            }
            self.vpnService.disconnect()
            let connection = Connection.init()
            if connection.uuid != nil {
                do {
                    try self.userAPIService.updateConnection(connectionUUID: connection.uuid!, serverUuid: connection.serverUUID!, bytes_i: 0, bytes_o: 0, isConnected: false)
                } catch ErrorsEnum.VPNServiceSystemError {
                    self.isWorkerInProgress = false
                } catch {
                    self.isWorkerInProgress = false
                }
            }
            self.isWorkerInProgress = false
        }


    }
}