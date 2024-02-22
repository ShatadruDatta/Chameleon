//
//  WorkViewModels.swift
//  Chameleon
//
//  Created by SHATADRU DATTA on 22/02/24.
//

import Foundation

// MARK: - WorkViewDataModel
struct WorkViewDataModel: Codable {
    let result: [Result]
}

// MARK: - Result
struct Result: Codable {
    let insPartnerContactPerson: [InsContactPerson]
    let productInstallID: ID
    let appointment: String
    let insClientContactPerson: [InsContactPerson]
    let state: String
    let serviceID: ID
    let ncBNCNumber: String
    let id: Int
    let carRegNo, contactName, contactNumber: String
    let installationAddress: InstallationAddress

    enum CodingKeys: String, CodingKey {
        case insPartnerContactPerson = "ins_partner_contact_person"
        case productInstallID = "product_install_id"
        case appointment
        case insClientContactPerson = "ins_client_contact_person"
        case state
        case serviceID = "service_id"
        case ncBNCNumber = "nc_bnc_number"
        case id
        case carRegNo = "car_reg_no"
        case contactName = "contact_name"
        case contactNumber = "contact_number"
        case installationAddress = "installation_address"
    }
}

enum InsContactPerson: Codable {
    case integer(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(InsContactPerson.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for InsContactPerson"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

// MARK: - InstallationAddress
struct InstallationAddress: Codable {
    let postcode, customerContactName, clientContactName, street: String
    let street2: Street2
    let street3: Bool
    let latitude, longitude: Int

    enum CodingKeys: String, CodingKey {
        case postcode
        case customerContactName = "customer_contact_name"
        case clientContactName = "client_contact_name"
        case street, street2, street3, latitude, longitude
    }
}

enum Street2: Codable {
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
        throw DecodingError.typeMismatch(Street2.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Street2"))
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

// MARK: - ID
struct ID: Codable {
    let id: Int
    let name: String
}
