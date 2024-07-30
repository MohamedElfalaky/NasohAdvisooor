import 'package:nasooh/Data/models/nationality_model.dart';


abstract class NationalityState {}

class NationalityInitial extends NationalityState {}

class NationalityLoading extends NationalityState {}

class NationalityLoaded extends NationalityState {
  NationalityModel? response;

  NationalityLoaded(this.response);
}

class NationalityError extends NationalityState {}
