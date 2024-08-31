
import 'package:notetaker_practiceapp/services/auth/auth_exceptions.dart';
import 'package:notetaker_practiceapp/services/auth/auth_provider.dart';
import 'package:notetaker_practiceapp/services/auth/auth_user.dart';
import 'package:test/test.dart';
 void main (){
  group('Mock authentication',(){

    final provider = MockAuthprovider();
    test('should not be initialized to begin with', (){
      expect(provider.isInitialized,false);
    });

    test('Cannot log out if not initialized', (){
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>())
      );
    });

    test('should be able to be initialized', () async {
      await provider.initialize();
      expect(provider.isInitialized,true);
    });


    test('user should be null after initialization', (){
      expect(provider.currentUser,null);
    });

    test('should be able to initialize in less than 2 seconds', () async {
      await provider.initialize();
      expect(provider.isInitialized,true);

    }, 
    timeout: const Timeout( Duration(seconds: 2)));

    test('create user should delegate to login function', () async{
      final badEmailUser = provider.createUser(
        email: 'foo@bar.com', 
        password: 'anyPassword',
        );

      expect(badEmailUser, throwsA(const TypeMatcher<InvalidCredentialAuthException>()));

     final badPasswordUser = provider.createUser(
        email: 'person@gmail.com', 
        password: 'foobar',
        );

      expect(badPasswordUser, throwsA(const TypeMatcher<InvalidCredentialAuthException>()));

    final user = await provider.createUser(
      email: 'foo', password: 'bar'
      );

      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
      });

    test('login user should be able to get verified', () {
        provider.sendEmailVerification();
        final user = provider.currentUser;
        expect(user, isNotNull);
        expect(user!.isEmailVerified,true);
    });

    test('Should be able to log out and log in again', () async{
      await provider.logOut();
      await provider.logIn(
        email: 'email', 
        password: 'password',
        );
        final user = provider.currentUser;
        expect (user, isNotNull);
    });




  });
 }

 class NotInitializedException implements Exception{}

 class MockAuthprovider implements AuthProvider{
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email, 
    required String password,
    }) async {
    // TODO: implement createUser
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
       password: password,
       );
  }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password}) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'foo@bar.com') throw InvalidCredentialAuthException();
    if (password == 'foobar') throw InvalidCredentialAuthException();
    const user = AuthUser(
      id: 'my_id',
      isEmailVerified: false, 
      email: 'foo@bar.com', 
    );
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotLoggedInAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async  {
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotLoggedInAuthException;
    const newUser = AuthUser(
      id: 'my_id',
      isEmailVerified: true, 
      email: 'foo@bar.com',
      );
    _user = newUser;
    
  }
  
  @override
  Future<void> sendPasswordReset({required String toEmail}) {
    // TODO: implement sendPasswordReset
    throw UnimplementedError();
  }

 }