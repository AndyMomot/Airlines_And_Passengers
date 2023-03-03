struct testDataModel: Codable {
    let data: PassengerDataModel
}

// MARK: - PassengerDataModel
struct PassengerDataModel: Codable {
    let totalPassengers, totalPages: Int?
    let data: [PassengerModelElement]?
}

// MARK: - Datum
struct PassengerModelElement: Codable {
    let id, name: String?
    let trips: Int?
    let airline: [Airline]?
    //let v: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, trips, airline
//        case v = "__v"
    }
}

// MARK: - Airline
struct Airline: Codable {
    let id: Int?
    let name, country: String?
    let logo: String?
    let slogan, headQuaters, website, established: String?

    enum CodingKeys: String, CodingKey {
        case id, name, country, logo, slogan
        case headQuaters = "head_quaters"
        case website, established
    }
}

