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

enum APIError: LocalizedError {
  /// Invalid request, e.g. invalid URL
  case invalidRequestError(String)
  
  /// Indicates an error on the transport layer, e.g. not being able to connect to the server
  case transportError(Error)
}

struct AuthenticationService {
  
  func checkUserNameAvailablePublisher(userName: String) -> AnyPublisher<Bool, Error> {
    guard let url = URL(string: "http://127.0.0.1:8080/isUserNameAvailable?userName=\(userName)") else {
      return Fail(error: APIError.invalidRequestError("URL invalid"))
        .eraseToAnyPublisher()
    }
    
    return URLSession.shared.dataTaskPublisher(for: url)
      .mapError { error -> Error in
        return APIError.transportError(error)
      }
      .map(\.data)
      .decode(type: UserNameAvailableMessage.self, decoder: JSONDecoder())
      .map(\.isAvailable)
//      .replaceError(with: false)
      .eraseToAnyPublisher()
  }
  
}
