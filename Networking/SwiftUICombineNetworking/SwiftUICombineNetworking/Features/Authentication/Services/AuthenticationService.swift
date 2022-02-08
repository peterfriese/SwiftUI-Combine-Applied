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

struct AuthenticationService {

  func checkUserNameAvailablePublisher(userName: String) -> AnyPublisher<Bool, Never> {
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
