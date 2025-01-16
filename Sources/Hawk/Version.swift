/**
 * Represents a semantic version with `major`, `minor`, and `patch` components.
 */
struct Version: Comparable {

    /**
     * The major version number (e.g., 2 in 2.1.3).
     */
    let major: Int

    /**
     * The minor version number (e.g., 1 in 2.1.3).
     */
    let minor: Int

    /**
     * The patch version number (e.g., 3 in 2.1.3).
     */
    let patch: Int

    /**
     * Initializes a new `Version` by parsing the given string, splitting it
     * into major, minor, and patch components.
     *
     * - Parameter versionString: A version string in the format "major.minor.patch".
     *   Missing components default to `0`.
     */
    init(_ versionString: String) {
        let components = versionString.split(separator: ".").map { Int($0) ?? 0 }
        self.major = components.count > 0 ? components[0] : 0
        self.minor = components.count > 1 ? components[1] : 0
        self.patch = components.count > 2 ? components[2] : 0
    }

    /**
     * Compares two `Version` instances by their semantic versioning rules.
     *
     * - Parameters:
     *   - lhs: The left-hand side `Version`.
     *   - rhs: The right-hand side `Version`.
     * - Returns: `true` if `lhs` is strictly less than `rhs` in semantic versioning.
     */
    static func < (lhs: Version, rhs: Version) -> Bool {
        if lhs.major != rhs.major {
            return lhs.major < rhs.major
        } else if lhs.minor != rhs.minor {
            return lhs.minor < rhs.minor
        } else {
            return lhs.patch < rhs.patch
        }
    }

    /**
     * Compares two `Version` instances by their semantic versioning rules.
     *
     * - Parameters:
     *   - lhs: The left-hand side `Version`.
     *   - rhs: The right-hand side `Version`.
     * - Returns: `true` if both `Version` instances have the same major, minor,
     *            and patch values.
     */
    static func == (lhs: Version, rhs: Version) -> Bool {
        return lhs.major == rhs.major &&
               lhs.minor == rhs.minor &&
               lhs.patch == rhs.patch
    }
}
