import 'package:bloc/bloc.dart';
import 'package:challenge_repository/challenge.dart';
import 'package:equatable/equatable.dart';
import 'package:challenge_repository/challenge_repository.dart';

part 'challenge_event.dart';
part 'challenge_state.dart';

class ChallengeBloc extends Bloc<ChallengeEvent, ChallengeState> {
  final ChallengeRepository repository;

  ChallengeBloc({required this.repository}) : super(ChallengeLoading()) {
    on<LoadChallenges>(_onLoadChallenges);
    on<FilterByCategory>(_onFilterByCategory);
    on<ToggleShowCompleted>(_onToggleShowCompleted);
  }

  List<ChallengeWithProgress> _allChallenges = [];
  ChallengeCategory? _categoryFilter;
  bool _showCompleted = true;

  Future<void> _onLoadChallenges(
      LoadChallenges event, Emitter<ChallengeState> emit) async {
    emit(ChallengeLoading());
    try {
      _allChallenges = await repository.getChallengesWithProgress();
      _emitFiltered(emit);
    } catch (_) {
      emit(ChallengeError());
    }
  }

  void _onFilterByCategory(
      FilterByCategory event, Emitter<ChallengeState> emit) {
    _categoryFilter = event.category;
    _emitFiltered(emit);
  }

  void _onToggleShowCompleted(
      ToggleShowCompleted event, Emitter<ChallengeState> emit) {
    _showCompleted = !_showCompleted;
    _emitFiltered(emit);
  }

  void _emitFiltered(Emitter<ChallengeState> emit) {
    final filtered = _allChallenges.where((entry) {
      final matchesCategory = _categoryFilter == null ||
          entry.challenge.category == _categoryFilter;
      final matchesCompletion = _showCompleted ||
          entry.progress == null ||
          !entry.progress!.completed;

      return matchesCategory && matchesCompletion;
    }).toList();

    emit(ChallengeLoaded(challenges: filtered));
  }
}
