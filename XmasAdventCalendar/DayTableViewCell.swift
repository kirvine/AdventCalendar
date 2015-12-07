//
//  DayTableViewCell.swift
//  XmasAdventCalendar
//
//  Created by Karen on 12/7/15.
//  Copyright © 2015 Karen. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class DayTableViewCell: PFTableViewCell {

    @IBOutlet weak var giftImage: PFImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!

}
