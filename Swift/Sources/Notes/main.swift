import Foundation

private func runDemo() {
    let notebook = Notebook()
    let metadata = NoteMetadata(author: "Анна")
    var pinnedMetadata = metadata
    pinnedMetadata.isPinned = true

    let lecture = TextNote(
        title: "Лекция",
        metadata: pinnedMetadata,
        text: "  Наследование позволяет разделить общее и специальное поведение.  "
    )
    let reminder = ReminderNote(
        title: "Домашнее задание",
        metadata: metadata,
        text: "  Сдать решение через Pull Request.  "
    )
    let checklist = ChecklistNote(
        title: "Подготовка",
        metadata: metadata,
        items: [
            ChecklistItem(text: "  Проверить Kotlin  "),
            ChecklistItem(text: "  Проверить Swift  ")
        ]
    )
    let draft = TextNote(
        title: "Черновик",
        metadata: metadata,
        text: "Временная заметка"
    )

    let initialNotes: [Note] = [lecture, reminder, checklist, draft]
    initialNotes.forEach { notebook.add($0) }

    print("Блокнот — демонстрация возможностей")
    showNotes(notebook, existingNote: lecture)
    showSearch(notebook, existingId: lecture.id)
    showCollections(notebook)
    showUpdates(notebook, lecture: lecture, reminder: reminder, checklist: checklist)
    showRemoval(notebook, draftId: draft.id)
}

private func showNotes(_ notebook: Notebook, existingNote: Note) {
    printSection("Все заметки")
    print(notebook.display())

    let duplicateAdded = notebook.add(existingNote)
    print("\nПовторное добавление: \(duplicateAdded ? "выполнено" : "отклонено — заметка уже есть")")
}

private func showSearch(_ notebook: Notebook, existingId: UUID) {
    printSection("Поиск по идентификатору")
    let existingTitle = notebook.findById(existingId)?.title ?? "не найдена"
    let missingTitle = notebook.findById(UUID())?.title ?? "не найдена"

    print("Существующая заметка: \(existingTitle)")
    print("Несуществующая заметка: \(missingTitle)")
}

private func showCollections(_ notebook: Notebook) {
    printSection("Операции с коллекциями")
    let pinnedTitles = notebook.filter { $0.metadata.isPinned }.map { $0.title }.joined(separator: ", ")
    let sortedTitles = notebook.sorted { $0.title < $1.title }.map { $0.title }.joined(separator: ", ")
    let annaNote = notebook.first { $0.metadata.author == "Анна" }
    let borisNote = notebook.first { $0.metadata.author == "Борис" }

    print("Всего заметок: \(notebook.all().count)")
    print("Закреплённые: \(pinnedTitles.isEmpty ? "нет" : pinnedTitles)")
    print("По названию: \(sortedTitles)")
    print("Первая заметка Анны: \(annaNote?.title ?? "не найдена")")
    print("Первая заметка Бориса: \(borisNote?.title ?? "не найдена")")
}

private func showUpdates(
    _ notebook: Notebook,
    lecture: TextNote,
    reminder: ReminderNote,
    checklist: ChecklistNote
) {
    printSection("Обновление и предпросмотр")
    notebook.all().forEach { $0.update() }
    let emptyTitleAccepted = lecture.update(newTitle: "   ")
    reminder.complete()
    checklist.completeItem(at: 0)

    print("Пустое название: \(emptyTitleAccepted ? "принято" : "отклонено")")
    print("Предпросмотр содержимого (до 24 символов):")
    print(notebook.display(mode: .preview(maxLength: 24)))
}

private func showRemoval(_ notebook: Notebook, draftId: UUID) {
    printSection("Удаление заметки")
    let removedTitle = notebook.remove(draftId)?.title ?? "не найдена"
    let repeatedRemoval = notebook.remove(draftId)?.title ?? "заметка уже отсутствует"

    print("Удалена: \(removedTitle)")
    print("Повторное удаление: \(repeatedRemoval)")
    print("Осталось заметок: \(notebook.all().count)")
}

private func printSection(_ title: String) {
    print("\n=== \(title) ===")
}

runDemo()