package notes

import java.util.UUID

fun main() {
    val notebook = Notebook()
    val metadata = NoteMetadata(author = "Анна")
    val lecture = TextNote(
        title = "Лекция",
        metadata = metadata.copy(isPinned = true),
        text = "  Наследование позволяет разделить общее и специальное поведение.  ",
    )
    val reminder = ReminderNote(
        title = "Домашнее задание",
        metadata = metadata.copy(),
        text = "  Сдать решение через Pull Request.  ",
    )
    val checklist = ChecklistNote(
        title = "Подготовка",
        metadata = metadata.copy(),
        items = listOf(
            ChecklistItem("  Проверить Kotlin  "),
            ChecklistItem("  Проверить Swift  "),
        ),
    )
    val draft = TextNote(
        title = "Черновик",
        metadata = metadata.copy(),
        text = "Временная заметка",
    )

    listOf(lecture, reminder, checklist, draft).forEach { notebook.add(it) }

    println("Блокнот — демонстрация возможностей")
    showNotes(notebook, lecture)
    showSearch(notebook, lecture.id)
    showCollections(notebook)
    showUpdates(notebook, lecture, reminder, checklist)
    showRemoval(notebook, draft.id)
}

private fun showNotes(notebook: Notebook, existingNote: Note) {
    printSection("Все заметки")
    println(notebook.display())

    val duplicateAdded = notebook.add(existingNote)
    println("\nПовторное добавление: ${if (duplicateAdded) "выполнено" else "отклонено — заметка уже есть"}")
}

private fun showSearch(notebook: Notebook, existingId: UUID) {
    printSection("Поиск по идентификатору")
    val existingTitle = notebook.findById(existingId)?.title ?: "не найдена"
    val missingTitle = notebook.findById(UUID.randomUUID())?.title ?: "не найдена"

    println("Существующая заметка: $existingTitle")
    println("Несуществующая заметка: $missingTitle")
}

private fun showCollections(notebook: Notebook) {
    printSection("Операции с коллекциями")
    val pinnedTitles = notebook.filter { it.metadata.isPinned }.joinToString { it.title }
    val sortedTitles = notebook.sorted(compareBy { it.title }).joinToString { it.title }
    val annaNote = notebook.first { it.metadata.author == "Анна" }
    val borisNote = notebook.first { it.metadata.author == "Борис" }

    println("Всего заметок: ${notebook.all().size}")
    println("Закреплённые: ${pinnedTitles.ifEmpty { "нет" }}")
    println("По названию: $sortedTitles")
    println("Первая заметка Анны: ${annaNote?.title ?: "не найдена"}")
    println("Первая заметка Бориса: ${borisNote?.title ?: "не найдена"}")
}

private fun showUpdates(
    notebook: Notebook,
    lecture: TextNote,
    reminder: ReminderNote,
    checklist: ChecklistNote,
) {
    printSection("Обновление и предпросмотр")
    notebook.all().forEach { it.update() }
    val emptyTitleAccepted = lecture.update("   ")
    reminder.complete()
    checklist.completeItem(0)

    println("Пустое название: ${if (emptyTitleAccepted) "принято" else "отклонено"}")
    println("Предпросмотр содержимого (до 24 символов):")
    println(notebook.display(DisplayMode.Preview(maxLength = 24)))
}

private fun showRemoval(notebook: Notebook, draftId: UUID) {
    printSection("Удаление заметки")
    val removedTitle = notebook.remove(draftId)?.title ?: "не найдена"
    val repeatedRemoval = notebook.remove(draftId)?.title ?: "заметка уже отсутствует"

    println("Удалена: $removedTitle")
    println("Повторное удаление: $repeatedRemoval")
    println("Осталось заметок: ${notebook.all().size}")
}

private fun printSection(title: String) {
    println("\n=== $title ===")
}
