//
//  String.swift
//  ArgoParser
//
//  Created by Walig Castain on 21/12/15.
//  Copyright © 2015 Walig Castain. All rights reserved.
//

import Foundation

extension String {
    
    var underscoreToCamelCase: String {
        let items = self.componentsSeparatedByString("_")
        var camelCase = ""
        items.enumerate().forEach {
            camelCase += 0 == $0 ? $1 : $1.capitalizedString
        }
        return camelCase
    }
    
    func wrappedBy(character: String) -> String {
        return character + self + character
    }
}
