//
//  NetworkHandler.swift
//  MapPlans
//
//  Created by Tobias on 17.10.2023.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidLink
    case invalidResponse
    case notFound
    case badRequest
    case requestError(errorCode: Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidLink:
            return NSLocalizedString("Invalid link.", comment: "")
        case .invalidResponse:
            return NSLocalizedString("Invalid response.", comment: "")
        case .notFound:
            return NSLocalizedString("Not found.", comment: "")
        case .badRequest:
            return NSLocalizedString("Bad request.", comment: "")
        case .requestError(let errorCode):
            return NSLocalizedString("Request error with code \(errorCode).", comment: "")
        }
    }
}

protocol NetworkHandler {
    func tryCheckResponse(response: URLResponse) throws
    func mapResponseStatus(statusCode: Int) throws
}

extension NetworkHandler {
    func tryCheckResponse(response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        try mapResponseStatus(statusCode: httpResponse.statusCode)
    }
    
    func mapResponseStatus(statusCode: Int) throws {
        switch statusCode {
        case 200..<300:
            return
        case 400:
            throw NetworkError.badRequest
        case 404:
            throw NetworkError.notFound
        default:
            throw NetworkError.requestError(errorCode: statusCode)
        }
    }
}
