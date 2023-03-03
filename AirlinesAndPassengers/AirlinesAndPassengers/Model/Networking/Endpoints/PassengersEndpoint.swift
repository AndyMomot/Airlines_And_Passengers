import Foundation

enum PassengersEndpoint: Endpoint {
    case getAllPassengers
    case getSomePassengers(limit: Int)
    case postPassenger(name: String, trips: Int, airline: Int)
    case patchPassenger(id: String, name: String)
    case putPassenger(id: String, name: String, trips: Int, airline: Int)
    case delPassenger(id: String)
}

// MARK: - Endpoint methods
extension PassengersEndpoint {
    
    var path: String {
        switch self {
        case .getAllPassengers:
            return "passenger"
        case .getSomePassengers(limit: let limit):
            return "passenger?page=0&size=\(limit)"
        case .postPassenger:
            return "passenger/"
        case .putPassenger(id: let id, name: _, trips: _, airline: _):
            return "passenger/\(id)"
        case .delPassenger(id: let id):
            return "passenger/\(id)"
        case .patchPassenger(id: let id, name: _):
            return "passenger/\(id)"
        }
    }
    
    var method: ConstantsGlobal.HTTPMethod {
        switch self {
            
        case .getAllPassengers, .getSomePassengers:
            return .get
        case .postPassenger:
            return .post
        case .putPassenger:
            return .put
        case .delPassenger:
            return .delete
        case .patchPassenger:
            return .patch
        }
    }
    
    var parameters: [String: Any]? {
        var params: [String: Any]?
        switch self {
        case .getAllPassengers:
            params = [:]
        case .getSomePassengers:
            params = [:]
        case .postPassenger(name: let name, trips: let trips, airline: let airline):
            return ["name":     name,
                    "trips":    trips,
                    "airline":  airline]
        case .putPassenger(id: _, name: let name, trips: let trips, airline: let airline):
            return [
                "name": name,
                "trips": trips,
                "airline": airline
            ]
        case .delPassenger:
            params = [:]
        case .patchPassenger(id: _, name: let name):
            return ["name": name]
        }
        return params
    }
}

