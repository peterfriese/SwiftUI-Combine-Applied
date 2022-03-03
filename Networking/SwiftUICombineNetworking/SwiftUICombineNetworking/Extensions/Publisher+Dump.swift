//
//  Publisher+Dump.swift
//  SwiftUICombineNetworking
//
//  Created by Peter Friese on 03.03.22.
//

import Foundation
import Combine

extension Publisher {
  func dump() -> AnyPublisher<Self.Output, Self.Failure> {
    handleEvents(receiveOutput:  { value in
      Swift.dump(value)
    })
    .eraseToAnyPublisher()
  }
}
