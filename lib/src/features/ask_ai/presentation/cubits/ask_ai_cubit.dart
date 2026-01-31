import 'package:flutter_bloc/flutter_bloc.dart';

import 'ask_ai_state.dart';

class AskAiCubit extends Cubit<AskAiState> {
  AskAiCubit() : super(AskAiInitialState());
}
