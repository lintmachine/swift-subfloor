//
//  CancellableId.swift
//

import Combine
import Foundation

public class CancellableId: Identifiable, Hashable, Equatable, Cancellable {
    public let id: UUID
    public var wrapped: AnyCancellable?

    public init(_ id: UUID? = nil, wrapping: AnyCancellable? = nil) {
        self.id = id ?? UUID()
        wrapped = wrapping
    }

    public func cancel() {
        wrapped?.cancel()
        wrapped = nil
    }

    public static func == (lhs: CancellableId, rhs: CancellableId) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension CancellableId {
    public static let incrementing: AnySequence<CancellableId> = AnySequence(
        UUID.incrementing
            .lazy
            .compactMap { CancellableId.init($0) }
    )

    public static let unique: AnySequence<CancellableId> = AnySequence(
        UUID.unique
            .lazy
            .compactMap { CancellableId.init($0) }
    )
}
