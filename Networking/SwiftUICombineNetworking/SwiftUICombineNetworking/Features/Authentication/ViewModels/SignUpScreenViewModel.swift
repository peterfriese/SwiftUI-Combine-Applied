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
      .debounce(for: 0.8, scheduler: DispatchQueue.main)
      .removeDuplicates()
      .print("username")
      .flatMap { username in
        self.authenticationService.checkUserNameAvailablePublisher(userName: username)
          .catch { error in
            return Just(false)
          }
          .eraseToAnyPublisher()
      }
      .receive(on: DispatchQueue.main)
      .share()
      .print("share")
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
