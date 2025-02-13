import XCTest
@testable import Hawk

final class AppVersionCheckerTest: XCTestCase {
    /**
     * This test checks if the `checkIsNeedForceUpdate` function returns false
     * when both the local and store versions are the same.
     *
     * AAA Steps:
     * - Arrange: Prepare equal versions for local and store.
     * - Act: Call the function with all level.
     * - Assert: Verify that the result is false.
     */
    func testNeedsForceUpdate_sameVersion_returnFalse() async {
        // Arrange
        let localVersionMock = "1.0.0"
        let storeVersionMock = "1.0.0"

        // Act
        let result = await Hawk.checkIsNeedForceUpdate(
            level: .patch,
            localVersion: localVersionMock,
            storeVersion: storeVersionMock
        )

        // Assert
        XCTAssertFalse(result)

        // Arrange
        let localVersionMock2 = "1.1.0"
        let storeVersionMock2 = "1.1.0"

        // Act
        let result2 = await Hawk.checkIsNeedForceUpdate(
            level: .minor,
            localVersion: localVersionMock2,
            storeVersion: storeVersionMock2
        )

        // Assert
        XCTAssertFalse(result2)

        // Arrange
        let localVersionMock3 = "1.1.0"
        let storeVersionMock3 = "1.1.0"

        // Act
        let result3 = await Hawk.checkIsNeedForceUpdate(
            level: .major,
            localVersion: localVersionMock3,
            storeVersion: storeVersionMock3
        )

        // Assert
        XCTAssertFalse(result3)
    }

    /**
     * This test checks if the `checkIsNeedForceUpdate` function returns true
     * when the store version is higher by a minor level than the local version.
     *
     * AAA Steps:
     * - Arrange: Prepare localVersionMock = "1.0.0" and storeVersionMock = "1.2.0".
     * - Act: Call the function with the `minor` level.
     * - Assert: Verify that the result is true.
     *
     * - Arrange #2: localVersionMock2 = "1.4.0", storeVersionMock2 = "2.0.0".
     * - Act #2: Call the function with the `minor` level.
     * - Assert #2: Verify that the result is false.
     */
    func testNeedsForceUpdate_minor_returnTrue() async {
        // Arrange
        let localVersionMock = "1.0.0"
        let storeVersionMock = "1.2.0"

        // Act
        let result = await Hawk.checkIsNeedForceUpdate(
            level: .minor,
            localVersion: localVersionMock,
            storeVersion: storeVersionMock
        )

        // Assert
        XCTAssertTrue(result)

        // Arrange
        let localVersionMock2 = "1.4.0"
        let storeVersionMock2 = "2.0.0"

        // Act
        let result2 = await Hawk.checkIsNeedForceUpdate(
            level: .minor,
            localVersion: localVersionMock2,
            storeVersion: storeVersionMock2
        )

        // Assert
        XCTAssertTrue(result2)
    }

    /**
     * This test checks if the `checkIsNeedForceUpdate` function returns false
     * when the local version is not lower by a minor level than the store version.
     *
     * AAA Steps:
     * - Arrange #1: localVersionMock = "1.0.3", storeVersionMock = "1.0.0".
     * - Act #1: Call the function with the `minor` level.
     * - Assert #1: Verify that the result is false.
     */
    func testNeedsForceUpdate_minor_returnFalse() async {
        // Arrange
        let localVersionMock = "1.0.3"
        let storeVersionMock = "1.0.0"

        // Act
        let result = await Hawk.checkIsNeedForceUpdate(
            level: .minor,
            localVersion: localVersionMock,
            storeVersion: storeVersionMock
        )

        // Assert
        XCTAssertFalse(result)
    }

    /**
     * This test checks if the `checkIsNeedForceUpdate` function returns true
     * when the store version is higher by a major level than the local version.
     *
     * AAA Steps:
     * - Arrange: Prepare localVersionMock = "1.0.0" and storeVersionMock = "2.0.0".
     * - Act: Call the function with the `major` level.
     * - Assert: Verify that the result is true.
     */
    func testNeedsForceUpdate_major_returnTrue() async {
        // Arrange
        let localVersionMock = "1.0.0"
        let storeVersionMock = "2.0.0"

        // Act
        let result = await Hawk.checkIsNeedForceUpdate(
            level: .major,
            localVersion: localVersionMock,
            storeVersion: storeVersionMock
        )

        // Assert
        XCTAssertTrue(result)
    }

    /**
     * This test checks if the `checkIsNeedForceUpdate` function returns false
     * when the local version is higher by a major level, but it also verifies
     * the condition where the store version is higher by a major level.
     *
     * AAA Steps:
     * - Arrange #1: localVersionMock = "2.0.0", storeVersionMock = "1.0.0".
     * - Act #1: Call the function with the `major` level.
     * - Assert #1: Verify that the result is false.
     *
     * - Arrange #2: localVersionMock2 = "1.0.0", storeVersionMock2 = "1.4.0".
     * - Act #2: Call the function with the `major` level.
     * - Assert #2: Verify that the result is false.
     */
    func testNeedsForceUpdate_major_returnFalse() async {
        // Arrange
        let localVersionMock = "2.0.0"
        let storeVersionMock = "1.0.0"

        // Act
        let result = await Hawk.checkIsNeedForceUpdate(
            level: .major,
            localVersion: localVersionMock,
            storeVersion: storeVersionMock
        )

        // Assert
        XCTAssertFalse(result)

        // Arrange
        let localVersionMock2 = "1.0.0"
        let storeVersionMock2 = "1.4.0"

        // Act
        let result2 = await Hawk.checkIsNeedForceUpdate(
            level: .major,
            localVersion: localVersionMock2,
            storeVersion: storeVersionMock2
        )

        // Assert
        XCTAssertFalse(result2)
    }
}
