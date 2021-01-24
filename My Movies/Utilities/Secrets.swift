//
//  Secrets.swift
//  My Movies
//
//  Created by Russell Toon on 24/01/2021.
//

import Foundation


struct Secrets {

    func get(named secretName: String) -> String {

        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist") {
            let dictionary = NSDictionary(contentsOfFile: path)
            guard let secret = dictionary?.value(forKey: secretName) as? String else {
                assertionFailure("Secret named \(secretName) not found in Secrets.plist")
                return "Error: secret \(secretName) not found"
            }
            return secret
        }
        assertionFailure("Secrets.plist file not found")
        return "Error: secret \(secretName) not found"
    }
}
