

import XCTest
@testable import Game512_TDD

final class Game512_TDDTests: XCTestCase {
    
    func test_gameLogicCreation() {
           let logica = GameLogic()
           XCTAssertNotNil(logica)
       }
}
