import 'package:course_task_app/common/enums.dart';
import 'package:course_task_app/data/models/user.dart';
import 'package:course_task_app/data/source/user_source.dart';
import 'package:d_session/d_session.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState(user: null, requestStatus: RequestStatus.init));
  clickLogin(String email, String password) async {
    User? result = await UserSource.login(email, password);
    if (result == null) {
      emit(LoginState(user: null, requestStatus: RequestStatus.failed));
    } else {
      DSession.setUser(result.toJson());
      emit(LoginState(user: result, requestStatus: RequestStatus.success));
    }
  }
}
