//
//  DataHandler.swift
//  MapPlans
//
//  Created by Tobias on 17.10.2023.
//

import Foundation

enum DataHandlerError: Error, LocalizedError {
    case invalidData
    case emptyData
    
    var errorDescription: String? {
        switch self {
        case .invalidData:
            return NSLocalizedString("Invalid data.", comment: "")
        case .emptyData:
            return NSLocalizedString("Empty data.", comment: "")
        }
    }
}

protocol DataHandler {
    func decodeData<T: Decodable>(data: Data) throws -> T
    func encodeData<T: Encodable>(data: T) throws -> Data
}

extension DataHandler {
    func decodeData<T: Decodable>(data: Data) throws -> T {
        do {
            if data.isEmpty {
                throw DataHandlerError.emptyData
            }
            
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            throw DataHandlerError.invalidData
        }
    }
    
    func encodeData<T: Encodable>(data: T) throws -> Data {
        do {
            let encodedData = try JSONEncoder().encode(data)
            if encodedData.isEmpty {
                throw DataHandlerError.emptyData
            }
            return encodedData
        } catch {
            throw DataHandlerError.invalidData
        }
    }
}
