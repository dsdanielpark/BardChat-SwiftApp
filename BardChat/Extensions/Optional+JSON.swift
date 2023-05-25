//
//  Optional+JSON.swift
//  BardChat
//
//  Created by parkminwoo on 2023/05/26.
//

extension Optional where Wrapped == [Any?] {
    var jsonStringRepresentation: String {
        switch self {
        case .none:
            return "null"
        case .some(let array):
            return array.jsonStringRepresentation
        }
    }
}

extension Optional where Wrapped == Any {
    var jsonStringRepresentation: String {
        switch self {
        case .none:
            return "null"
        case .some(let value):
            return value.jsonStringRepresentation
        }
    }
}
