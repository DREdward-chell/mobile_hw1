package notes

data class NoteMetadata(
    val author: String,
    val isPinned: Boolean = false,
    val revision: Int = 0,
)

enum class ReminderStatus(val label: String) {
    PENDING("pending"),
    COMPLETED("completed"),
}

sealed interface DisplayMode {
    data object Full : DisplayMode
    data class Preview(val maxLength: Int) : DisplayMode
}

data class ChecklistItem(val text: String, val isCompleted: Boolean = false)
