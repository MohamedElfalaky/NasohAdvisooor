import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nasooh/Presentation/screens/TermsConditionsScreen/terms_conditions_screen.dart';
import 'package:nasooh/Presentation/widgets/my_button.dart';
// import 'package:nasooh/app/Style/icons.dart';

import '../../../../Data/cubit/authentication/new_mob/mob_cubit.dart';
import '../../../../Data/cubit/authentication/new_mob/mob_state.dart';
// import '../../../../app/Style/sizes.dart';
import '../../../../app/constants.dart';
import '../../../../app/style/icons.dart';
import '../../../../app/style/sizes.dart';
import '../../../../app/utils/my_application.dart';
import '../../../widgets/phone_text_field.dart';

String sendPhone = "";

class CheckMobScreen extends StatefulWidget {
  const CheckMobScreen({super.key});

  @override
  State<CheckMobScreen> createState() => _CheckMobScreenState();
}

class _CheckMobScreenState extends State<CheckMobScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late AnimationController _fadeController;
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000));
    _animationController.forward();

    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500));
    _fadeController.forward();
  }

  bool termsVal = false;

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
    _fadeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Image.asset(
            onBoardingPNGbk,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: const Color.fromARGB(0, 168, 46, 46),
          resizeToAvoidBottomInset: false,
          body: Form(
            key: _formKey,
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.only(
                top: 16,
                right: 16,
                left: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: BlocBuilder<MobCubit, MobState>(
                    builder: (context, state) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SlideTransition(
                          position: Tween<Offset>(
                                  begin: const Offset(0, -3),
                                  end: const Offset(0, 0.1))
                              .animate(_animationController),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 24, top: 44),
                            child: Center(
                              child: SvgPicture.asset(
                                "assets/images/SVGs/soNew.svg",
                                width: 148,
                                height: 148,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height(context) * 0.08),
                        Text(
                          "phone_number".tr,
                          textAlign: TextAlign.right,
                          style: Constants.mainTitleRegularFont,
                        ),
                        FadeTransition(
                          opacity: _fadeController,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: MyIntlPhoneField(
                              countries: const ['SA'],
                              controller: _phoneController,
                              showDropdownIcon: true,
                              dropdownIcon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.transparent,
                                size: 6,
                              ),
                              style: Constants.subtitleFont1,
                              // dropdownIconPosition: IconPosition.trailing,
                              textAlign: TextAlign.right,
                              decoration: InputDecoration(
                                hintText: "رقم الجوال...",
                                hintStyle: Constants.subtitleRegularFontHint,
                                errorStyle: Constants.subtitleFont1.copyWith(
                                  color: Colors.red,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  gapPadding: 0,
                                  borderSide: const BorderSide(
                                    color: Color(0xff808488),
                                  ),
                                ),
                              ),
                              initialCountryCode: 'SA',
                              onChanged: (phone) {
                                // print(phone.completeNumber);
                                sendPhone = phone.completeNumber;
                              },
                              invalidNumberMessage: "invalid_number".tr,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: termsVal,
                              onChanged: (value) {
                                setState(() {
                                  termsVal = !termsVal;
                                });
                              },
                            ),
                            GestureDetector(
                              onTap: (){
                                MyApplication.navigateTo(context, TermsConditionsScreen());
                              },
                              child: Text(
                                "أوافق علي جميع الشروط و الأحكام",
                                style: Constants.secondaryTitleRegularFont,
                              ),
                            )
                          ],
                        ),

                        // CheckboxMenuButton(
                        //     style: ButtonStyle(
                        //         padding: MaterialStateProperty.all(
                        //             EdgeInsets.zero)),
                        //     value: termsVal,
                        //     onChanged: (value) {
                        //       setState(() {
                        //         termsVal = !termsVal;
                        //       });
                        //     },
                        //     child: const Text(
                        //       "أوافق علي جميع الشروط و الأحكام",
                        //       style: Constants.secondaryTitleRegularFont,
                        //     )),
                        const SizedBox(
                          height: 24,
                        ),
                        state is MobLoading
                            ? const CustomLoadingButton()
                            : FadeTransition(
                                opacity: _fadeController,
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: CustomElevatedButton(
                                    isBold: true,
                                    txt: "التالي",
                                    onPressedHandler: () {
                                      if (!termsVal) {
                                        MyApplication.showToastView(
                                            message:
                                                "فضلا وافق علي الشروط و الأحكام");
                                      } else if (_formKey.currentState!
                                          .validate()) {
                                        context.read<MobCubit>().checkMobMethod(
                                            context: context, phone: sendPhone);
                                      }
                                    },
                                  ),
                                ),
                              ),
                        SizedBox(
                          height: height(context) * 0.2,
                        ),
                        // FadeTransition(
                        //   opacity: _fadeController,
                        //   child: Center(
                        //     child: SizedBox(
                        //       width: width(context) * 0.36,
                        //       height: 48,
                        //       child: CustomElevatedButton(
                        //         isBold: true,
                        //         txt: "login_guest".tr,
                        //         onPressedHandler: () {
                        //           MyApplication.navigateToReplace(context, const HomeLayout(currentIndex: 0));
                        //         },
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  )),
            ),
          ),
        ),
      ],
    );
  }
}
