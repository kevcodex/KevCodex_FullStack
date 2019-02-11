//
//  String+NonEmpty.swift
//  KevCodexIOS
//
//  Created by Kevin Chen on 2/11/19.
//  Copyright © 2019 Kirby. All rights reserved.
//

import Foundation

extension String {
    var nonEmpty: StringLiteralType? {
        return !isEmpty ? self : nil
    }
}
