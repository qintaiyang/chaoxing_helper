import 'package:flutter/material.dart';
import 'infra/storage/storage_service.dart';
import 'infra/services/legacy_storage_service.dart' as legacy_storage;
import 'infra/crypto/encryption_service.dart';
import 'infra/crypto/crypto_config.dart';
import 'infra/storage/cookie_manager.dart';
import 'infra/network/dio_client.dart';
import 'infra/services/im_service.dart';
import 'infra/services/member_name_cache.dart';
import 'domain/entities/enums.dart';
import 'data/datasources/remote/chaoxing/cx_auth_api.dart';
import 'data/datasources/remote/chaoxing/cx_course_api.dart';
import 'data/datasources/remote/chaoxing/cx_exam_api.dart';
import 'data/datasources/remote/chaoxing/cx_signin_api.dart';
import 'data/datasources/remote/chaoxing/cx_notice_api.dart';
import 'data/datasources/remote/chaoxing/cx_group_im_api.dart';
import 'data/datasources/remote/chaoxing/cx_quiz_api.dart';
import 'data/datasources/remote/chaoxing/cx_todo_api.dart';
import 'data/datasources/remote/chaoxing/cx_pan_api.dart';
import 'data/datasources/remote/chaoxing/cx_friend_contact_api.dart';
import 'data/datasources/remote/chaoxing/cx_account_manage_api.dart';
import 'data/datasources/remote/chaoxing/cx_upload_api.dart';
import 'data/datasources/remote/chaoxing/cx_materials_api.dart';
import 'data/datasources/remote/chaoxing/cx_chat_api.dart';
import 'data/repositories/account_repository_impl.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/course_repository_impl.dart';
import 'data/repositories/exam_repository_impl.dart';
import 'data/repositories/signin_repository_impl.dart';
import 'data/repositories/notice_repository_impl.dart';
import 'data/repositories/group_chat_repository_impl.dart';
import 'data/repositories/quiz_repository_impl.dart';
import 'data/repositories/todo_repository_impl.dart';
import 'data/repositories/pan_repository_impl.dart';
import 'data/repositories/materials_repository_impl.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/get_courses_usecase.dart';
import 'domain/usecases/get_activities_usecase.dart';
import 'domain/usecases/get_exam_list_usecase.dart';
import 'domain/usecases/normal_signin_usecase.dart';
import 'domain/usecases/code_signin_usecase.dart';
import 'domain/usecases/location_signin_usecase.dart';
import 'domain/usecases/qr_code_signin_usecase.dart';
import 'domain/usecases/get_sign_detail_usecase.dart';
import 'domain/usecases/get_course_notices_usecase.dart';
import 'domain/usecases/get_user_notices_usecase.dart';
import 'domain/usecases/get_group_chat_list_usecase.dart';
import 'domain/usecases/get_group_messages_usecase.dart';
import 'domain/usecases/get_cloud_files_usecase.dart';
import 'domain/usecases/add_todo_usecase.dart';
import 'domain/usecases/submit_quiz_answer_usecase.dart';
import 'domain/usecases/get_homework_list_usecase.dart';
import 'domain/usecases/get_quiz_detail_usecase.dart';
import 'domain/usecases/check_quiz_status_usecase.dart';
import 'domain/usecases/get_todo_list_usecase.dart';
import 'domain/usecases/complete_todo_usecase.dart';
import 'domain/usecases/delete_todo_usecase.dart';
import 'domain/usecases/download_file_usecase.dart';
import 'domain/usecases/upload_file_usecase.dart';
import 'domain/usecases/create_cloud_folder_usecase.dart';
import 'domain/usecases/delete_cloud_file_usecase.dart';
import 'domain/usecases/rename_cloud_file_usecase.dart';
import 'domain/usecases/toggle_pin_usecase.dart';
import 'domain/usecases/share_cloud_file_usecase.dart';
import 'domain/usecases/get_course_materials_usecase.dart';
import 'domain/usecases/get_material_download_url_usecase.dart';
import 'domain/usecases/submit_vote_usecase.dart';
import 'domain/usecases/submit_questionnaire_usecase.dart';

class AppDependencies {
  static final AppDependencies _instance = AppDependencies._();
  static AppDependencies get instance => _instance;
  AppDependencies._();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  late SharedPreferencesStorage storage;
  late EncryptionService encryption;
  late CookieManager cookieManager;
  late AppDioClient dioClient;

  late ImService imService;

  late AccountRepositoryImpl accountRepo;
  late AuthRepositoryImpl authRepo;
  late CourseRepositoryImpl courseRepo;
  late ExamRepositoryImpl examRepo;
  late SignInRepositoryImpl signInRepo;
  late NoticeRepositoryImpl noticeRepo;
  late GroupChatRepositoryImpl groupChatRepo;
  late QuizRepositoryImpl quizRepo;
  late TodoRepositoryImpl todoRepo;
  late PanRepositoryImpl panRepo;
  late MaterialsRepositoryImpl materialsRepo;

  late CXAuthApi cxAuthApi;
  late CXCourseApi cxCourseApi;
  late CXExamApi cxExamApi;
  late CXSignInApi cxSignInApi;
  late CXNoticeApi cxNoticeApi;
  late CXGroupImApi cxGroupImApi;
  late CXQuizApi cxQuizApi;
  late CXTodoApi cxTodoApi;
  late CXPanApi cxPanApi;
  late CXMaterialsApi cxMaterialsApi;
  late CXFriendContactApi cxFriendContactApi;
  late CXAccountManageApi cxAccountManageApi;
  late CXUploadApi cxUploadApi;
  late CXChatApi cxChatApi;

  late LoginUseCase loginUseCase;
  late GetCoursesUseCase getCoursesUseCase;
  late GetActivitiesUseCase getActivitiesUseCase;
  late GetExamListUseCase getExamListUseCase;
  late NormalSignInUseCase normalSignInUseCase;
  late CodeSignInUseCase codeSignInUseCase;
  late LocationSignInUseCase locationSignInUseCase;
  late QrCodeSignInUseCase qrCodeSignInUseCase;
  late GetSignDetailUseCase getSignDetailUseCase;
  late GetCourseNoticesUseCase getCourseNoticesUseCase;
  late GetUserNoticesUseCase getUserNoticesUseCase;
  late GetGroupChatListUseCase getGroupChatListUseCase;
  late GetGroupMessagesUseCase getGroupMessagesUseCase;
  late GetCloudFilesUseCase getCloudFilesUseCase;
  late AddTodoUseCase addTodoUseCase;
  late SubmitQuizAnswerUseCase submitQuizAnswerUseCase;
  late GetHomeworkListUseCase getHomeworkListUseCase;
  late GetQuizDetailUseCase getQuizDetailUseCase;
  late CheckQuizStatusUseCase checkQuizStatusUseCase;
  late GetTodoListUseCase getTodoListUseCase;
  late CompleteTodoUseCase completeTodoUseCase;
  late DeleteTodoUseCase deleteTodoUseCase;
  late DownloadFileUseCase downloadFileUseCase;
  late UploadFileUseCase uploadFileUseCase;
  late CreateCloudFolderUseCase createCloudFolderUseCase;
  late DeleteCloudFileUseCase deleteCloudFileUseCase;
  late RenameCloudFileUseCase renameCloudFileUseCase;
  late TogglePinUseCase togglePinUseCase;
  late ShareCloudFileUseCase shareCloudFileUseCase;
  late GetCourseMaterialsUseCase getCourseMaterialsUseCase;
  late GetMaterialDownloadUrlUseCase getMaterialDownloadUrlUseCase;
  late SubmitVoteUseCase submitVoteUseCase;
  late SubmitQuestionnaireUseCase submitQuestionnaireUseCase;

  Future<void> initialize() async {
    debugPrint('🚀 V2 AppDependencies 初始化...');

    storage = SharedPreferencesStorage.instance;
    await storage.initialize();

    await legacy_storage.StorageService.initialize();

    await MemberNameCache().loadFromStorage();

    encryption = EncryptionService(CryptoConfig.production);
    cookieManager = CookieManager(storage);
    imService = ImService(navigatorKey: navigatorKey);
    dioClient = AppDioClient(
      encryption: encryption,
      cookieManager: cookieManager,
      storage: storage,
      platform: PlatformType.chaoxing,
    );

    cxAuthApi = CXAuthApi(dioClient, encryption, cookieManager);
    cxCourseApi = CXCourseApi(dioClient, encryption);
    cxExamApi = CXExamApi(dioClient);
    cxSignInApi = CXSignInApi(dioClient);
    cxNoticeApi = CXNoticeApi(dioClient);
    cxGroupImApi = CXGroupImApi(dioClient);
    cxQuizApi = CXQuizApi(dioClient);
    cxTodoApi = CXTodoApi(dioClient);
    cxPanApi = CXPanApi(dioClient);
    cxMaterialsApi = CXMaterialsApi(dioClient);
    cxFriendContactApi = CXFriendContactApi(dioClient);
    cxAccountManageApi = CXAccountManageApi(dioClient, encryption);
    cxUploadApi = CXUploadApi(dioClient);
    cxChatApi = CXChatApi(dioClient);

    accountRepo = AccountRepositoryImpl(storage, encryption);
    authRepo = AuthRepositoryImpl(cxAuthApi, cookieManager, accountRepo);
    courseRepo = CourseRepositoryImpl(cxCourseApi);
    examRepo = ExamRepositoryImpl(cxExamApi);
    signInRepo = SignInRepositoryImpl(cxSignInApi);
    noticeRepo = NoticeRepositoryImpl(CXNoticeApi(dioClient));
    groupChatRepo = GroupChatRepositoryImpl(cxGroupImApi);
    quizRepo = QuizRepositoryImpl(cxQuizApi);
    todoRepo = TodoRepositoryImpl(cxTodoApi);
    panRepo = PanRepositoryImpl(cxPanApi);
    materialsRepo = MaterialsRepositoryImpl(cxMaterialsApi);

    loginUseCase = LoginUseCase(authRepo, accountRepo);
    getCoursesUseCase = GetCoursesUseCase(courseRepo);
    getActivitiesUseCase = GetActivitiesUseCase(courseRepo);
    getExamListUseCase = GetExamListUseCase(examRepo);
    normalSignInUseCase = NormalSignInUseCase(signInRepo);
    codeSignInUseCase = CodeSignInUseCase(signInRepo);
    locationSignInUseCase = LocationSignInUseCase(signInRepo);
    qrCodeSignInUseCase = QrCodeSignInUseCase(signInRepo);
    getSignDetailUseCase = GetSignDetailUseCase(signInRepo);
    getCourseNoticesUseCase = GetCourseNoticesUseCase(noticeRepo);
    getUserNoticesUseCase = GetUserNoticesUseCase(noticeRepo);
    getGroupChatListUseCase = GetGroupChatListUseCase(groupChatRepo);
    getGroupMessagesUseCase = GetGroupMessagesUseCase(groupChatRepo);
    getCloudFilesUseCase = GetCloudFilesUseCase(panRepo);
    addTodoUseCase = AddTodoUseCase(todoRepo);
    submitQuizAnswerUseCase = SubmitQuizAnswerUseCase(quizRepo);
    getHomeworkListUseCase = GetHomeworkListUseCase(courseRepo);
    getQuizDetailUseCase = GetQuizDetailUseCase(quizRepo);
    checkQuizStatusUseCase = CheckQuizStatusUseCase(quizRepo);
    getTodoListUseCase = GetTodoListUseCase(todoRepo);
    completeTodoUseCase = CompleteTodoUseCase(todoRepo);
    deleteTodoUseCase = DeleteTodoUseCase(todoRepo);
    downloadFileUseCase = DownloadFileUseCase(panRepo);
    uploadFileUseCase = UploadFileUseCase(panRepo);
    createCloudFolderUseCase = CreateCloudFolderUseCase(panRepo);
    deleteCloudFileUseCase = DeleteCloudFileUseCase(panRepo);
    renameCloudFileUseCase = RenameCloudFileUseCase(panRepo);
    togglePinUseCase = TogglePinUseCase(panRepo);
    shareCloudFileUseCase = ShareCloudFileUseCase(panRepo);
    getCourseMaterialsUseCase = GetCourseMaterialsUseCase(materialsRepo);
    getMaterialDownloadUrlUseCase = GetMaterialDownloadUrlUseCase(
      materialsRepo,
    );
    submitVoteUseCase = SubmitVoteUseCase(quizRepo);
    submitQuestionnaireUseCase = SubmitQuestionnaireUseCase(quizRepo);

    debugPrint('✅ V2 AppDependencies 初始化完成');
  }
}
