//
//  Parser.swift
//  MtsAstra
//
//  Created by SerhiiHaponov on 02.08.2021.
//

import Foundation


struct Parser {

    static func parseData<T: Codable>(_ result: Results<Data>)  -> Results<T> {

        guard let data = result.value else {
            var error = result.error ?? ResponseError.dataMissed

            if let errorData = (result.error as? ResponseError)?.data {
                let errorResult = result.error as? ResponseError
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let errorModel = try? decoder.decode(ErrorDataModel.self, from: errorData)
                let firstError = errorModel?.errors.first
                error = ResponseError.failed(code: errorResult?.statusCode ?? .unknownError,
                                             description: firstError?.description,
                                             data: errorData)
            }
            return Results.failure(error)
        }

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let result = try decoder.decode(T.self, from: data)
            return Results.success(result)
        } catch DecodingError.dataCorrupted(let context) {
            print("\n---In \(T.self)")
            print(context)
        } catch DecodingError.keyNotFound(let key, let context) {
            print("\n---In \(T.self)")
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch DecodingError.valueNotFound(let value, let context) {
            print("\n---In \(T.self)")
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch DecodingError.typeMismatch(let type, let context) {
            print("\n---In \(T.self)")
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error)
        }

        return Results.failure(ResponseError.dataMissed)
    }
    
//    static func parseData<T: Codable>(_ result: Swift.Result<Data, Error>) -> Swift.Result<T, Error> {
//        let alamofireResult: Alamofire.Result<Data> = {
//            switch result {
//            case .success(let data): return .success(data)
//            case .failure(let error): return .failure(error)
//            }
//        }()
//        let data: Result<T> = parseData(alamofireResult)
//        switch data {
//        case .success(let data): return .success(data)
//        case .failure(let error): return .failure(error)
//        }
//    }
    
//    static func parseJwtToken(jwt: String) -> String? {
//        guard let payload = try? decode(jwtToken: jwt) else { return nil }
//        let token = payload[Constants.NetworkPayload.accessToken] as? String
//        return token
//    }
    
    static func decode(jwtToken jwt: String) throws -> [String: Any] {
                
        enum DecodeErrors: Error {
            case badToken
            case other
        }
        
        func base64Decode(_ base64: String) throws -> Data {
            let padded = base64.padding(toLength: ((base64.count + 3) / 4) * 4, withPad: "=", startingAt: 0)
            guard let decoded = Data(base64Encoded: padded) else {
                throw DecodeErrors.badToken
            }
            return decoded
        }
        
        func decodeJWTPart(_ value: String) throws -> [String: Any] {
            let bodyData = try base64Decode(value)
            let json = try JSONSerialization.jsonObject(with: bodyData, options: [])
            guard let payload = json as? [String: Any] else {
                throw DecodeErrors.other
            }
            return payload
        }
        
        let segments = jwt.components(separatedBy: ".")
        return try decodeJWTPart(segments[1])
    }
}
