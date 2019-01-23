import App
import Vapor

do {
    try app(.detect()).run()
} catch {
    print("Failed to start: \(error)")
}

