struct Version: Comparable {
    let major: Int
    let minor: Int
    let patch: Int

    init(_ versionString: String) {
        let components = versionString.split(separator: ".").map { Int($0) ?? 0 }
        self.major = components.count > 0 ? components[0] : 0
        self.minor = components.count > 1 ? components[1] : 0
        self.patch = components.count > 2 ? components[2] : 0
    }

    static func < (lhs: Version, rhs: Version) -> Bool {
        if lhs.major != rhs.major {
            return lhs.major < rhs.major
        } else if lhs.minor != rhs.minor {
            return lhs.minor < rhs.minor
        } else {
            return lhs.patch < rhs.patch
        }
    }

    static func == (lhs: Version, rhs: Version) -> Bool {
        return lhs.major == rhs.major &&
        lhs.minor == rhs.minor &&
        lhs.patch == rhs.patch
    }
}
