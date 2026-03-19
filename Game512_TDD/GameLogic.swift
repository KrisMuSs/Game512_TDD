
import Foundation

protocol TileSpawner {
    func spawn(on board: inout [[Int]])
}

enum Direction {
    case left, right, up, down
}

struct RandomTileSpawner: TileSpawner {
    func spawn(on board: inout [[Int]]) {

        var emptyCells: [(row: Int, column: Int)] = []

        for row in 0..<4 {
            for column in 0..<4 where board[row][column] == 0 {
                emptyCells.append((row, column))
            }
        }

        guard let position = emptyCells.randomElement() else {
            return
        }

        let value = Int.random(in: 0..<10) == 0 ? 4 : 2
        board[position.row][position.column] = value
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

    private var isFinished: Bool {
        message == winText || message == overText
    }

    private let spawner: TileSpawner

    init(spawner: TileSpawner = RandomTileSpawner()) {
        self.spawner = spawner
    }

    func newGame() {
        board = Array(repeating: Array(repeating: 0, count: 4), count: 4)
        score = 0
        message = ""


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

    private func moveLineRight(_ line: [Int]) -> (line: [Int], gained: Int) {
        let reversed = Array(line.reversed())
        let result = moveLineLeft(reversed)
        return (Array(result.line.reversed()), result.gained)
    }

    private func getColumn(_ index: Int) -> [Int] {
        [
            board[0][index],
            board[1][index],
            board[2][index],
            board[3][index]
        ]
    }

    private func setColumn(_ index: Int, values: [Int]) {
        board[0][index] = values[0]
        board[1][index] = values[1]
        board[2][index] = values[2]
        board[3][index] = values[3]
    }

    func move(_ direction: Direction) {
        if isFinished {
            return
        }

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
                let result = moveLineRight(board[row])
                board[row] = result.line
                gainedTotal += result.gained
            }

            if board != before {
                score += gainedTotal
                spawner.spawn(on: &board)
            }

        case .up:
            var gainedTotal = 0

            for column in 0..<4 {
                let result = moveLineLeft(getColumn(column))
                setColumn(column, values: result.line)
                gainedTotal += result.gained
            }

            if board != before {
                score += gainedTotal
                spawner.spawn(on: &board)
            }

        case .down:
            var gainedTotal = 0

            for column in 0..<4 {
                let result = moveLineRight(getColumn(column))
                setColumn(column, values: result.line)
                gainedTotal += result.gained
            }

            if board != before {
                score += gainedTotal
                spawner.spawn(on: &board)
            }
        }

        updateMessage()
    }

    private func hasMoves() -> Bool {
        if board.flatMap({ $0 }).contains(0) {
            return true
        }

        for row in 0..<4 {
            for column in 0..<4 {
                let value = board[row][column]

                if column + 1 < 4, board[row][column + 1] == value {
                    return true
                }

                if row + 1 < 4, board[row + 1][column] == value {
                    return true
                }
            }
        }

        return false
    }

    private func updateMessage() {
        if board.flatMap({ $0 }).contains(target) {
            message = winText
        } else if hasMoves() == false {
            message = overText
        } else {
            message = ""
        }
    }
}
