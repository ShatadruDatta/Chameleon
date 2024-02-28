//
//  JobSheetModels.swift
//  Chameleon
//
//  Created by SHATADRU DATTA on 28/02/24.
//

import Foundation

// MARK: - JobSheet
struct JobSheetModels: Codable {
    let state, ncBNCNumber: String
    let partList: [PartList]
    let productInstallID: Customer
    let deliveryAddress: DeliveryAddress
    let engineerID: Customer
    let delClientContactPerson: [ContactPerson]
    let id: Int
    let installationAddress: JobSheetInstallationAddress
    let service: Service
    let engineerNotes2: String
    let customerClient: Customer
    let insClientContactPerson: [ContactPerson]
    let appointment: String
    let clientOrderRef: String
    let insPartnerContactPerson: [ContactPerson]
    let installationVehicleDetails: InstallationVehicleDetails
    let customer: Customer

    enum CodingKeys: String, CodingKey {
        case state
        case ncBNCNumber = "nc_bnc_number"
        case partList = "part_list"
        case productInstallID = "product_install_id"
        case deliveryAddress = "delivery_address"
        case engineerID = "engineer_id"
        case delClientContactPerson = "del_client_contact_person"
        case id
        case installationAddress = "installation_address"
        case service
        case engineerNotes2 = "engineer_notes2"
        case customerClient = "customer_client"
        case insClientContactPerson = "ins_client_contact_person"
        case appointment
        case clientOrderRef = "client_order_ref"
        case insPartnerContactPerson = "ins_partner_contact_person"
        case installationVehicleDetails = "installation_vehicle_details"
        case customer
    }
}

// MARK: - Customer
struct Customer: Codable {
    let name: String
    let id: Int
}

enum ContactPerson: Codable {
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
        throw DecodingError.typeMismatch(ContactPerson.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ContactPerson"))
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

// MARK: - DeliveryAddress
struct DeliveryAddress: Codable {
    let postcode, street: String
    let street2: Bool
    let clientContactName: String
    let street3: Bool
    let contactName, email, contactNumber: String

    enum CodingKeys: String, CodingKey {
        case postcode, street, street2
        case clientContactName = "client_contact_name"
        case street3
        case contactName = "contact_name"
        case email
        case contactNumber = "contact_number"
    }
}

// MARK: - InstallationAddress
struct JobSheetInstallationAddress: Codable {
    let postcode, street, street2, clientContactName: String
    let street3, contactName, customerContactName, email: String
    let contactNumber: String

    enum CodingKeys: String, CodingKey {
        case postcode, street, street2
        case clientContactName = "client_contact_name"
        case street3
        case contactName = "contact_name"
        case customerContactName = "customer_contact_name"
        case email
        case contactNumber = "contact_number"
    }
}

// MARK: - InstallationVehicleDetails
struct InstallationVehicleDetails: Codable {
    let vehicle: String
    let yom, fuelType: Bool
    let reg, vin: String
    let colour: Bool

    enum CodingKeys: String, CodingKey {
        case vehicle, yom
        case fuelType = "fuel_type"
        case reg, vin, colour
    }
}

// MARK: - PartList
struct PartList: Codable {
    let id: Int
    let productID: Customer
    let serial1: Bool
    let quantity: Int
    let serial2: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case serial1, quantity, serial2
    }
}

// MARK: - Service
struct Service: Codable {
    let id: Int
    let service: String
    let engineerFee: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id, service
        case engineerFee = "engineer_fee"
        case name
    }
}
