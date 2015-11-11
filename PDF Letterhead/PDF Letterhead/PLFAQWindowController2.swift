//
//  PLFAQWindowController2.swift
//  PDF Letterhead
//
//  Created by Pim Snel on 11-11-15.
//  Copyright © 2015 Pim Snel. All rights reserved.
//

import Foundation
import Cocoa

class PLFAQWindowController2: NSWindowController {
    
    @IBOutlet var FAQView: NSTextView!

    override func awakeFromNib() {
        FAQView.readRTFDFromFile(NSBundle.mainBundle().pathForResource("FAQ", ofType: "rtf")!)
        NSLog("%@", NSBundle.mainBundle().pathForResource("FAQ", ofType: "rtf")!)

    }
}