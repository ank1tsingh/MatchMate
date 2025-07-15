//
//  User.swift
//  MatchMate
//
//  Created by Ankit on 15/07/25.
//

import Foundation

struct User: Codable, Identifiable {
    let id: UUID
    let gender: String
    let name: Name
    let location: Location
    let email: String
    let login: Login
    let dob: DateOfBirth
    let registered: Registered
    let phone: String
    let cell: String
    let picture: Picture
    let nat: String
    
    // for Core Data compatibility
    var userId: String {
        return login.uuid
    }
    
    enum CodingKeys: String, CodingKey {
        case gender, name, location, email, login, dob, registered, phone, cell, picture, nat
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = UUID()
        self.gender = try container.decode(String.self, forKey: .gender)
        self.name = try container.decode(Name.self, forKey: .name)
        self.location = try container.decode(Location.self, forKey: .location)
        self.email = try container.decode(String.self, forKey: .email)
        self.login = try container.decode(Login.self, forKey: .login)
        self.dob = try container.decode(DateOfBirth.self, forKey: .dob)
        self.registered = try container.decode(Registered.self, forKey: .registered)
        self.phone = try container.decode(String.self, forKey: .phone)
        self.cell = try container.decode(String.self, forKey: .cell)
        self.picture = try container.decode(Picture.self, forKey: .picture)
        self.nat = try container.decode(String.self, forKey: .nat)
    }
}

struct Name: Codable {
    let title: String
    let first: String
    let last: String
    
    var fullName: String {
        return "\(first) \(last)"
    }
}

struct Location: Codable {
    let street: Street
    let city: String
    let state: String
    let country: String
    let postcode: PostcodeType
    let coordinates: Coordinates
    let timezone: Timezone
    
    var displayLocation: String {
        return "\(city), \(state)"
    }
    
    enum CodingKeys: String, CodingKey {
        case street, city, state, country, postcode, coordinates, timezone
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.street = try container.decode(Street.self, forKey: .street)
        self.city = try container.decode(String.self, forKey: .city)
        self.state = try container.decode(String.self, forKey: .state)
        self.country = try container.decode(String.self, forKey: .country)
        self.coordinates = try container.decode(Coordinates.self, forKey: .coordinates)
        self.timezone = try container.decode(Timezone.self, forKey: .timezone)
        
        // Handle postcode as either String or Int
        if let postcodeInt = try? container.decode(Int.self, forKey: .postcode) {
            self.postcode = .integer(postcodeInt)
        } else if let postcodeString = try? container.decode(String.self, forKey: .postcode) {
            self.postcode = .string(postcodeString)
        } else {
            self.postcode = .string("N/A")
        }
    }
}

enum PostcodeType: Codable {
    case integer(Int)
    case string(String)
    
    var value: String {
        switch self {
        case .integer(let int):
            return String(int)
        case .string(let string):
            return string
        }
    }
}

struct Street: Codable {
    let number: Int
    let name: String
}

struct Coordinates: Codable {
    let latitude: String
    let longitude: String
}

struct Timezone: Codable {
    let offset: String
    let description: String
}

struct Login: Codable {
    let uuid: String
    let username: String
    let password: String
    let salt: String
    let md5: String
    let sha1: String
    let sha256: String
}

struct DateOfBirth: Codable {
    let date: String
    let age: Int
}

struct Registered: Codable {
    let date: String
    let age: Int
}

struct Picture: Codable {
    let large: String
    let medium: String
    let thumbnail: String
}
