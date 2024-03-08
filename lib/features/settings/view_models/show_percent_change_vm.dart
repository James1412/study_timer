import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:study_timer/features/settings/repos/show_percent_change_repo.dart';

class ShowPercentChangeViewModel extends Notifier<bool> {
  final ShowPercentChangeRepository _repository = ShowPercentChangeRepository();

  void changeShowPercentChange(bool val) {
    state = val;
    _repository.setShowPercentChange(val);
  }

  @override
  bool build() {
    return _repository.getShowPercentChange ?? true;
  }
}

final showPercentChangeProvider =
    NotifierProvider<ShowPercentChangeViewModel, bool>(
  () => ShowPercentChangeViewModel(),
);
