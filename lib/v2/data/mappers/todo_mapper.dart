import '../../domain/entities/todo.dart';
import '../models/todo_dto.dart';

class TodoMapper {
  static Todo toEntity(TodoDto dto) {
    return Todo(
      todoId: dto.todoId,
      title: dto.title,
      content: dto.content,
      courseId: dto.courseId,
      endTime: dto.endTime,
      remind: dto.remind,
      remindType: dto.remindType,
      isCompleted: dto.isCompleted,
      createTime: dto.createTime,
    );
  }

  static List<Todo> toEntityList(List<TodoDto> dtos) {
    return dtos.map(toEntity).toList();
  }
}
