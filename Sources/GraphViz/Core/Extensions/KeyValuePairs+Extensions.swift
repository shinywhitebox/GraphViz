#if hasAttribute(retroactive)
extension KeyValuePairs: @retroactive Equatable where Key: Equatable, Value: Equatable {}
#else
extension KeyValuePairs: Equatable where Key: Equatable, Value: Equatable {}
#endif
extension KeyValuePairs where Key: Equatable, Value: Equatable {
    public static func == (lhs: KeyValuePairs<Key, Value>, rhs: KeyValuePairs<Key, Value>) -> Bool {
        guard lhs.count == rhs.count else { return false }
        for (l, r) in zip(lhs, rhs) {
            guard l.key == r.key, l.value == r.value else { return false }
        }

        return true
    }
}

#if hasAttribute(retroactive)
extension KeyValuePairs: @retroactive Hashable where Key: Hashable, Value: Hashable {}
#else
extension KeyValuePairs: Hashable where Key: Hashable, Value: Hashable {}
#endif
extension KeyValuePairs where Key: Hashable, Value: Hashable {
    public func hash(into hasher: inout Hasher) {
        for (key, value) in self {
            hasher.combine(key)
            hasher.combine(value)
        }
    }
}
