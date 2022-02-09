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
//    isUsernameAvailablePublisher
//      .assign(to: &$isValid)
//
//    isUsernameAvailablePublisher
//      .map { $0 ? "" : "Username not available. Try a different one."}
//      .assign(to: &$usernameMessage)
  }
}
