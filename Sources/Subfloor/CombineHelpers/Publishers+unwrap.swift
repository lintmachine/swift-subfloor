import Combine

public extension Publisher  {
    /// Ignore any `nil` values, forwarding only honest values.
    /// NOTE: This operator removes the `Optional` wrapper from the `Output` type
    func unwrap<Wrapped>() -> AnyPublisher<Wrapped, Self.Failure> where Output == Optional<Wrapped> {
        map { optional in
            optional.flatMap {
                Just<Wrapped>.init($0)
                    .setFailureType(to: Failure.self)
                    .eraseToAnyPublisher()
            } ?? Empty<Wrapped, Self.Failure>(
                completeImmediately: true
            )
            .eraseToAnyPublisher()
        }
        .switchToLatest()
        .eraseToAnyPublisher()
    }
}
