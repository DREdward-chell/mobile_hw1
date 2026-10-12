struct NoteMetadata: Equatable {
    let author: String
    var isPinned = false
    var revision = 0
}

enum ReminderStatus: String {
    case pending
    case completed
}

enum DisplayMode {
    case full
    case preview(maxLength: Int)
}

struct ChecklistItem: Equatable {
    var text: String
    var isCompleted = false
}
