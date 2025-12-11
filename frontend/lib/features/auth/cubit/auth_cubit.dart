import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskapp/core/services/sp_service.dart';
import 'package:taskapp/features/auth/repositories/auth_remote_repository.dart';
import 'package:taskapp/models/user_model.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final authRemoteRepository = AuthRemoteRepository();
  final spService = SpService();
  void getUserData() async{
    try {
      emit(AuthUserLoading());
    final userModel = await authRemoteRepository.getUserData();
    if(userModel != null){
      emit(AuthLoggedIn(userModel));
    }else{
      emit(AuthInitial());
    }
    
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
  AuthCubit():super(AuthInitial());

  void signUp({
    required String name,
    required String email,
    required String password,
  })async {
    try {
    
      emit(AuthUserLoading());
    await authRemoteRepository.signUp(name: name, email: email, password: password);
    emit(AuthSignUp());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void logIn({
    required String email,
    required String password
  })async{
     try {
     
      emit(AuthUserLoading());
    final  userModel = await authRemoteRepository.logIn( email: email, password: password);
    if(userModel.token!.isNotEmpty){
      spService.setToken(userModel.token as String);
    }
     
    emit(AuthLoggedIn(userModel));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
