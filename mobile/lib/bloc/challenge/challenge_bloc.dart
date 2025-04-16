import 'package:bloc/bloc.dart';
import 'package:challenge_repository/challenge.dart';
import 'package:equatable/equatable.dart';
import 'package:challenge_repository/challenge_repository.dart';

part 'challenge_event.dart';
part 'challenge_state.dart';

class ChallengeBloc extends Bloc<ChallengeEvent, ChallengeState> {
  final ChallengeRepository repository;

  ChallengeBloc({required this.repository}) : super(ChallengeState.initial()) {
    on<LoadChallenges>(_onLoadChallenges);
    on<FilterByCategory>(_onFilterByCategory);
    on<ToggleShowCompleted>(_onToggleShowCompleted);
  }

  List<ChallengeWithProgress> _allChallenges = [];

  Future<void> _onLoadChallenges(
      LoadChallenges event, Emitter<ChallengeState> emit) async {
    emit(state.copyWith(status: Status.loading));
    try {
      _allChallenges = await repository.getChallengesWithProgress();
      _emitFiltered(emit);
    } catch (_) {
      emit(state.copyWith(status: Status.error));
    }
  }

  void _onFilterByCategory(
      FilterByCategory event, Emitter<ChallengeState> emit) {
    emit(ChallengeState(
      challenges: state.challenges,
      status: state.status,
      showCompleted: state.showCompleted,
      selectedCategory: event.category,
    ));
    _emitFiltered(emit);
  }

  void _onToggleShowCompleted(
      ToggleShowCompleted event, Emitter<ChallengeState> emit) {
    emit(
      state.copyWith(
        showCompleted: !state.showCompleted,
      ),
    );
    _emitFiltered(emit);
  }

  void _emitFiltered(Emitter<ChallengeState> emit) {
    final filtered = _allChallenges.where((entry) {
      final matchesCategory = state.selectedCategory == null ||
          entry.challenge.category == state.selectedCategory;
      final matchesCompletion = state.showCompleted ||
          entry.progress == null ||
          !entry.progress!.completed;

      return matchesCategory && matchesCompletion;
    }).toList();

    emit(state.copyWith(
      challenges: filtered,
      status: Status.loaded,
    ));
  }
}
