package notes

class ChecklistNote(
    title: String,
    metadata: NoteMetadata,
    items: List<ChecklistItem>,
) : Note(title, metadata) {
    private var entries = items.toList()
    val items: List<ChecklistItem>
        get() = entries.toList()

    fun completeItem(index: Int): Boolean {
        if (index !in entries.indices) return false
        entries = entries.mapIndexed { itemIndex, item ->
            if (itemIndex == index) item.copy(isCompleted = true) else item
        }
        return true
    }

    override fun contentDescription(): String = entries.joinToString("\n") {
        "[${if (it.isCompleted) "x" else " "}] ${it.text}"
    }

    override fun display(mode: DisplayMode): String =
        "[Checklist] ${super.display(mode)}\n${renderedContent(mode)}"

    override fun normalizeContent() {
        entries = entries.map { it.copy(text = it.text.trim()) }
    }
}
