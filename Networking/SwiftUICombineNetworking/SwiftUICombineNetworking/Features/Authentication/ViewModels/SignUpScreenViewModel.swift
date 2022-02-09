//
//  SignUpScreenViewModel.swift
//  SwiftUICombineNetworking
//
//  Created by Peter Friese on 06.01.22.
//

import Foundation
import Combine

extension Publisher {
  func asResult() -> AnyPublisher<Result<Output, Failure>, Never> {
    self
      .map(Result.success)
      .catch { error in
        Just(.failure(error))
      }
      .eraseToAnyPublisher()
  }
}

// MARK: - View Model
class SignUpScreenViewModel: ObservableObject {
  typealias Available = Result<Bool, Error>
  
  // MARK: Input
  @Published var username: String = ""
  
  // MARK: Output
  @Published var usernameMessage: String = ""
  @Published var isValid: Bool = false
  
  private var authenticationService = AuthenticationService()
  
  private lazy var isUsernameAvailablePublisher: AnyPublisher<Available, Never> = {
    $username
      .debounce(for: 0.8, scheduler: DispatchQueue.main)
      .removeDuplicates()
      .flatMap { username -> AnyPublisher<Available, Never> in
        self.authenticationService.checkUserNameAvailablePublisher(userName: username)
          .asResult()
      }
      .receive(on: DispatchQueue.main)
      .share()
      .eraseToAnyPublisher()
  }()
  
  init() {
    isUsernameAvailablePublisher
      .map { result in
        switch result {
        case .failure(let error):
          if case APIError.transportError(_) = error {
            return ""
          }
          else if case APIError.validationError(let reason) = error {
            return reason
          }
          else {
            return error.localizedDescription
          }
        case .success(let isAvailable):
          return isAvailable ? "" : "This username is not available"
        }
      }
      .assign(to: &$usernameMessage)
    
    isUsernameAvailablePublisher
      .map { result in
        if case .failure(let error) = result {
          if case APIError.transportError(_) = error {
            return true
          }
          return false
        }
        if case .success(let isAvailable) = result {
          return isAvailable
        }
        return true
      }
      .assign(to: &$isValid)

  }
}
