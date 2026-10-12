import Foundation

final class Notebook {
    private var notes: [Note] = []

    @discardableResult
    func add(_ note: Note) -> Bool {
        guard findById(note.id) == nil else { return false }
        notes.append(note)
        return true
    }

    @discardableResult
    func remove(_ id: UUID) -> Note? {
        guard let index = notes.firstIndex(where: { $0.id == id }) else { return nil }
        return notes.remove(at: index)
    }

    func all() -> [Note] { notes }

    func findById(_ id: UUID) -> Note? { notes.first { $0.id == id } }

    func filter(_ predicate: (Note) -> Bool) -> [Note] { notes.filter(predicate) }

    func sorted(by areInIncreasingOrder: (Note, Note) -> Bool) -> [Note] {
        notes.sorted(by: areInIncreasingOrder)
    }

    func first(_ predicate: (Note) -> Bool) -> Note? { notes.first(where: predicate) }

    func display(mode: DisplayMode = .full) -> String {
        notes.map { $0.display(mode: mode) }.joined(separator: "\n\n")
    }
}
