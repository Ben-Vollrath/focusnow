import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:focusnow/bloc/user/user_bloc.dart';
import 'package:user_repository/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
  });

  group('UserBloc', () {
    blocTest<UserBloc, UserState>(
      'calls deleteAccount when UserDeleteAccountEvent is added',
      build: () {
        when(() => mockUserRepository.deleteAccount()).thenAnswer((_) async {});
        return UserBloc(userRepository: mockUserRepository);
      },
      act: (bloc) => bloc.add(UserDeleteAccountEvent()),
      expect: () => [],
      verify: (_) {
        verify(() => mockUserRepository.deleteAccount()).called(1);
      },
    );
  });
}
