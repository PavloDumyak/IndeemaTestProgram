//
//  CustomButton.swift
//  PlaceB
//
//  Created by Pavlo Dumyak on 27.01.16.
//

import UIKit

class CustomButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setTitle("Downloading", forState: .Normal)
        setTitle("Stop Downloading", forState: .Selected)
    }
}