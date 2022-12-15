import Combine

public extension Publishers {
    struct MissingOutputError: Error {}
}

public extension Publisher {
    func singleOutput() async throws -> Output {
        var cancellable: AnyCancellable?
        var didReceiveValue = false

        return try await withCheckedThrowingContinuation { continuation in
            cancellable = sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    case .finished:
                        if !didReceiveValue {
                            continuation.resume(
                                throwing: Publishers.MissingOutputError()
                            )
                        }
                    }
                },
                receiveValue: { value in
                    guard !didReceiveValue else { return }

                    didReceiveValue = true
                    cancellable?.cancel()
                    continuation.resume(returning: value)
                }
            )
        }
    }
}

public extension Publisher {
    func firstOutput() async throws -> Output {
        for try await output in values {
            // Since we're immediately returning upon receiving
            // the first output value, that'll cancel our
            // subscription to the current publisher:
            return output
        }

        throw Publishers.MissingOutputError()
    }
}
