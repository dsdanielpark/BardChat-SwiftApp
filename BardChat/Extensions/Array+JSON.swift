//
//  Array+JSON.swift
//  BardChat
//
//  Created by parkminwoo on 2023/05/26.
//

extension Array where Element == [Any?] {
    var jsonStringRepresentation: String {
        let jsonArray = self.map { $0.jsonStringRepresentation }
        return "[" + jsonArray.joined(separator: ",") + "]"
    }
}
