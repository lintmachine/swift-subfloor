import ComposableArchitecture
import SwiftUI
import SwiftUINavigation

#if canImport(UIKit)
    import UIKit
#elseif canImport(AppKit)
    import AppKit
#endif

public extension View {
    /// Presents a sheet using a binding as a data source for the sheet's content.
    ///
    /// SwiftUI comes with a `sheet(item:)` view modifier that is powered by a binding to some
    /// hashable state. When this state becomes non-`nil`, it passes an unwrapped value to the content
    /// closure. This value, however, is completely static, which prevents the sheet from modifying
    /// it.
    ///
    /// This overload differs in that it passes a _binding_ to the content closure, instead. This
    /// gives the sheet the ability to write changes back to its source of truth.
    ///
    /// Also unlike `sheet(item:)`, the binding's value does _not_ need to be hashable.
    ///
    /// ```swift
    /// struct TimelineView: View {
    ///   @State var draft: Post?
    ///
    ///   var body: Body {
    ///     Button("Compose") {
    ///       self.draft = Post()
    ///     }
    ///     .sheet(unwrapping: self.$draft) { $draft in
    ///       ComposeView(post: $draft, onSubmit: { ... })
    ///     }
    ///   }
    /// }
    ///
    /// struct ComposeView: View {
    ///   @Binding var post: Post
    ///   var body: some View { ... }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - value: A binding to an optional source of truth for the sheet. When `value` is non-`nil`,
    ///     a non-optional binding to the value is passed to the `content` closure. You use this
    ///     binding to produce content that the system presents to the user in a sheet. Changes made
    ///     to the sheet's binding will be reflected back in the source of truth. Likewise, changes
    ///     to `value` are instantly reflected in the sheet. If `value` becomes `nil`, the sheet is
    ///     dismissed.
    ///   - onDismiss: The closure to execute when dismissing the sheet.
    ///   - content: A closure returning the content of the sheet.
    @MainActor  func sheet<State, Action, Content>(
        unwrapping store: Store<State?, Action>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Store<State, Action>) -> Content
    ) -> some View
        where Content: View, State: Equatable {
        IfLetStore(store) {
            content($0)
        }
    }

    @MainActor  func sheet<State, Action, CaseState, CaseAction, Content>(
        unwrapping store: Store<State?, Action>,
        case stateCase: CasePath<State, CaseState>,
        action actionCase: CasePath<Action, CaseAction>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder content: @escaping (Store<CaseState, CaseAction>) -> Content
    ) -> some View
        where Content: View, State: Equatable, CaseState: Equatable {
        IfLetStore(store) { store in
            IfLetStore(
                store.scope(
                    state: stateCase.extract(from:),
                    action: actionCase.embed(_:)
                )
            ) {
                self.sheet(
                    unwrapping: $0,
                    onDismiss: onDismiss,
                    content: content
                )
            }
        }
    }
}
