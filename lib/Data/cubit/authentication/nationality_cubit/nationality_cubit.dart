import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repositories/authentication/nationality_repo/nationality_repo.dart';
import 'nationality_state.dart';

class NationalityCubit extends Cubit<NationalityState> {
  NationalityCubit() : super(NationalityInitial());
  NationalityRepo nationalityRepo = NationalityRepo();

  getNationality() async {
    try {
      emit(NationalityLoading());
      final mList = await nationalityRepo.getNationality();
      // print('city list $mList');

      emit(NationalityLoaded(mList));
    } catch (e) {
      // print('city error $e');
      emit(NationalityError());
    }
  }
}
