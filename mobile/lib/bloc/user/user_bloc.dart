import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:user_repository/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    final UserRepository userRepository = UserRepository();

    on<UserDeleteAccountEvent>((event, emit) {
      userRepository.deleteAccount();
    });
  }
}
