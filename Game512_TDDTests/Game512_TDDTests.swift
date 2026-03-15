
import XCTest
@testable import Game512_TDD

final class Game512_TDDTests: XCTestCase {
    
    func test_gameLogicCreation() {
           let logica = GameLogic()
           XCTAssertNotNil(logica)
       }
    
    func test_boardExists() {
           let logica = GameLogic()
           XCTAssertEqual(logica.board.count, 4)
    }
    
    func test_scoreStartsFromZero() {
        let logica = GameLogic()
        XCTAssertEqual(logica.score, 0)
    }
    
    func test_newGameCreation() {
        let logica = GameLogic()
        logica.newGame()
        XCTAssertNotNil(logica)
    }
    
}



