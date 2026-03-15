
import Foundation

final class GameLogic: ObservableObject {

    @Published private(set) var board: [[Int]] =
        Array(repeating: Array(repeating: 0, count: 4), count: 4)

    @Published private(set) var score: Int = 0
    @Published private(set) var message: String = ""
    
    
    func newGame() {
            //todo пока сбрасываем только счёт и сообщение, позже добавить очистку поля
            message = ""
            score = 0
            }
}
