import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nasooh/Data/cubit/profile/profile_cubit/profile_cubit.dart';
import 'package:nasooh/Data/models/nationality_model.dart';
import 'package:nasooh/app/utils/shared_preference.dart';

import '../../../../Data/cubit/authentication/city_cubit/city_cubit.dart';
import '../../../../Data/cubit/authentication/city_cubit/city_state.dart';
import '../../../../Data/cubit/authentication/country_cubit/country_cubit.dart';
import '../../../../Data/cubit/authentication/country_cubit/country_state.dart';
import '../../../../Data/cubit/authentication/nationality_cubit/nationality_cubit.dart';
import '../../../../Data/cubit/authentication/nationality_cubit/nationality_state.dart';
import '../../../../Data/cubit/profile/profile_cubit/profile_state.dart';
import '../../../../Data/cubit/profile/update_profile_cubit/update_profile_cubit.dart';
import '../../../../Data/cubit/profile/update_profile_cubit/update_profile_state.dart';
import '../../../../Data/models/country_model.dart';
// import '../../../../app/Style/icons.dart';
// import '../../../../app/Style/sizes.dart';
import '../../../../app/constants.dart';
import '../../../../app/style/icons.dart';
import '../../../../app/style/sizes.dart';
import '../../../widgets/row_modal_sheet.dart';
import '../../../widgets/shared.dart';
import '../../AuthenticationScreens/RegisterationPinCodeConfirm/my_drop_list_column.dart';
import 'widgets/shared.dart';

class UserProfileEdit extends StatefulWidget {
  const UserProfileEdit({super.key});

  @override
  State<UserProfileEdit> createState() => _UserProfileEditState();
}

class _UserProfileEditState extends State<UserProfileEdit>
    with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool pageLoad = false;
  String? countryName;
  String? countryId;

  String? cityName;
  String? cityId;

  String? nationalityName;
  String? nationalityId;

  String? genderValue;
  String? phoneNumber;
  static final ImagePicker _picker = ImagePicker();
  static XFile? regImage;

  String base64NewImage = "";

  Future pickImage(ImageSource source, BuildContext context, setState) async {
    final myImage = await _picker.pickImage(source: source, imageQuality: 60);
    if (myImage == null) return;

    setState(() {
      regImage = myImage;
    });
    List<int> imageBytes = File(regImage!.path).readAsBytesSync();
    base64NewImage = base64.encode(imageBytes);
    log("base64Image!  is $base64NewImage");

    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  final TextEditingController _phoneController = TextEditingController();

  Future<void> getDataFromApi() async {
    if (mounted) {
      await context.read<ProfileCubit>().getDataProfile();
    }
    if (mounted) {
      await context.read<CountryCubit>().getCountries();
    }
    if (mounted) {
      await context.read<NationalityCubit>().getNationality();
    }

    late ProfileCubit profileCubit;
    if (mounted) {
      profileCubit = ProfileCubit.get(context);
    }

    _nameController.text = sharedPrefs.getUserName;
    _emailController.text = profileCubit.profileModel?.data?.email ?? "";
    _phoneController.text =
        profileCubit.profileModel?.data?.mobile?.substring(5, 14) ?? "";
    genderValue = profileCubit.profileModel?.data?.gender ?? "";

    if (profileCubit.profileModel?.data?.nationalityId != null) {
      nationalityId =
          profileCubit.profileModel!.data!.nationalityId!.id!.toString();
    }
    if (profileCubit.profileModel?.data?.countryId != null && mounted) {
      countryId = profileCubit.profileModel!.data!.countryId!.id!.toString();
      context.read<CityCubit>().getCities(countryId.toString());
    }
    if (profileCubit.profileModel?.data?.cityId != null) {
      cityId = profileCubit.profileModel!.data!.cityId!.id!.toString();
    }
    countryName = sharedPrefs.getUserCountry;
    nationalityName = sharedPrefs.getUserNationality;
    cityName = sharedPrefs.getUserCity;
    // debugPrint('zzz');
    // print(cityId);
    // print(countryId);
    // print(countryName);
    // print(nationalityName);
    // print(cityName);
    pageLoad = true;
    setState(() {});
  }

  @override
  void initState() {
    getDataFromApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 100),
        child: Padding(
          padding: EdgeInsets.only(top: 60, right: 20),
          child: Back(header: "Update Profile"),
        ),
      ),
      bottomNavigationBar: BlocBuilder<UpdateProfileCubit, UpdateProfileState>(
          builder: (context, state) => state is UpdateProfileLoading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : buildSaveButton(
                  label: "save",
                  onPressed: () {
                    context.read<UpdateProfileCubit>().updateMethod(
                          context: context,
                          fullName: _nameController.text,
                          nationalityName: nationalityName,
                          countryName: countryName,
                          cityName: cityName,
                          nationalityId: nationalityId ?? "1",
                          email: _emailController.text,
                          cityId: cityId ?? "1",
                          countryId: countryId ?? "2",
                          avatar: base64NewImage,
                          mobile: phoneNumber ?? "+966${_phoneController.text}",
                          gender: genderValue,
                        );
                  })),
      resizeToAvoidBottomInset: false,
      body: pageLoad
          ? BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, profileState) {
              if (profileState is ProfileLoading) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              } else if (profileState is ProfileLoaded) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: SizedBox(
                          height: 190,
                          width: 190,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Center(
                                child: DottedBorder(
                                    color: Constants.outLineColor,
                                    borderType: BorderType.Circle,
                                    radius: const Radius.circular(20),
                                    dashPattern: const [10, 6],
                                    child: Padding(
                                        padding: const EdgeInsets.all(6),
                                        child: CircleAvatar(
                                          radius: width(context) * 0.19,
                                          backgroundColor: Colors.transparent,
                                          backgroundImage: sharedPrefs
                                                          .getUserPhoto() ==
                                                      "" &&
                                                  regImage == null
                                              ? const AssetImage(
                                                  'assets/images/PNG/no_profile_photo.png')
                                              : regImage == null
                                                  ? NetworkImage(sharedPrefs
                                                      .getUserPhoto())
                                                  : FileImage(
                                                      File(regImage!.path),
                                                    ) as ImageProvider,
                                        ))),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(25.0),
                                        ),
                                      ),
                                      builder: (ctx) {
                                        return Container(
                                            padding: const EdgeInsets.all(18),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                RowModalSheet(
                                                    txt: "كاميرا",
                                                    imageIcon: cameraIcon,
                                                    onPressed: () {
                                                      pickImage(
                                                          ImageSource.camera,
                                                          ctx,
                                                          setState);
                                                    }),
                                                const Divider(),
                                                RowModalSheet(
                                                  txt: "الاستديو",
                                                  imageIcon: galleryIcon,
                                                  onPressed: () {
                                                    pickImage(
                                                        ImageSource.gallery,
                                                        ctx,
                                                        setState);
                                                  },
                                                ),
                                                const Divider(),
                                                RowModalSheet(
                                                  txt: "الغاء",
                                                  imageIcon: closeIcon,
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                )
                                              ],
                                            ));
                                      },
                                    );
                                  },
                                  child: const CircleAvatar(
                                    backgroundColor: Color(0XFF444444),
                                    radius: 20,
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          child: Text("Personal Information".tr,
                              textAlign: TextAlign.end,
                              style: Constants.subtitleFontBold
                                  .copyWith(fontSize: 16))),
                      const SizedBox(height: 8),
                      TitleTxt(txt: "Name".tr),
                      InputTextField(
                        keyboardType: TextInputType.text,
                        hintTxt: "Name".tr,
                        imageTxt: "assets/images/SVGs/name_icon.svg",
                        controller: _nameController,
                      ),
                      TitleTxt(txt: "email".tr),
                      InputTextField(
                        keyboardType: TextInputType.emailAddress,
                        hintTxt: "example@example.com",
                        imageTxt: "assets/images/SVGs/email_icon.svg",
                        controller: _emailController,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: SeparatorWidget(),
                      ),
                      Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          child: Text("Additional Information".tr,
                              textAlign: TextAlign.end,
                              style: Constants.subtitleFontBold
                                  .copyWith(fontSize: 16))),
                      const SizedBox(height: 16),
                      TitleTxt(txt: "nationality_optional".tr),
                      BlocBuilder<NationalityCubit, NationalityState>(
                          builder: (context, newState) {
                        if (newState is NationalityLoaded) {
                          return Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 24),
                              child: CustomDropDown<NationalityData>(
                                  hintData: nationalityName != '' &&
                                          nationalityName != null
                                      ? nationalityName!
                                      : 'برجاء اختيار الجنسية',
                                  value: nationalityId.toString(),
                                  items: newState.response!.data!.map(
                                    (e) {
                                      return DropdownMenuItem(
                                          value: e.id.toString(),
                                          child: Text(
                                            e.name!,
                                            style: const TextStyle(
                                                fontFamily: 'Cairo',
                                                fontSize: 14),
                                          ));
                                    },
                                  ).toList(),
                                  onChanged: (val) {
                                    newState.response!.data!.map((e) {
                                      if (val.toString() == e.id.toString()) {
                                        nationalityName = e.name;
                                        nationalityId = e.id.toString();
                                      }
                                    }).toList();
                                    setState(() {});
                                  },
                                  prefixIcon: SvgPicture.asset(
                                      'assets/images/SVGs/flag.svg',
                                      height: 24)));
                        }
                        return const SizedBox.shrink();
                      }),

                      ///============country ==============
                      BlocBuilder<CountryCubit, CountryState>(
                          builder: (context, countrySate) {
                        if (countrySate is CountryLoaded) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleTxt(txt: "resident_country".tr),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 24),
                                child: CustomDropDown(
                                    hintData:
                                        countryName != null && countryName != ''
                                            ? countryName!
                                            : "قم باختيار الدولة",
                                    value: countryId,
                                    onChanged: (val) {
                                      debugPrint(val);
                                      countryId = val;
                                      countrySate.response!.data!.map((e) {
                                        if (val.toString() == e.id.toString()) {
                                          countryName = e.name;
                                          cityId = null;
                                          cityName = null;
                                        }
                                      }).toList();
                                      setState(() {});
                                      context
                                          .read<CityCubit>()
                                          .getCities(countryId.toString());
                                    },
                                    items: countrySate.response?.data
                                        ?.map((e) => DropdownMenuItem(
                                            value: e.id.toString(),
                                            child: Text(e.name ?? "",
                                                style: const TextStyle(
                                                    fontFamily: 'Cairo',
                                                    fontSize: 14))))
                                        .toList(),
                                    prefixIcon: SvgPicture.asset(
                                      "assets/images/SVGs/country.svg",
                                      height: 24,
                                    )),
                              )
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                      BlocBuilder<CityCubit, CityState>(
                          builder: (context, cityState) {
                        if (cityState is CityLoading) {
                          return const Center(
                              child: CircularProgressIndicator.adaptive());
                        } else if (cityState is CityLoaded) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TitleTxt(txt: "resident_city".tr),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 24),
                                child: CustomDropDown(
                                    hintData: cityName == '' || cityName == null
                                        ? "قم باختيار المدينة"
                                        : cityName!,
                                    value: cityId,
                                    onChanged: (val) {
                                      cityState.response!.data!.map((e) {
                                        if (val.toString() == e.id.toString()) {
                                          cityName = e.name;
                                          cityId = val;
                                        }
                                      }).toList();
                                      setState(() {});
                                    },
                                    items: cityState.response!.data!
                                        .map(
                                          (e) => DropdownMenuItem(
                                              value: e.id.toString(),
                                              child: Text(e.name!,
                                                  style: const TextStyle(
                                                      fontFamily: 'Cairo',
                                                      fontSize: 14))),
                                        )
                                        .toList(),
                                    prefixIcon: SvgPicture.asset(
                                      'assets/images/SVGs/city1.svg',
                                      height: 24,
                                    )),
                              ),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                      TitleTxt(txt: "gender".tr),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("female".tr,
                              style: Constants.secondaryTitleRegularFont),
                          Radio(
                              value: "0",
                              groupValue: genderValue,
                              onChanged: (s) {
                                setState(() {
                                  genderValue = s;
                                });
                              }),
                          const SizedBox(
                            width: 40,
                          ),
                          Text(
                            "male".tr,
                            style: Constants.secondaryTitleRegularFont,
                          ),
                          Radio(
                              value: "1",
                              groupValue: genderValue,
                              onChanged: (s) {
                                setState(() {
                                  genderValue = s;
                                });
                              }),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  )),
                );
              }
              return const SizedBox.shrink();
            })
          : const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
    );
  }
}
