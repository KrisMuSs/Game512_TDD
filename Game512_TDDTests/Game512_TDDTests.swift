
import XCTest
@testable import Game512_TDD


final class Game512_TDDTests: XCTestCase {
    
    func test_gameLogicCreation() {
           let logica = GameLogic()
           XCTAssertNotNil(logica, "GameLogic не создаётся")
       }
    
    func test_boardExists() {
           let logica = GameLogic()
           XCTAssertEqual(logica.board.count, 4, "В поле должно быть 4 строки")
    }
    
    func test_scoreStartsFromZero() {
        let logica = GameLogic()
        XCTAssertEqual(logica.score, 0, "Начальный счёт должен быть 0")
    }
    
    func test_newGameResetsScore() {
        let logica = GameLogic()
        logica.newGame()
        XCTAssertEqual(logica.score, 0, "newGame() должен сбрасывать счёт")
    }
    
    func test_newGameClearMessage() {
        let logica = GameLogic()
        logica.newGame()
        XCTAssertEqual(logica.message, "", "newGame() должен очищать сообщение")
    }
    
    func test_newGameClearsBoard() {
        let logica = GameLogic()
        logica.newGame()

        XCTAssertEqual(
            logica.board,
            [
                [0, 0, 0, 0],
                [0, 0, 0, 0],
                [0, 0, 0, 0],
                [0, 0, 0, 0]
            ],
            "После newGame() поле должно быть очищено"
        )
    }
    
    func test_newGameAddTwoStartTiles() {
        
        let logic = GameLogic()

        logic.newGame()

        var count = 0

        for row in logic.board {
            for value in row {
                if value != 0 {
                    count += 1
                }
            }
        }

        XCTAssertEqual(count, 2, "После newGame() должно быть две плитки")
    }
    
    func test_moveLineLeft() {
        let logic = GameLogic()

        let result = logic.moveLineLeft([0, 2, 0, 4])

        XCTAssertEqual(result.line, [2, 4, 0, 0], "Строка должна сдвигаться влево")
    }
    
    func test_moveLineLeftMerges() {
        let logic = GameLogic()

        let result = logic.moveLineLeft([2, 2, 0, 0])

        XCTAssertEqual(result.line, [4, 0, 0, 0], "Одинаковые плитки должны сливаться")
    }
    
    
    func test_moveLineLeftPoints() {
        let logic = GameLogic()

        let result = logic.moveLineLeft([2, 2, 0, 0])

        XCTAssertEqual(result.gained, 4, "За слияние двух двоек должно начисляться 4 очка")
    }
    
    func test_moveLineLeftMerge2() {
        let sut = GameLogic()

        let result = sut.moveLineLeft([2, 2, 2, 0])

        XCTAssertEqual(result.line, [4, 2, 0, 0], "Плитка не должна сливаться дважды за один ход")
    }
    
    
    func test_moveLeftButton() {
        let logic = GameLogic()
        logic.setBoardForTests([
            [0, 2, 0, 4],
            [0, 0, 0, 0],
            [0, 0, 0, 0],
            [0, 0, 0, 0]
        ])

        logic.move(.left)

        XCTAssertEqual(
            logic.board[0],
            [2, 4, 0, 0],
            "Ход влево должен сдвигать первую строку"
        )
    }
    
    func test_moveRightButton() {
        let logic = GameLogic()
        logic.setBoardForTests([
            [2, 0, 4, 0],
            [0, 0, 0, 0],
            [0, 0, 0, 0],
            [0, 0, 0, 0]
        ])

        logic.move(.right)

        XCTAssertEqual(
            logic.board[0],
            [0, 0, 2, 4],
            "Ход вправо должен сдвигать первую строку"
        )
    }
    
    func test_moveUpButton() {
        let logic = GameLogic()
        logic.setBoardForTests([
            [0, 0, 0, 0],
            [2, 0, 0, 0],
            [0, 0, 0, 0],
            [4, 0, 0, 0]
        ])

        logic.move(.up)

        XCTAssertEqual(
            logic.board,
            [
                [2, 0, 0, 0],
                [4, 0, 0, 0],
                [0, 0, 0, 0],
                [0, 0, 0, 0]
            ],
            "Ход вверх должен сдвигать первый столбец"
        )
    }
    
    
    
    func test_moveDownButton() {
        let logic = GameLogic()
        logic.setBoardForTests([
            [2, 0, 0, 0],
            [0, 0, 0, 0],
            [4, 0, 0, 0],
            [0, 0, 0, 0]
        ])

        logic.move(.down)

        XCTAssertEqual(
            logic.board,
            [
                [0, 0, 0, 0],
                [0, 0, 0, 0],
                [2, 0, 0, 0],
                [4, 0, 0, 0]
            ],
            "Ход вниз должен сдвигать первый столбец"
        )
    }
    
    func test_WinMessage() {
        let sut = GameLogic()
        sut.setBoardForTests([
            [512, 0, 0, 0],
            [0,   0, 0, 0],
            [0,   0, 0, 0],
            [0,   0, 0, 0]
        ])

        sut.move(.left)

        XCTAssertEqual(sut.message, "Ты победил! (512)", "Если на поле есть 512, должно появиться сообщение о победе")
    }
    
}



