//
// Created by beop on 7/3/18.
// Copyright (c) 2018 beop. All rights reserved.
//

import Foundation
import UIKit

class PinTextField: UITextField {



    override init(frame: CGRect) {
        super.init(frame: frame)
        let screenHeight = UIScreen.main.bounds.height

        keyboardType = UIKeyboardType.decimalPad
        backgroundColor = UIColor.yellowRailRoad
        textAlignment = NSTextAlignment.center
        placeholder = "_"
        font = UIFont.systemFont(ofSize: 5 + screenHeight/40)
    }

    convenience init() {
        self.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
    }

    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
//        let margin = (bounds.size.width - font!.pointSize) / 2;
//        let inset = CGRect(x: bounds.origin.x + margin, y: bounds.origin.y, width: bounds.size.width - margin, height: bounds.size.height);
//        return inset;
        return super.textRect(forBounds: bounds)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
//        let margin = (bounds.size.width - font!.pointSize) / 2;
//        let inset = CGRect(x: bounds.origin.x + margin, y: bounds.origin.y, width: bounds.size.width - margin, height: bounds.size.height);
//        return inset
        return super.editingRect(forBounds: bounds)
    }

//
//- (CGRect)caretRectForPosition:(UITextPosition *)position
//{
//return CGRectZero;
//}

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
