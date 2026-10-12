package notes

class TextNote(
    title: String,
    metadata: NoteMetadata,
    text: String,
) : Note(title, metadata) {
    var text: String = text
        private set

    override fun contentDescription(): String = text

    override fun display(mode: DisplayMode): String =
        "[Text] ${super.display(mode)}\n${renderedContent(mode)}"

    override fun normalizeContent() {
        text = text.trim()
    }
}
