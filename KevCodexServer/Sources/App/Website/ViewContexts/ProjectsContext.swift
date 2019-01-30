//
//  ProjectsContext.swift
//  App
//
//  Created by Kevin Chen on 1/29/19.
//

import Foundation

struct ProjectsContext: Encodable, BaseContext {
    let navigation: [NavigationItem]
    
    let title: String
}
