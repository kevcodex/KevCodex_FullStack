//
//  AboutContext.swift
//  App
//
//  Created by Kevin Chen on 1/26/19.
//

import Foundation

struct AboutContext: Encodable, BaseContext {
    let navigation: [NavigationItem]
    
    let title: String
}
