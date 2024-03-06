//
//  ProductModels.swift
//  Chameleon
//
//  Created by SHATADRU DATTA on 06/03/24.
//

import Foundation

// MARK: - Welcome
struct ProductModels: Codable {
    let result: [ResultModels]
}

// MARK: - Result
struct ResultModels: Codable {
    let defaultCode: String?
    let id: Int
    let name: String?

    enum CodingKeys: String, CodingKey {
        case defaultCode = "default_code"
        case id, name
    }
}

enum DefaultCode: Codable {
    case bool(Bool)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Bool.self) {
            self = .bool(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(DefaultCode.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for DefaultCode"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .bool(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}
