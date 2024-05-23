import 'package:bloc/bloc.dart';
import 'package:notetaker_practiceapp/services/auth/auth_provider.dart';
import 'package:notetaker_practiceapp/services/auth/bloc/auth_event.dart';
import 'package:notetaker_practiceapp/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState>{
  AuthBloc(AuthProvider provider) : super(const AuthStateLoading()){
 
  //initialize
  on<AuthEventInitialize>((event,emit)async{
    await provider.initialize();
    final user = provider.currentUser;
    if (user == null){
      emit(const AuthStateLoggedOut(null));
    }
    else if (!user.isEmailVerified){
      emit(const AuthStateNeedsVerification());
    } else {
      emit (AuthStateLoggedIn(user));
    }
    });

  //Log in

  on<AuthEventLogIn> ((event,emit) async{
    final email = event.email;
    final password = event.password;
    try{
      final user = await provider.logIn(
        email: email, 
        password: password);
      emit (AuthStateLoggedIn(user));
    } on Exception catch (e) {
      emit(AuthStateLoggedOut(e));
    }
  });

  on<AuthEventLogOut> ((event,emit) async{
    try{
      //emit AuthStateLoading doesn't have to be in try block since itll always succeed 
      emit(const AuthStateLoading());
      await provider.logOut();
      emit(const AuthStateLoggedOut(null));

    }on Exception catch (e){
      emit(AuthStateLogOutFailure(e));
    }


  });

  }  
}