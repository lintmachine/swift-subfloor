import Foundation

public extension Foundation.UUID {
    init?(index: Int) {
        let uuidString = "00000000-0000-0000-0000-\(String(format: "%012d", index))"
        self.init(
            uuidString: uuidString
        )!
    }

    static var unique: AnySequence<Foundation.UUID> {
        AnySequence(
            sequence(state: ()) { _ in
                Foundation.UUID()
            }
        )
    }

    static var incrementing: AnySequence<Foundation.UUID> {
        AnySequence(
            sequence(
                state: 0,
                next: { (count: inout Int) -> Foundation.UUID? in
                    defer { count += 1 }
                    return Foundation.UUID(index: count)
                }
            )
        )
    }
}
