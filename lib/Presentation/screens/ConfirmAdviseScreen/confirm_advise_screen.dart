import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nasooh/Presentation/widgets/my_button.dart';
import 'package:nasooh/Presentation/widgets/shared.dart';
// import 'package:nasooh/app/Style/icons.dart';
// import 'package:nasooh/app/Style/sizes.dart';
import 'package:nasooh/app/constants.dart';
import 'package:nasooh/app/utils/my_application.dart';

import '../../../Data/cubit/send_advice_cubit/send_advise_cubit.dart';
import '../../../Data/cubit/send_advice_cubit/send_advise_state.dart';
import '../../../Data/models/advisor_profile_model/advisor_profile.dart';
import '../../../app/style/icons.dart';
import '../../../app/style/sizes.dart';
import '../CompleteAdviseScreen/complete_advise_screen.dart';

class ConfirmAdviseScreen extends StatefulWidget {
  const ConfirmAdviseScreen({
    super.key,
    required this.adviserProfileData,
  });

  final AdviserProfileData adviserProfileData;

  @override
  State<ConfirmAdviseScreen> createState() => _ConfirmAdviseScreenState();
}

class _ConfirmAdviseScreenState extends State<ConfirmAdviseScreen> {
  final TextEditingController requestTitle = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  File? pickedFile;

  @override
  void initState() {
    super.initState();

    context.read<SendAdviseCubit>().emitInitial();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BlocConsumer<SendAdviseCubit, SendAdviseState>(
          listener: (context, state) {
            if (state is SendAdviseLoaded) {
              MyApplication.navigateToReplace(context,
                  CompleteAdviseScreen(adviceId: state.response!.data!.id!));
            }
          },
          builder: (context, state) => state is SendAdviseLoading
              ? const Padding(
                  padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: CustomLoadingButton(height: 50),
                )
              : Container(
                  margin:
                      const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  height: 50,
                  child: CustomElevatedButton(
                    txt: "Confirm Order".tr,
                    isBold: true,
                    onPressedHandler: () {
                      // debugPrint(" ${pickedFile?.path.split(".").last}");
                      // log(fileSelected.toString());
                      if (pickedFile?.lengthSync() != null &&
                          pickedFile!.lengthSync() > 5242880) {
                        MyApplication.showToastView(
                            message: ' 5 MB لا يمكن ان يتعدي الملف');
                        return;
                      }
                      if (_formKey.currentState!.validate()) {
                        context.read<SendAdviseCubit>().sendAdviseMethod(
                            context: context,
                            adviserId: widget.adviserProfileData.id,
                            name: requestTitle.text,
                            description: descriptionController.text,
                            price: priceController.text,
                            file: pickedFile);
                      }
                    },
                  ))),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      resizeToAvoidBottomInset: false,
      extendBody: true,
      backgroundColor: Constants.whiteAppColor,
      appBar: customAppBar(context: context, txt: "Ask Advice".tr),
      body: Container(
          color: Constants.whiteAppColor,
          height: MediaQuery.of(context).size.height,
          margin: EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom,
              top: 15),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // OutlinedAdvisorCard(
                  //   labelToShow: true,
                  //   adviceId: 1,
                  //   adviserProfileData: widget.adviserProfileData,
                  //   isClickable: false,
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Text(
                      "Advice Title".tr,
                      style: Constants.secondaryTitleRegularFont,
                    ),
                  ),
                  TextFormField(
                    maxLength: 35,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    style: const TextStyle(fontFamily: Constants.mainFont),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Advice Title".tr;
                      } else if (value.length <= 17) {
                        return "Advice tilte should be more than 17 character"
                            .tr;
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: requestTitle,
                    decoration: Constants.setTextInputDecoration(
                        prefixIcon: const MyPrefixWidget(),
                        hintText:
                            "مثال: تشققات في الجدران .. أفضل وجهات في العلا"),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 5, top: 15),
                    child: Text("How Much can you afford for advice".tr,
                        style: Constants.secondaryTitleRegularFont),
                  ),
                  // TextFormField(
                  //   maxLength: 4,
                  //   autovalidateMode: AutovalidateMode.onUserInteraction,
                  //   validator: (value) {
                  //     if (value!.isEmpty) {
                  //       return "Price Needed".tr;
                  //     }
                  //     return null;
                  //   },
                  //   controller: priceController,
                  //   keyboardType: TextInputType.number,
                  //   decoration: Constants.setTextInputDecoration(
                  //       prefixIcon: const MyPrefixWidget(),
                  //       isSuffix: true,
                  //       hintText: "0.00",
                  //       suffixIcon: const Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           Padding(
                  //             padding: EdgeInsets.symmetric(horizontal: 8),
                  //             child: Text(
                  //               "ريال سعودي",
                  //               style: Constants.secondaryTitleRegularFont,
                  //             ),
                  //           ),
                  //         ],
                  //       )),
                  // ),
                  TextFormField(
                    maxLength: 4,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Price Needed".tr;
                      }
                      final price = double.tryParse(value);
                      if (price == null || price <= 1) {
                        return "الرجاء ادخال رقم صحيح";
                      }
                      return null;
                    },
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(
                          r'^\d*\.?\d*')), // Allow only digits and decimal point
                    ],
                    decoration: Constants.setTextInputDecoration(
                      prefixIcon: const MyPrefixWidget(),
                      isSuffix: true,
                      hintText: "0.00",
                      suffixIcon: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              "ريال سعودي",
                              style: Constants.secondaryTitleRegularFont,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Text("advice reject".tr,
                        style: const TextStyle(
                            fontSize: 10,
                            fontFamily: Constants.mainFont,
                            color: Constants.primaryAppColor)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(
                      "Advice Details".tr,
                      style: Constants.secondaryTitleRegularFont,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Advice details".tr;
                        } else if (value.length < 5) {
                          return "Advice details should be more than 5 character"
                              .tr;
                        }
                        return null;
                      },
                      controller: descriptionController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      maxLines: 5,
                      decoration: Constants.setTextInputDecoration(
                        isParagraphTextField: true,
                        fillColor: const Color(0XFFF5F4F5),
                        hintText: "Explain".tr,
                        // isSuffix: false
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(allowMultiple: false
                              // allowedExtensions: ['jpg','png','jpeg','doc'],

                              );

                      if (result != null) {
                        // if (result.files[0].bytes != null &&
                        //     result.files[0].bytes!.length > 5242880) {
                        //   MyApplication.showToastView(
                        //       message: ' 5 MB لا يمكن ان يتعدي الملف');
                        //   return;
                        // }
                        setState(() {
                          pickedFile = File(result.files.single.path!);
                        });
                        // List<int> imageBytes =
                        //     File(pickedFile!.path).readAsBytesSync();
                        // fileSelected = base64.encode(imageBytes);
                      }
                      return;
                    },
                    child: DottedBorder(
                      dashPattern: const [10, 6],
                      borderType: BorderType.RRect,
                      radius: const Radius.circular(8),
                      color: Colors.blue,
                      child: SizedBox(
                        height: 56,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.upload,
                              color: Color(0xFF0076FF),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "Upload Advice Files".tr,
                              style: Constants.subtitleFont,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  // SizedBox(height: 20,),
                  if (pickedFile != null)
                    pickedFile!.path.endsWith('.pdf')
                        ? Container(
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            height: 50,
                            width: width(context),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade300,
                                    offset: const Offset(
                                      5.0,
                                      5.0,
                                    ),
                                    blurRadius: 10.0,
                                    spreadRadius: 2.0,
                                  )
                                ],
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                const Spacer(),
                                Flexible(
                                    flex: 3,
                                    child: Text(pickedFile!.path
                                        .replaceRange(0, 56, ""))),
                                const SizedBox(
                                  width: 10,
                                ),
                                SvgPicture.asset(
                                  filePdf,
                                  width: 20,
                                  height: 20,
                                ),
                                if (pickedFile != null)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.grey.shade200,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            pickedFile = null;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                              ],
                            ))
                        : Container(
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.symmetric(vertical: 20),
                            // height: 50,

                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade300,
                                    offset: const Offset(
                                      5.0,
                                      5.0,
                                    ),
                                    blurRadius: 10.0,
                                    spreadRadius: 2.0,
                                  )
                                ],
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              children: [
                                Flexible(
                                    child: Text(
                                  pickedFile!.path,
                                  style: const TextStyle(fontSize: 10),
                                )),
                                Image.file(
                                  File(pickedFile!.path),
                                  height: 50,
                                  width: 50,
                                ),
                                if (pickedFile != null)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: CircleAvatar(
                                      radius: 15,
                                      backgroundColor: Colors.grey.shade200,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            pickedFile = null;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                              ],
                            )),
                ],
              ),
            ),
          )),
    );
  }
}
