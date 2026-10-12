import Foundation

class Note {
    let id = UUID()
    private(set) var title: String
    private(set) var metadata: NoteMetadata

    fileprivate init(title: String, metadata: NoteMetadata) {
        self.title = title
        self.metadata = metadata
    }

    func display(mode: DisplayMode = .full) -> String {
        "\(title) | author: \(metadata.author) | pinned: \(metadata.isPinned) | revision: \(metadata.revision)"
    }

    func contentDescription() -> String {
        preconditionFailure("Наследник Note должен реализовать contentDescription()")
    }

    fileprivate final func renderedContent(mode: DisplayMode) -> String {
        switch mode {
        case .full:
            return contentDescription()
        case .preview(let maxLength):
            return contentDescription().preview(maxLength: maxLength)
        }
    }

    @discardableResult
    final func update(newTitle: String? = nil) -> Bool {
        let preparedTitle = (newTitle ?? title).trimmingCharacters(in: .whitespacesAndNewlines)
        guard !preparedTitle.isEmpty, metadata.revision < Int.max else { return false }
        normalizeContent()
        title = preparedTitle
        metadata.revision += 1
        return true
    }

    fileprivate func normalizeContent() {
        preconditionFailure("Наследник Note должен реализовать normalizeContent()")
    }
}

final class TextNote: Note {
    private(set) var text: String

    init(title: String, metadata: NoteMetadata, text: String) {
        self.text = text
        super.init(title: title, metadata: metadata)
    }

    override func contentDescription() -> String { text }

    override func display(mode: DisplayMode = .full) -> String {
        "[Text] \(super.display(mode: mode))\n\(renderedContent(mode: mode))"
    }

    fileprivate override func normalizeContent() {
        text = text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

final class ReminderNote: Note {
    private(set) var text: String
    private(set) var status: ReminderStatus

    init(title: String, metadata: NoteMetadata, text: String, status: ReminderStatus = .pending) {
        self.text = text
        self.status = status
        super.init(title: title, metadata: metadata)
    }

    func complete() {
        status = .completed
    }

    override func contentDescription() -> String { text }

    override func display(mode: DisplayMode = .full) -> String {
        "[Reminder] \(super.display(mode: mode))\nStatus: \(status.rawValue)\n\(renderedContent(mode: mode))"
    }

    fileprivate override func normalizeContent() {
        text = text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

final class ChecklistNote: Note {
    private(set) var items: [ChecklistItem]

    init(title: String, metadata: NoteMetadata, items: [ChecklistItem]) {
        self.items = items
        super.init(title: title, metadata: metadata)
    }

    @discardableResult
    func completeItem(at index: Int) -> Bool {
        guard items.indices.contains(index) else { return false }
        items[index].isCompleted = true
        return true
    }

    override func contentDescription() -> String {
        items.map { "[\($0.isCompleted ? "x" : " ")] \($0.text)" }.joined(separator: "\n")
    }

    override func display(mode: DisplayMode = .full) -> String {
        "[Checklist] \(super.display(mode: mode))\n\(renderedContent(mode: mode))"
    }

    fileprivate override func normalizeContent() {
        items = items.map { item in
            var normalized = item
            normalized.text = item.text.trimmingCharacters(in: .whitespacesAndNewlines)
            return normalized
        }
    }
}
