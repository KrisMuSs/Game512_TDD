
import Foundation

final class GameLogic: ObservableObject {
    //todo временно задали поле вручную, позже переделать логику инициализации
    @Published private(set) var board: [[Int]] = [
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0]
    ]
}
