//
//  SignUpScreenViewModel.swift
//  SwiftUICombineNetworking
//
//  Created by Peter Friese on 06.01.22.
//

import Foundation
import Combine

// MARK: - View Model
class SignUpScreenViewModel: ObservableObject {
  
  // MARK: Input
  @Published var username: String = ""
  
  // MARK: Output
  @Published var usernameMessage: String = ""
  @Published var isValid: Bool = false
  
  private var authenticationService = AuthenticationService()
  
private lazy var isUsernameAvailablePublisher: AnyPublisher<Bool, Never> = {
  $username
    .flatMap { username -> AnyPublisher<Bool, Never> in
      self.authenticationService.checkUserNameAvailable(userName: username)
    }
    .receive(on: DispatchQueue.main)
    .eraseToAnyPublisher()
}()
  
  init() {
    isUsernameAvailablePublisher
      .assign(to: &$isValid)
    
    isUsernameAvailablePublisher
      .map { $0 ? "" : "Username not available. Try a different one."}
      .assign(to: &$usernameMessage)
  }
}
