import 'package:bloc/bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';
import 'package:social_message/model/class.dart';

part 'chatting_state.dart';

class ChattingCubit extends Cubit<ChattingState> {
  ChattingCubit(corres) : super(ChattingState(corres: corres));
  select(Utilisateur? corres) => emit(ChattingState(corres: corres));

  // ChattingState? fromJson(Map<String, dynamic> json) =>
  //     ChattingState(corres: json['corres']);

  // @override
  // Map<String, dynamic> toJson(ChattingState state) => {'corres': state};
}
