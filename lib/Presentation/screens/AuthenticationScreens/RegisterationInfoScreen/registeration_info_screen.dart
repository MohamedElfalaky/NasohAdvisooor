import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nasooh/Presentation/widgets/my_button.dart';

import '../../../../Data/cubit/authentication/country_cubit/country_cubit.dart';
import '../../../../Data/cubit/authentication/country_cubit/country_state.dart';
import '../../../../Data/cubit/authentication/nationality_cubit/nationality_cubit.dart';
import '../../../../Data/cubit/authentication/options_cubit/options_cubit.dart';
import '../../../../Data/cubit/authentication/options_cubit/options_state.dart';
import '../../../../Data/cubit/authentication/register_cubit/register_cubit.dart';
import '../../../../Data/cubit/authentication/register_cubit/register_state.dart';
import '../../../../app/constants.dart';
import '../../../../app/style/icons.dart';
import '../../../../app/style/sizes.dart';
import '../../../widgets/row_modal_sheet.dart';
import '../../../widgets/shared.dart';
import '../LoginScreen/check_mob_screen.dart';
import '../RegisterationPinCodeConfirm/my_drop_list_column.dart';

class RegistrationInfoScreen extends StatefulWidget {
  const RegistrationInfoScreen({super.key});

  @override
  State<RegistrationInfoScreen> createState() => _RegistrationInfoScreenState();
}

class _RegistrationInfoScreenState extends State<RegistrationInfoScreen> {
  static final ImagePicker _picker = ImagePicker();
  static XFile? regImage;
  dynamic inputGender;

  static final TextEditingController _nameController = TextEditingController();
  static final TextEditingController _emailController = TextEditingController();
  static final TextEditingController promoCode = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? base64Image;

  Future pickImage(ImageSource source, BuildContext context, setState) async {
    final myImage = await _picker.pickImage(source: source, imageQuality: 60);
    if (myImage == null) return;

    setState(() {
      regImage = myImage;
    });
    List<int> imageBytes = File(regImage!.path).readAsBytesSync();
    base64Image = base64.encode(imageBytes);
    log("base64Image!  is $base64Image");

    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  String? knowUsId;

  @override
  void initState() {
    regImage = null;
    _nameController.text = "";
    _emailController.text = "";
    context.read<CountryCubit>().getCountries();
    context.read<NationalityCubit>().getNationality();
    context.read<OptionsCubit>().getOptions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Constants.whiteAppColor,
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: Form(
                  key: _formKey,
                  child: BlocBuilder<RegisterCubit, RegisterState>(
                      builder: (context, state) => Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(
                                height: 16,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("create_new_account".tr,
                                      textAlign: TextAlign.right,
                                      style: Constants.headerNavigationFont),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  const GoBack(),
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),
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
                                                backgroundImage: regImage ==
                                                        null
                                                    ? const AssetImage(
                                                        'assets/images/PNG/no_profile_photo.png')
                                                    : FileImage(
                                                        File(regImage!.path),
                                                      ) as ImageProvider,
                                              )),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: InkWell(
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                // <-- SEE HERE
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                  top: Radius.circular(25.0),
                                                ),
                                              ),
                                              builder: (ctx) {
                                                return Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            18),
                                                    // height: 100,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        RowModalSheet(
                                                            txt: "كاميرا",
                                                            imageIcon:
                                                                cameraIcon,
                                                            onPressed: () {
                                                              pickImage(
                                                                  ImageSource
                                                                      .camera,
                                                                  ctx,
                                                                  setState);
                                                              // inputImageName =
                                                              //     RegistrationController
                                                              //         .regImage!.path;
                                                              // inputImagePhoto =
                                                              //     RegistrationController
                                                              //         .regImage;
                                                              // print(
                                                              //     "Image PAth is $inputImageName");
                                                            }),
                                                        const Divider(),
                                                        RowModalSheet(
                                                          txt: "الاستديو",
                                                          imageIcon:
                                                              galleryIcon,
                                                          onPressed: () {
                                                            pickImage(
                                                                ImageSource
                                                                    .gallery,
                                                                ctx,
                                                                setState);
                                                          },
                                                        ),
                                                        const Divider(),
                                                        RowModalSheet(
                                                          txt: "الغاء",
                                                          imageIcon: closeIcon,
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
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
                              Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  child: Text("Personal Information".tr,
                                      textAlign: TextAlign.end,
                                      style: Constants.subtitleFontBold
                                          .copyWith(fontSize: 16))),
                              TitleTxt(
                                txt: "Name".tr,
                              ),
                              InputTextField(
                                keyboardType: TextInputType.text,
                                hintTxt: "Name".tr,
                                imageTxt: "assets/images/SVGs/name_icon.svg",
                                controller: _nameController,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "name Required".tr;
                                  } else if (val.length > 33 ||
                                      val.length < 2) {
                                    return "name length".tr;
                                  }
                                  return null;
                                },
                                onChanged: (val) {},
                              ),
                              TitleTxt(txt: "email".tr),
                              InputTextField(
                                validator: (val) {
                                  if (val!.isEmpty ||
                                      !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                          .hasMatch(val)) {
                                    return "email_required".tr;
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.emailAddress,
                                hintTxt: "example@example.com",
                                imageTxt: "assets/images/SVGs/email_icon.svg",
                                controller: _emailController,
                              ),
                              const TitleTxt(
                                txt: "كود الدعوة",
                              ),
                              InputTextField(
                                keyboardType: TextInputType.emailAddress,
                                hintTxt: "برجاء إدخال كود الدعوة إن وٌجد",
                                imageTxt: "assets/images/SVGs/advisor_icon.svg",
                                controller: promoCode,
                              ),
                              BlocBuilder<OptionsCubit, OptionsState>(
                                  builder: (context, state) {
                                if (state is OptionsLoading) {
                                  return const SizedBox(
                                      width: double.infinity,
                                      child: Center(
                                          child: CircularProgressIndicator
                                              .adaptive()));
                                } else if (state is OptionsLoaded) {
                                  // print('nationality loaded');
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      TitleTxt(
                                        txt: "كيف عرفت التطبيق".tr,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10, bottom: 24),
                                        child: CustomDropDown(
                                            hintData: "كيف عرفتنا",
                                            value: knowUsId,
                                            onChanged: (val) {
                                              knowUsId = val;
                                            },
                                            items: state.response!.data!
                                                .map((e) => DropdownMenuItem(
                                                    value: e.id.toString(),
                                                    child: Text(e.name!)))
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
                              Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: Text("Additional Information".tr,
                                      textAlign: TextAlign.end,
                                      style: Constants.subtitleFontBold
                                          .copyWith(fontSize: 16))),
                              const NationalityAndCountryWidget(),
                              const SizedBox(height: 16),
                              Text("gender".tr,
                                  textAlign: TextAlign.right,
                                  style: Constants.secondaryTitleRegularFont),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("female".tr,
                                      style:
                                          Constants.secondaryTitleRegularFont),
                                  Radio(
                                      value: 0,
                                      groupValue: inputGender,
                                      onChanged: (s) {
                                        setState(() {
                                          inputGender = s;
                                        });
                                      }),
                                  const SizedBox(width: 48),
                                  Text(
                                    "male".tr,
                                    style: Constants.secondaryTitleRegularFont,
                                  ),
                                  Radio(
                                      value: 1,
                                      groupValue: inputGender,
                                      onChanged: (s) {
                                        setState(() {
                                          inputGender = s;
                                        });
                                      }),
                                ],
                              ),
                              state is RegisterLoading
                                  ? const CustomLoadingButton()
                                  : Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 25),
                                      width: double.infinity,
                                      height: 48,
                                      child: CustomElevatedButton(
                                        onPressedHandler: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            context
                                                .read<RegisterCubit>()
                                                .registerMethod(
                                                  context: context,
                                                  mobile: sendPhone,
                                                  knowUsId: knowUsId ?? "",
                                                  promoCode: promoCode.text,
                                                  avatar: base64Image ?? "",
                                                  countryId: inputCountry ?? "",
                                                  cityId: inputCity ?? "",
                                                  email: _emailController.text,
                                                  fullName:
                                                      _nameController.text,
                                                  gender: inputGender,
                                                  nationalityId:
                                                      inputNationality ?? "",
                                                );
                                          }
                                        },
                                        txt: "register".tr,
                                        isBold: true,
                                      ),
                                    ),
                            ],
                          )))),
        ),
      ),
    );
  }
}
