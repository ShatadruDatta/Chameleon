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
    let productInstallID: ID
    let insPartnerContactPerson: [InsContactPerson]
    let carRegNo: String
    let id: Int
    let serviceID: ID
    let insClientContactPerson: [InsContactPerson]
    let state, appointment, contactName, ncBNCNumber: String
    let installationAddress: InstallationAddress
    let contactNumber: String

    enum CodingKeys: String, CodingKey {
        case productInstallID = "product_install_id"
        case insPartnerContactPerson = "ins_partner_contact_person"
        case carRegNo = "car_reg_no"
        case id
        case serviceID = "service_id"
        case insClientContactPerson = "ins_client_contact_person"
        case state, appointment
        case contactName = "contact_name"
        case ncBNCNumber = "nc_bnc_number"
        case installationAddress = "installation_address"
        case contactNumber = "contact_number"
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
    let clientContactName: String
    let latitude: Int
    let customerContactName, postcode, street, street2: String
    let street3: String
    let longitude: Int

    enum CodingKeys: String, CodingKey {
        case clientContactName = "client_contact_name"
        case latitude
        case customerContactName = "customer_contact_name"
        case postcode, street, street2, street3, longitude
    }
}

// MARK: - ID
struct ID: Codable {
    let name: String
    let id: Int
}
