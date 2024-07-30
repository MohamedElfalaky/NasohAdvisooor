import '../../../models/country_model.dart';

abstract class CountryState {}

class CountryInitial extends CountryState {}

class CountryLoading extends CountryState {}

class CountryLoaded extends CountryState {
  CountyModel? response;

  CountryLoaded(this.response);
}

class CountryError extends CountryState {}
