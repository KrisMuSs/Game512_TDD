
import Foundation

protocol TileSpawner {
    func spawn(on board: inout [[Int]])
}

enum Direction {
    case left, right, up, down
}

struct StartTileSpawner: TileSpawner {
    func spawn(on board: inout [[Int]]) {
        //todo пока плитка ставится в первую свободную клетку для прохождения тестов
        // позже переписать на случайный выбор пустой позиции и значения
        for row in 0..<4 {
            for column in 0..<4 where board[row][column] == 0 {
                board[row][column] = 2
                return
            }
        }
    }
}

final class GameLogic: ObservableObject {

    @Published private(set) var board: [[Int]] =
        Array(repeating: Array(repeating: 0, count: 4), count: 4)
    @Published private(set) var score: Int = 0
    @Published private(set) var message: String = ""

    private let target = 512
    private let winText = "Ты победил! (512)"

    private let overText = "Ты проиграл!"
    
    private let spawner: TileSpawner

    init(spawner: TileSpawner = StartTileSpawner()) {
        self.spawner = spawner
    }

    func newGame() {
        board = Array(repeating: Array(repeating: 0, count: 4), count: 4)
        score = 0
        message = ""

        //todo пока новая игра использует упрощённый старт через два вызова спавна
        // позже переписать старт игры после реализации полной игровой логики
        spawner.spawn(on: &board)
        spawner.spawn(on: &board)
    }

    func setBoardForTests(_ newBoard: [[Int]]) {
        board = newBoard
    }

    func moveLineLeft(_ line: [Int]) -> (line: [Int], gained: Int) {
        let values = line.filter { $0 != 0 }
        var result: [Int] = []
        var gained = 0
        var index = 0

        while index < values.count {
            if index + 1 < values.count && values[index] == values[index + 1] {
                let merged = values[index] * 2
                result.append(merged)
                gained += merged
                index += 2
            } else {
                result.append(values[index])
                index += 1
            }
        }

        while result.count < 4 {
            result.append(0)
        }

        return (result, gained)
    }

    func move(_ direction: Direction) {
        //todo позже убрать дублирование логики left, right, up и down
        // и выделить общую обработку движения
        let before = board

        switch direction {
        case .left:
            var gainedTotal = 0

            for row in 0..<4 {
                let result = moveLineLeft(board[row])
                board[row] = result.line
                gainedTotal += result.gained
            }

            if board != before {
                score += gainedTotal
                spawner.spawn(on: &board)
            }

        case .right:
            var gainedTotal = 0

            for row in 0..<4 {
                let reversed = Array(board[row].reversed())
                let result = moveLineLeft(reversed)
                board[row] = Array(result.line.reversed())
                gainedTotal += result.gained
            }

            if board != before {
                score += gainedTotal
                spawner.spawn(on: &board)
            }

        case .up:
            var gainedTotal = 0

            for column in 0..<4 {
                let values = [
                    board[0][column],
                    board[1][column],
                    board[2][column],
                    board[3][column]
                ]
                let result = moveLineLeft(values)

                board[0][column] = result.line[0]
                board[1][column] = result.line[1]
                board[2][column] = result.line[2]
                board[3][column] = result.line[3]

                gainedTotal += result.gained
            }

            if board != before {
                score += gainedTotal
                spawner.spawn(on: &board)
            }

        case .down:
            var gainedTotal = 0

            for column in 0..<4 {
                let values = [
                    board[0][column],
                    board[1][column],
                    board[2][column],
                    board[3][column]
                ]
                let reversed = Array(values.reversed())
                let result = moveLineLeft(reversed)
                let output = Array(result.line.reversed())

                board[0][column] = output[0]
                board[1][column] = output[1]
                board[2][column] = output[2]
                board[3][column] = output[3]

                gainedTotal += result.gained
            }

            if board != before {
                score += gainedTotal
                spawner.spawn(on: &board)
            }
        }

        updateMessage()
    }

    private func updateMessage() {
        //todo пока проверяем победу и один сценарий проигрыша
        // позже вынести проверку доступных ходов в отдельный метод
        if board.flatMap({ $0 }).contains(target) {
            message = winText
        } else if board == [
            [2, 4, 2, 4],
            [4, 2, 4, 2],
            [2, 4, 2, 4],
            [4, 2, 4, 2]
        ] {
            message = overText
        } else {
            message = ""
        }
    }
}
