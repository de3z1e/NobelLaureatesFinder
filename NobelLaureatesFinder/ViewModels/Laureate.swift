//
//  Laureate.swift
//  NobelLaureatesFinder
//
//  Created by Dimitry Zadorozny on 7/27/21.
//

import Foundation
import CoreLocation

struct Laureate: Decodable {
    let id: UInt32
    let category: String?
    let died: Date?
    let diedCity: String?
    let bornCity: String?
    let born: Date?
    let surname: String?
    let firstName: String?
    let motivation: String?
    let location: CLLocation
    let city: String?
    let bornCountry: String?
    let year: Int32
    let diedCountry: String?
    let country: String?
    let gender: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case category = "category"
        case died = "died"
        case diedCity = "diedcity"
        case bornCity = "borncity"
        case born = "born"
        case surname = "surname"
        case firstName = "firstname"
        case motivation = "motivation"
        case location = "location"
        case city = "city"
        case bornCountry = "borncountry"
        case year = "year"
        case diedCountry = "diedcountry"
        case country = "country"
        case gender = "gender"
        case name = "name"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Self.CodingKeys)
        id = try container.decode(UInt32.self, forKey: .id)
        category = try container.decode(String.self, forKey: .category)
        let diedString = try container.decode(String.self, forKey: .died)
        died = Self.formattedDate(from: diedString)
        diedCity = try container.decode(String.self, forKey: .diedCity)
        bornCity = try container.decode(String.self, forKey: .bornCity)
        let bornString = try container.decode(String.self, forKey: .born)
        born = Self.formattedDate(from: bornString)
        surname = try container.decode(String.self, forKey: .surname)
        firstName = try container.decode(String.self, forKey: .firstName)
        motivation = try container.decode(String.self, forKey: .motivation)
        let loc = try container.decode(Location.self, forKey: .location)
        location = CLLocation(latitude: loc.lat, longitude: loc.lng)
        city = try container.decode(String.self, forKey: .city)
        bornCountry = try container.decode(String.self, forKey: .bornCountry)
        let yearString = try container.decode(String.self, forKey: .year)
        guard let yearInt = Int32(yearString) else {
            let context = DecodingError.Context(
                codingPath: [CodingKeys.year],
                debugDescription: "Could not convert the year String to an Int16"
            )
            throw DecodingError.typeMismatch(Int32.self, context)}
        year = yearInt
        diedCountry = try container.decode(String.self, forKey: .diedCountry)
        country = try container.decode(String.self, forKey: .country)
        gender = try container.decode(String.self, forKey: .gender)
        name = try container.decode(String.self, forKey: .name)
    }
    
    /// Helper function to convert a date string to `Date` object
    /// - Parameter str: String representation of a date formatted as `yyyy-MM-dd`.
    private static func formattedDate(from str: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
//        formatter.dateStyle = .short
        return formatter.date(from: str)
    }
    
    /// Helper struct to decode nested location object
    private struct Location: Decodable {
        let lat: Double
        let lng: Double
    }
}

extension Laureate: Fetchable {
    
    /// URL to AWS S3 bucket to fetch fetch laureates.json data.
    static var resourceUrl: URL? {
        URL(string: "https://nobel-prize-finder.s3.us-west-2.amazonaws.com/laureates.json")
    }
}
