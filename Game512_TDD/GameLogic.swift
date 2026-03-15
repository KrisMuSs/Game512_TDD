
import Foundation

protocol TileSpawner {
    func spawn(on board: inout [[Int]])
}

struct StartTileSpawner: TileSpawner {
    func spawn(on board: inout [[Int]]) {
        //todo пока используется упрощённый спавн для прохождения тестов
        // позже заменить на случайный выбор позиции и значения плитки
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
    
    private let spawner: TileSpawner

    init(spawner: TileSpawner = StartTileSpawner()){
           self.spawner = spawner
       }
    
    func newGame() {
        board = Array(repeating: Array(repeating: 0, count: 4), count: 4)
        message = ""
        score = 0
        
        //todo пока новая игра только очищает состояние и вызывает спавн
        //позже добавить нормальную стартовую расстановку плиток
        spawner.spawn(on: &board)
        spawner.spawn(on: &board)
        
    }
    
    func moveLineLeft(_ line: [Int]) -> (line: [Int], gained: Int) {
        var values = line.filter { $0 != 0 }
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
    
    
    
}
