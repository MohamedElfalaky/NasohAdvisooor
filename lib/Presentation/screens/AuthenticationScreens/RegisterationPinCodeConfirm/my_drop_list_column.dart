import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nasooh/Data/cubit/authentication/country_cubit/country_state.dart';

import '../../../../Data/cubit/authentication/city_cubit/city_cubit.dart';
import '../../../../Data/cubit/authentication/city_cubit/city_state.dart';
import '../../../../Data/cubit/authentication/country_cubit/country_cubit.dart';
import '../../../../Data/cubit/authentication/nationality_cubit/nationality_cubit.dart';
import '../../../../Data/cubit/authentication/nationality_cubit/nationality_state.dart';
import '../../../../app/constants.dart';

String? inputCountry;
String? inputCity;
String? inputNationality;

class CustomDropDown<T> extends StatefulWidget {
  final String? value;
  final String hintData;
  final List<DropdownMenuItem<String>>? items;
  final void Function(dynamic)? onChanged;
  final Widget? prefixIcon;

  const CustomDropDown({
    super.key,
    this.prefixIcon,
    this.value,
    required this.hintData,
    required this.onChanged,
    required this.items,
  });

  @override
  State<CustomDropDown<T>> createState() => _CustomDropDownState<T>();
}

class _CustomDropDownState<T> extends State<CustomDropDown<T>> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
          height: MediaQuery.of(context).size.height * 0.06,
          decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFBDBDBD)),
              borderRadius: const BorderRadius.all(Radius.circular(5))),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<dynamic>(
              menuMaxHeight: 300.0,
              decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  prefixIcon: Padding(
                    padding: const EdgeInsetsDirectional.only(
                        start: 12, end: 6, top: 10, bottom: 10),
                    child: Container(
                      width: 30,
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            width: 1,
                            color: Color(0xFFBDBDBD),
                          ),
                        ),
                      ),
                      margin: const EdgeInsetsDirectional.only(end: 8),
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      child: widget.prefixIcon,
                    ),
                  ),
                  hintText: widget.hintData,
                  hintStyle: const TextStyle(
                    fontFamily: Constants.mainFont,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  )),
              icon: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Icon(Icons.keyboard_arrow_down_rounded,
                    color: Colors.black),
              ),
              isExpanded: true,
              items: widget.items,
              onChanged: widget.onChanged,
            ),
          )),
    );
  }
}

class NationalityAndCountryWidget extends StatefulWidget {
  const NationalityAndCountryWidget({super.key});

  @override
  State<NationalityAndCountryWidget> createState() =>
      _NationalityAndCountryWidgetState();
}

class _NationalityAndCountryWidgetState
    extends State<NationalityAndCountryWidget> {
  String? countryValue;
  String? cityValue;
  String? nationalityValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TitleTxt(
          txt: "nationality_optional".tr,
        ),
        BlocBuilder<NationalityCubit, NationalityState>(
            builder: (context, state) {
          if (state is NationalityLoading) {
            return const SizedBox(
                width: double.infinity,
                child: Center(child: CircularProgressIndicator.adaptive()));
          } else if (state is NationalityLoaded) {
            // print('nationality loaded');
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 24),
                    child: CustomDropDown(
                        hintData: "سعودي",
                        value: nationalityValue,
                        items: state.response!.data!
                            .map(
                              (e) => DropdownMenuItem(
                                  value: e.id.toString(), child: Text(e.name!)),
                            )
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            nationalityValue = val;
                            inputNationality = nationalityValue;
                          });
                        },
                        prefixIcon: SvgPicture.asset(
                          'assets/images/SVGs/flag.svg',
                          height: 24,
                        ))),
              ],
            );
          }
          return const Center(child: SizedBox.shrink());
        }),
        BlocBuilder<CountryCubit, CountryState>(builder: (context, state) {
          if (state is CountryLoading) {
            return const SizedBox(
                width: double.infinity,
                child: Center(child: CircularProgressIndicator.adaptive()));
          } else if (state is CountryLoaded) {
            // print('nationality loaded');
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TitleTxt(
                  txt: "resident_country".tr,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 24),
                  child: CustomDropDown(
                      hintData: "السعودية",
                      value: countryValue,
                      onChanged: (val) {
                        countryValue = val;
                        cityValue = null;
                        inputCountry = countryValue;
                        if (inputCountry != null) {
                          context.read<CityCubit>().getCities(inputCountry!);
                        }
                      },
                      items: state.response!.data!
                          .map((e) => DropdownMenuItem(
                              value: e.id.toString(), child: Text(e.name!)))
                          .toList(),
                      prefixIcon: SvgPicture.asset(
                        "assets/images/SVGs/country.svg",
                        height: 24,
                      )),
                )
              ],
            );
          }
          return const Center(child: SizedBox.shrink());
        }),
        TitleTxt(txt: "resident_city".tr),
        BlocBuilder<CityCubit, CityState>(builder: (context, cityState) {
          if (cityState is CityLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (cityState is CityLoaded) {
            if (cityState.response?.data?.isNotEmpty == true) {
              return Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 24),
                child: CustomDropDown(
                    hintData: "اختر المدينة",
                    // value: cityValue??'',
                    onChanged: (val) {
                      setState(() {
                        cityValue = val;
                        inputCity = cityValue;
                      });
                      // print("$inputCity is CityChosen");
                    },
                    items: cityState.response?.data!
                        .map(
                          (e) => DropdownMenuItem(
                              value: '${e.id ?? ''}', child: Text('${e.name}')),
                        )
                        .toList(),
                    prefixIcon: SvgPicture.asset(
                      'assets/images/SVGs/city1.svg',
                      height: 24,
                    )),
              );
            }
          }
          return const SizedBox();
        }),
      ],
    );
  }
}

class InputTextField extends StatelessWidget {
  const InputTextField(
      {super.key,
      this.controller,
      this.keyboardType,
      this.validator,
      this.onChanged,
      required this.imageTxt,
      required this.hintTxt});

  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final String imageTxt;
  final String hintTxt;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20, top: 10),
        child: TextFormField(
          validator: validator ??
              (val) {
                return null;
              },
          controller: controller,
          onChanged: onChanged,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontFamily: Constants.mainFont,
            fontSize: 12,
          ),
          decoration: Constants.setRegistrationTextInputDecoration(
              hintText: hintTxt,
              prefixIcon: SvgPicture.asset(
                imageTxt,
                height: 24,
              )),
        ),
      ),
    );
  }
}

class TitleTxt extends StatelessWidget {
  const TitleTxt({super.key, required this.txt});

  final String txt;

  @override
  Widget build(BuildContext context) {
    return Text(
      txt,
      textAlign: TextAlign.right,
      style: Constants.secondaryTitleRegularFont,
    );
  }
}
