//
//  Constants.swift
//  Nine
//
//  Created by Tian He on 3/12/16.
//  Copyright © 2016 Tian He. All rights reserved.
//

import UIKit

struct Constants {
    static let MaxMood = 1
    static let MinMood = -1
    static let MaxEnergy = 1
    static let MinEnergy = -1
    static let NormalizedScore = 100
    
    static let primaryColor = UIColor(red: 255.0/255.0, green: 158.0/255.0, blue: 75.0/255.0, alpha: 1.0)
    static let primaryLightColor = UIColor(red: 255.0/255.0, green: 196/255.0, blue: 146/255.0, alpha: 1)
    static let primaryDarkColor = UIColor(red: 255/255.0, green: 128/255.0, blue: 19/255.0, alpha: 1)
    static let secondaryColor = UIColor(red: 67/255.0, green: 227/255.0, blue: 77/255.0, alpha: 1)
    static let secondaryLightColor = UIColor(red: 139/255.0, green: 243/255.0, blue: 146/255.0, alpha: 1)
    static let secondaryDarkColor = UIColor(red: 17/255.0, green: 225/255.0, blue: 31/255.0, alpha: 1)
    static let tertiaryColor = UIColor(red: 78/255.0, green: 118/255.0, blue: 212/255.0, alpha: 1)
    static let tertiaryLightColor = UIColor(red: 145/255.0, green: 173/255.0, blue: 236/255.0, alpha: 1)
    static let tertiaryDarkColor = UIColor(red: 36/255.0, green: 88/255.0, blue: 209/255.0, alpha: 1)
    static let colorScheme = [tertiaryLightColor, tertiaryColor, tertiaryDarkColor,
        secondaryLightColor, secondaryColor, secondaryDarkColor,
        primaryLightColor, primaryColor, primaryDarkColor
    ]
}