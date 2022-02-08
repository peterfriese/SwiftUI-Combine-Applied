//
//  AuthenticationService.swift
//  SwiftUICombineNetworking
//
//  Created by Peter Friese on 06.01.22.
//

import Foundation
import Combine
import UIKit

struct UserNameAvailableMessage: Codable {
  var isAvailable: Bool
  var userName: String
}

struct APIErrorMessage: Decodable {
  var error: Bool
  var reason: String
}

enum APIError: LocalizedError {
  /// Invalid request, e.g. invalid URL
  case invalidRequestError(String)

  /// Indicates an error on the transport layer, e.g. not being able to connect to the server
  case transportError(Error)
  
  /// Received an invalid response, e.g. non-HTTP result
  case invalidResponse
  
  /// Server-side validation error
  case validationError(String)
  
  /// General server-side error. If `retryAfter` is set, the client can send the same request after the given time.
  case serverError(statusCode: Int, reason: String? = nil, retryAfter: String? = nil)
  
  case decodingError(Error)
  case encodingError(Error)
  
  case noData
  
  var errorDescription: String? {
    switch self {
    case .invalidRequestError(let message):
      return "Invalid request: \(message)"
    case .transportError(let error):
      return "Transport error: \(error)"
    case .invalidResponse:
      return "Invalid response"
    case .validationError(let reason):
      return "Validation Error: \(reason)"
    case .serverError(let statusCode, let reason, let retryAfter):
      return "Server error with code \(statusCode), reason: \(reason ?? "no reason given"), retry after: \(retryAfter ?? "no retry after provided")"
    case .decodingError(let error):
      return "Decoding error: \(error)"
    case .encodingError(let error):
      return "Encoding error: \(error)"
    case .noData:
      return "No data"
    }
  }
}

struct AuthenticationService {

  func checkUserNameAvailable(userName: String) -> AnyPublisher<Bool, Never> {
    guard let url = URL(string: "http://127.0.0.1:8080/isUserNameAvailable?userName=\(userName)") else {
      return Just(false).eraseToAnyPublisher()
    }
    
    return URLSession.shared.dataTaskPublisher(for: url)
      .map(\.data)
      .decode(type: UserNameAvailableMessage.self, decoder: JSONDecoder())
      .map(\.isAvailable)
      .replaceError(with: false)
      .eraseToAnyPublisher()
  }
  
}
