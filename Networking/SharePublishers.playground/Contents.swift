import UIKit
import Combine

print("---\nUnshared publisher")

let subject = PassthroughSubject<String, Never>()
let publisher = subject
  .flatMap { value -> AnyPublisher<String, Never> in
    print("Publish \(value)")
    return Just(value).eraseToAnyPublisher()
  }

publisher
  .map { $0.lowercased() }
  .sink { print("Subscriber 1:", $0) }

publisher
  .sink { print("Subscriber 2:", $0) }

subject.send("One")
subject.send("Two")


print("---\nShared publisher")

let subject2 = PassthroughSubject<String, Never>()
let publisher2 = subject2
  .flatMap { value -> AnyPublisher<String, Never> in
    print("Publish \(value)")
    return Just(value).eraseToAnyPublisher()
  }
  .share()

publisher2
  .map { $0.lowercased() }
  .sink { print("Subscriber 1:", $0) }

publisher2
  .sink { print("Subscriber 2:", $0) }

subject2.send("One")
subject2.send("Two")
