import Foundation

struct Console: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let host: String
    let port: UInt16
    let isPS5: Bool

    init?(info: [AnyHashable: Any]) {
        guard
            let name = info["name"] as? String,
            let host = info["host"] as? String
        else { return nil }
        self.name = name
        self.host = host
        self.port = UInt16(truncating: (info["port"] as? NSNumber) ?? 9295)
        self.isPS5 = (info["isPS5"] as? NSNumber)?.boolValue ?? false
    }

    static func == (lhs: Console, rhs: Console) -> Bool {
        lhs.host == rhs.host
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(host)
    }
}
