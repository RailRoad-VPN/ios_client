//
// Created by beop on 7/3/18.
// Copyright (c) 2018 beop. All rights reserved.
//

import Foundation
import UIKit


class PinViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    let userAPIService: UserAPIService

    let welcomeTitle = UILabel()
    let welcomeComment = UITextView()
    var firstPinNum: PinTextField
    var secondPinNum: PinTextField
    var thirdPinNum: PinTextField
    var fourthPinNum: PinTextField
    var actionStatus = UILabel()


    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        userAPIService = UserAPIService()

        firstPinNum = PinTextField()
        secondPinNum = PinTextField()
        thirdPinNum = PinTextField()
        fourthPinNum = PinTextField()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    }

    required init?(coder: NSCoder) {
        userAPIService = UserAPIService()

        firstPinNum = PinTextField()
        secondPinNum = PinTextField()
        thirdPinNum = PinTextField()
        fourthPinNum = PinTextField()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        firstPinNum.delegate = self
        secondPinNum.delegate = self
        thirdPinNum.delegate = self
        fourthPinNum.delegate = self
        welcomeComment.delegate = self

        view.backgroundColor = UIColor.greyRailRoad
        let coverPinNums = UIView()

        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height


//prepare frames for views
        let wTFrameHeight = CGFloat(70)
        let wTFrameWidth = screenWidth
        let wTFrameY = screenHeight / 9
        let wCFrameHeight = CGFloat(40)
        let wCFrameWidth = screenWidth
        let wCFrameY = wTFrameY + wTFrameHeight + wTFrameHeight / 4
        let pinNumHeight = CGFloat(15) + screenWidth / 10
        let pinNumWidth = CGFloat(15) + screenWidth / 10
        let pinNumMarginBetween = CGFloat(15)
        let pinNumY = wCFrameY + wCFrameHeight + screenHeight / 30
        let pinNumLeftMargin = (screenWidth - (pinNumWidth + pinNumMarginBetween) * 4 + pinNumMarginBetween) / 2  //CGFloat(50)

        let wTFrame = CGRect.init(x: 0, y: wTFrameY, width: wTFrameWidth, height: wTFrameHeight)
        let wCFrame = CGRect.init(x: 0, y: wCFrameY, width: wCFrameWidth, height: wCFrameHeight)
        var pinNumFrame = CGRect.init(x: pinNumLeftMargin, y: pinNumY, width: pinNumWidth, height: pinNumHeight)

        let actionStatusFrame = CGRect.init(x: 0, y: pinNumY + pinNumHeight, width: wCFrameWidth, height: wCFrameHeight)

        welcomeTitle.frame = wTFrame
        welcomeTitle.numberOfLines = 1
        welcomeTitle.text = "Welcome!"
        welcomeTitle.textAlignment = NSTextAlignment.center
        welcomeTitle.textColor = UIColor.white
        welcomeTitle.font = welcomeTitle.font.withSize(CGFloat(40))


//UITextView SIGN UP LINK
        let linkAttributes: [NSAttributedStringKey: Any] = [
            .link: NSURL(string: "http://internal.novicorp.com:61884/en/order?pack")!,
            .foregroundColor: UIColor.blue
        ]
        let attributedString = NSMutableAttributedString(string: "Enter a pin or Sign Up")

        // Set the 'Sign Up' substring to be the link
        attributedString.setAttributes(linkAttributes, range: NSMakeRange(15, 7))
        welcomeComment.isUserInteractionEnabled = true
        welcomeComment.isEditable = false
        welcomeComment.attributedText = attributedString
        welcomeComment.font = UIFont.systemFont(ofSize: 20)
        welcomeComment.frame = wCFrame
        welcomeComment.textAlignment = NSTextAlignment.center
        welcomeComment.textColor = UIColor.white
        welcomeComment.backgroundColor = UIColor.greyRailRoad

        firstPinNum.frame = pinNumFrame

        pinNumFrame = CGRect.init(x: pinNumLeftMargin + pinNumWidth + pinNumMarginBetween, y: pinNumY, width: pinNumWidth, height: pinNumHeight)
        secondPinNum.frame = pinNumFrame

        pinNumFrame = CGRect.init(x: pinNumLeftMargin + (pinNumWidth + pinNumMarginBetween) * 2, y: pinNumY, width: pinNumWidth, height: pinNumHeight)
        thirdPinNum.frame = pinNumFrame

        pinNumFrame = CGRect.init(x: pinNumLeftMargin + (pinNumWidth + pinNumMarginBetween) * 3, y: pinNumY, width: pinNumWidth, height: pinNumHeight)
        fourthPinNum.frame = pinNumFrame

        coverPinNums.frame = CGRect.init(x: 0, y: pinNumY, width: screenWidth, height: pinNumHeight)
//        coverPinNums.backgroundColor = UIColor.yellowRailRoad

        actionStatus.text = "LOADING..."
        actionStatus.textAlignment = .center
        actionStatus.textColor = .green
//        actionStatus.backgroundColor = UIColor.brown
        actionStatus.frame = actionStatusFrame
        actionStatus.isHidden = true


        view.addSubview(welcomeTitle)
        view.addSubview(welcomeComment)
        view.addSubview(firstPinNum)
        view.addSubview(secondPinNum)
        view.addSubview(thirdPinNum)
        view.addSubview(fourthPinNum)
        view.addSubview(coverPinNums)
        view.addSubview(actionStatus)

        firstPinNum.becomeFirstResponder()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("While entering the characters this method gets called")
        let text = textField.text
        print(text as Any)

        let userChar = string.cString(using: String.Encoding.utf8)!
        let isBackspace = strcmp(userChar, "\\b")

        if (isBackspace == -92) {
            print("backspace")
            switch textField {
            case firstPinNum:
                firstPinNum.becomeFirstResponder()
                firstPinNum.text = ""
            case secondPinNum:
                firstPinNum.becomeFirstResponder()
                secondPinNum.text = ""
            case thirdPinNum:
                secondPinNum.becomeFirstResponder()
                thirdPinNum.text = ""
            case fourthPinNum:
                thirdPinNum.becomeFirstResponder()
                fourthPinNum.text = ""
                firstPinNum.backgroundColor = UIColor.yellowRailRoad
                secondPinNum.backgroundColor = UIColor.yellowRailRoad
                thirdPinNum.backgroundColor = UIColor.yellowRailRoad
                fourthPinNum.backgroundColor = UIColor.yellowRailRoad
                actionStatus.isHidden = true
                actionStatus.text = "LOADING..."
            default: print("no")
            }
        } else {
            switch textField {
            case firstPinNum where firstPinNum.text?.count == 0:
                firstPinNum.text = string
            case firstPinNum where firstPinNum.text?.count == 1:
                secondPinNum.text = string
                secondPinNum.becomeFirstResponder()
            case secondPinNum:
                thirdPinNum.text = string
                thirdPinNum.becomeFirstResponder()
            case thirdPinNum:
                fourthPinNum.text = string
                fourthPinNum.becomeFirstResponder()
                print("timeToCheckPin")
                actionStatus.isHidden = false
                fourthPinNum.isUserInteractionEnabled = false
                self.pinDidInsert()
            case fourthPinNum:
                fourthPinNum.text = string
                print("timeToCheckPin")
                actionStatus.isHidden = false
                fourthPinNum.isUserInteractionEnabled = false
                self.pinDidInsert()
//                fourthPinNum.resignFirstResponder()
            default: print("no")
            }
        }

        return false;
    }

    func pinDidInsert() {
        let pincode = firstPinNum.text! + secondPinNum.text! + thirdPinNum.text! + fourthPinNum.text!
        var toProceed = false
        var errorMessage: String?

        let group = DispatchGroup()
        group.enter()

        DispatchQueue.main.async {
            do {
                toProceed = try self.isPinCorrect(pincode: pincode)
                if (toProceed) {
                    let userDevice = try self.userAPIService.createUserDevice()
                    CacheMetaService.shared.save(any: userDevice, toFile: FilesEnum.userDevice.rawValue)
                } else {
                    errorMessage = "You entered wrong pin"
                }
            } catch ErrorsEnum.userAPIServiceSystemError {
                toProceed = false
                errorMessage = "userAPIServiceSystemError"
            } catch ErrorsEnum.userAPIServiceApplicationError {
                toProceed = false
                errorMessage = "userAPIServiceApplicationError"
            } catch ErrorsEnum.userAPIServiceConnectionProblem {
                toProceed = false
                errorMessage = "userAPIServiceConnectionProblem"
            } catch {
                toProceed = false
                errorMessage = "userAPIServiceApplicationError"
            }

            group.leave()
        }

        group.notify(queue: .main) {
            if toProceed {
                self.firstPinNum.backgroundColor = UIColor.green
                self.secondPinNum.backgroundColor = UIColor.green
                self.thirdPinNum.backgroundColor = UIColor.green
                self.fourthPinNum.backgroundColor = UIColor.green
                self.actionStatus.isHidden = true

                let navigationController = RailRoadNavigationController.init(rootViewController: TabViewController())
                self.present(navigationController, animated: true)
            } else {
                self.firstPinNum.backgroundColor = UIColor.red
                self.secondPinNum.backgroundColor = UIColor.red
                self.thirdPinNum.backgroundColor = UIColor.red
                self.fourthPinNum.backgroundColor = UIColor.red
                self.fourthPinNum.isUserInteractionEnabled = true
                self.actionStatus.text = errorMessage
            }
        }
    }

    func isPinCorrect(pincode: String) throws -> Bool {
        print("isPinCorrect with pin: " + pincode)

        do {
            let user = try userAPIService.receiveUser(pincode: pincode)
            CacheMetaService.shared.save(any: user, toFile: FilesEnum.user.rawValue)
            print(user.getUuid)
            return true
        } catch ErrorsEnum.userAPIServiceWrongPin {
            return false
        } catch ErrorsEnum.userAPIServiceSystemError {
            throw ErrorsEnum.userAPIServiceSystemError
        } catch ErrorsEnum.userAPIServiceConnectionProblem {
            throw ErrorsEnum.userAPIServiceConnectionProblem
        } catch {
            throw ErrorsEnum.userAPIServiceApplicationError
        }
    }
}