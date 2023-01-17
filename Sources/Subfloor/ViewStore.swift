import Foundation
import ComposableArchitecture
import SwiftUI

public extension ViewStore {
    /// Creates a binding by projecting the current optional value to a boolean describing if it's
    /// non-`nil`.
    ///
    /// Writing `false` to the binding will `nil` out the base value. Writing `true` does nothing.
    ///
    /// - Returns: A binding to a boolean. Returns `true` if non-`nil`, otherwise `false`.
    func isPresent<Wrapped>() -> Binding<Bool>
        where ViewState == Wrapped? {
        .init(
            get: { self.state != nil },
            set: { isPresent, transaction in }
        )
    }
}
