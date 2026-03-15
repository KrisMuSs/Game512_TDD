
import Foundation

protocol TileSpawner {
    func spawn(on board: inout [[Int]])
}

struct StartTileSpawner: TileSpawner {
    func spawn(on board: inout [[Int]]) {
        //todo временная реализация. ставим 2 в первую свободную клетку
        // позже заменить на случайный спавн плитки
        for r in 0..<4 {
            for c in 0..<4 where board[r][c] == 0 {
                board[r][c] = 2
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
}
