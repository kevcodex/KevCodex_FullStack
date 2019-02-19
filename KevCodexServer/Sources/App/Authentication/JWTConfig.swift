//
//  JWTConfig.swift
//  App
//
//  Created by Kevin Chen on 2/15/19.
//

import JWT

struct JWTConfig {
    static var key: String = ""
    static var signer: JWTSigner {
        return .hs256(key: key)
    }
}
