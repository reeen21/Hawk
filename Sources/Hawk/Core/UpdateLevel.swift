/**
 * An enumeration that represents the level of update required:
 * - `.major`: For significant changes.
 * - `.minor`: For new features or backward-compatible improvements.
 * - `.patch`: For bug fixes or small updates.
 */
public enum UpdateLevel: Sendable {
    case major
    case minor
    case patch
}
