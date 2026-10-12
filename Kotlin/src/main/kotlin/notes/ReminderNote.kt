package notes

class ReminderNote(
    title: String,
    metadata: NoteMetadata,
    text: String,
    status: ReminderStatus = ReminderStatus.PENDING,
) : Note(title, metadata) {
    var text: String = text
        private set
    var status: ReminderStatus = status
        private set

    fun complete() {
        status = ReminderStatus.COMPLETED
    }

    override fun contentDescription(): String = text

    override fun display(mode: DisplayMode): String =
        "[Reminder] ${super.display(mode)}\nStatus: ${status.label}\n${renderedContent(mode)}"

    override fun normalizeContent() {
        text = text.trim()
    }
}
