import ComposableArchitecture
import Foundation

/// Composable Feature for managing the mutations of an `IdentifiedArray.State`.
/// Note: Requires that `IdentifiedArray.Element` conform to `Equatable`.
struct IdentifiedArrayReducer<Element>: ReducerProtocol where
    Element: Equatable,
    Element: Identifiable
{
    public typealias State = IdentifiedArrayOf<Element>
        
    public enum Action: Equatable {
        case append(Element)
        case insert(Element, position: Int)
        case remove(id: Element.ID)
        case removeAt(position: Int)
        case removeAll
        case reverse
        case shuffle
    }

    /// A `Reducer` implementation providing list-editing behavior for
    /// an `IdentifiedArray.State`
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case let .append(element):
                state.insert(element, at: state.count)
            case let .insert(element, position):
                state.insert(element, at: position)
            case let .remove(id):
                state.remove(id: id)
            case let .removeAt(position):
                state.remove(at: position)
            case .removeAll:
                state.removeAll(where: { _ in true })
            case .reverse:
                state.reverse()
            case .shuffle:
                state.shuffle()
            }

            return .none
        }
    }
}
