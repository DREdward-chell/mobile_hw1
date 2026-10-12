package notes

import java.util.UUID

abstract class Note protected constructor(
    title: String,
    metadata: NoteMetadata,
) {
    val id: UUID = UUID.randomUUID()
    var title: String = title
        private set
    var metadata: NoteMetadata = metadata
        private set

    open fun display(mode: DisplayMode = DisplayMode.Full): String =
        "$title | author: ${metadata.author} | pinned: ${metadata.isPinned} | revision: ${metadata.revision}"

    abstract fun contentDescription(): String

    protected fun renderedContent(mode: DisplayMode): String = when (mode) {
        DisplayMode.Full -> contentDescription()
        is DisplayMode.Preview -> contentDescription().preview(mode.maxLength)
    }

    fun update(newTitle: String = title): Boolean {
        val preparedTitle = newTitle.trim()
        if (preparedTitle.isEmpty() || metadata.revision == Int.MAX_VALUE) return false
        normalizeContent()
        title = preparedTitle
        metadata = metadata.copy(revision = metadata.revision + 1)
        return true
    }

    protected abstract fun normalizeContent()
}
