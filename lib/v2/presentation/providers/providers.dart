import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/repositories/account_repository.dart';
import '../../domain/repositories/pan_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/get_courses_usecase.dart';
import '../../domain/usecases/get_activities_usecase.dart';
import '../../domain/usecases/get_exam_list_usecase.dart';
import '../../domain/usecases/normal_signin_usecase.dart';
import '../../domain/usecases/code_signin_usecase.dart';
import '../../domain/usecases/location_signin_usecase.dart';
import '../../domain/usecases/get_course_notices_usecase.dart';
import '../../domain/usecases/get_group_chat_list_usecase.dart';
import '../../domain/usecases/get_group_messages_usecase.dart';
import '../../domain/usecases/get_cloud_files_usecase.dart';
import '../../domain/usecases/add_todo_usecase.dart';
import '../../domain/usecases/submit_quiz_answer_usecase.dart';
import '../../domain/usecases/get_homework_list_usecase.dart';
import '../../domain/usecases/get_quiz_detail_usecase.dart';
import '../../domain/usecases/check_quiz_status_usecase.dart';
import '../../domain/usecases/get_todo_list_usecase.dart';
import '../../domain/usecases/complete_todo_usecase.dart';
import '../../domain/usecases/delete_todo_usecase.dart';
import '../../domain/usecases/download_file_usecase.dart';
import '../../domain/usecases/upload_file_usecase.dart';
import '../../domain/usecases/create_cloud_folder_usecase.dart';
import '../../domain/usecases/delete_cloud_file_usecase.dart';
import '../../domain/usecases/rename_cloud_file_usecase.dart';
import '../../domain/usecases/toggle_pin_usecase.dart';
import '../../domain/usecases/share_cloud_file_usecase.dart';
import '../../app_dependencies.dart';

part 'providers.g.dart';

@riverpod
class SessionVersion extends _$SessionVersion {
  @override
  int build() => 0;

  void increment() => state++;
}

AppDependencies get _deps => AppDependencies.instance;

@riverpod
AccountRepository accountRepository(AccountRepositoryRef ref) =>
    _deps.accountRepo;

@riverpod
PanRepository panRepository(PanRepositoryRef ref) => _deps.panRepo;

@riverpod
LoginUseCase loginUseCase(LoginUseCaseRef ref) => _deps.loginUseCase;

@riverpod
GetCoursesUseCase getCoursesUseCase(GetCoursesUseCaseRef ref) =>
    _deps.getCoursesUseCase;

@riverpod
GetActivitiesUseCase getActivitiesUseCase(GetActivitiesUseCaseRef ref) =>
    _deps.getActivitiesUseCase;

@riverpod
GetExamListUseCase getExamListUseCase(GetExamListUseCaseRef ref) =>
    _deps.getExamListUseCase;

@riverpod
NormalSignInUseCase normalSignInUseCase(NormalSignInUseCaseRef ref) =>
    _deps.normalSignInUseCase;

@riverpod
CodeSignInUseCase codeSignInUseCase(CodeSignInUseCaseRef ref) =>
    _deps.codeSignInUseCase;

@riverpod
LocationSignInUseCase locationSignInUseCase(LocationSignInUseCaseRef ref) =>
    _deps.locationSignInUseCase;

@riverpod
GetCourseNoticesUseCase getCourseNoticesUseCase(
  GetCourseNoticesUseCaseRef ref,
) => _deps.getCourseNoticesUseCase;

@riverpod
GetGroupChatListUseCase getGroupChatListUseCase(
  GetGroupChatListUseCaseRef ref,
) => _deps.getGroupChatListUseCase;

@riverpod
GetGroupMessagesUseCase getGroupMessagesUseCase(
  GetGroupMessagesUseCaseRef ref,
) => _deps.getGroupMessagesUseCase;

@riverpod
GetCloudFilesUseCase getCloudFilesUseCase(GetCloudFilesUseCaseRef ref) =>
    _deps.getCloudFilesUseCase;

@riverpod
AddTodoUseCase addTodoUseCase(AddTodoUseCaseRef ref) => _deps.addTodoUseCase;

@riverpod
SubmitQuizAnswerUseCase submitQuizAnswerUseCase(
  SubmitQuizAnswerUseCaseRef ref,
) => _deps.submitQuizAnswerUseCase;

@riverpod
GetHomeworkListUseCase getHomeworkListUseCase(GetHomeworkListUseCaseRef ref) =>
    _deps.getHomeworkListUseCase;

@riverpod
GetQuizDetailUseCase getQuizDetailUseCase(GetQuizDetailUseCaseRef ref) =>
    _deps.getQuizDetailUseCase;

@riverpod
CheckQuizStatusUseCase checkQuizStatusUseCase(CheckQuizStatusUseCaseRef ref) =>
    _deps.checkQuizStatusUseCase;

@riverpod
GetTodoListUseCase getTodoListUseCase(GetTodoListUseCaseRef ref) =>
    _deps.getTodoListUseCase;

@riverpod
CompleteTodoUseCase completeTodoUseCase(CompleteTodoUseCaseRef ref) =>
    _deps.completeTodoUseCase;

@riverpod
DeleteTodoUseCase deleteTodoUseCase(DeleteTodoUseCaseRef ref) =>
    _deps.deleteTodoUseCase;

@riverpod
DownloadFileUseCase downloadFileUseCase(DownloadFileUseCaseRef ref) =>
    _deps.downloadFileUseCase;

@riverpod
UploadFileUseCase uploadFileUseCase(UploadFileUseCaseRef ref) =>
    _deps.uploadFileUseCase;

@riverpod
CreateCloudFolderUseCase createCloudFolderUseCase(
  CreateCloudFolderUseCaseRef ref,
) => _deps.createCloudFolderUseCase;

@riverpod
DeleteCloudFileUseCase deleteCloudFileUseCase(DeleteCloudFileUseCaseRef ref) =>
    _deps.deleteCloudFileUseCase;

@riverpod
RenameCloudFileUseCase renameCloudFileUseCase(RenameCloudFileUseCaseRef ref) =>
    _deps.renameCloudFileUseCase;

@riverpod
TogglePinUseCase togglePinUseCase(TogglePinUseCaseRef ref) =>
    _deps.togglePinUseCase;

@riverpod
ShareCloudFileUseCase shareCloudFileUseCase(ShareCloudFileUseCaseRef ref) =>
    _deps.shareCloudFileUseCase;
