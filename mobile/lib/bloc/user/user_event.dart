part of 'user_bloc.dart';

@immutable
abstract class UserEvent {}

final class UserDeleteAccountEvent extends UserEvent {}
