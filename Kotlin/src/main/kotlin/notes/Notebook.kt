package notes

import java.util.UUID

class Notebook {
    private val notes = mutableListOf<Note>()

    fun add(note: Note): Boolean {
        if (findById(note.id) != null) return false
        notes.add(note)
        return true
    }

    fun remove(id: UUID): Note? {
        val index = notes.indexOfFirst { it.id == id }
        return if (index >= 0) notes.removeAt(index) else null
    }

    fun all(): List<Note> = notes.toList()

    fun findById(id: UUID): Note? = notes.find { it.id == id }

    fun filter(predicate: (Note) -> Boolean): List<Note> = notes.filter(predicate)

    fun sorted(comparator: Comparator<Note>): List<Note> = notes.sortedWith(comparator)

    fun first(predicate: (Note) -> Boolean): Note? = notes.firstOrNull(predicate)

    fun display(mode: DisplayMode = DisplayMode.Full): String =
        notes.joinToString("\n\n") { it.display(mode) }
}
