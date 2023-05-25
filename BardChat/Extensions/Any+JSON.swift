//
//  Any+JSON.swift
//  BardChat
//
//  Created by parkminwoo on 2023/05/26.
//

extension Any {
    var jsonStringRepresentation: String {
        if let number = self as? NSNumber {
            return number.stringValue
        }

        if let boolValue = self as? Bool {
            return boolValue ? "true" : "false"
        }

        if let array = self as? [Any?] {
            let jsonArray = array.map { $0.jsonStringRepresentation }
            return "[" + jsonArray.joined(separator: ",") + "]"
        }

        if let dictionary = self as? [String: Any?] {
            let jsonString = dictionary.reduce("") { (result, entry) -> String in
                let key = entry.key
                let value = entry.value.jsonStringRepresentation
                let keyValueString = "\"\(key)\":\(value)"
                return result.isEmpty ? keyValueString : "\(result),\(keyValueString)"
            }
            return "{" + jsonString + "}"
        }

        if let string = self as? String {
            let jsonString = string.replacingOccurrences(of: "\"", with: "\\\"")
            return "\"\(jsonString)\""
        }

        return "\(self)"
    }
}

