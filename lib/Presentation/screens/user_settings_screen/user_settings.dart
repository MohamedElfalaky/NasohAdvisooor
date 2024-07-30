import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nasooh/Presentation/widgets/shared.dart';
import '../../../Data/cubit/authentication/delete_account_cubit/delete_account_cubit.dart';
import '../../../Data/cubit/authentication/delete_account_cubit/delete_account_state.dart';
import '../../../Data/cubit/settings_cubits/is_notification_cubit/is_notification_cubit.dart';
import '../../../app/constants.dart';
import '../../../app/style/icons.dart';
import '../../../app/utils/shared_preference.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({super.key});

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  int groupValue = 1;
  bool? isNotificationValue;

  @override
  void initState() {
    isNotificationValue = sharedPrefs.getIsNotification() == 1 ? true : false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context: context, txt: "settings".tr),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              // const SizedBox(
              //   height: 20,
              // ),
              // Row(
              //   children: [
              //     SvgPicture.asset(
              //       languageIcon,
              //       height: 20,
              //       width: 20,
              //     ),
              //     const SizedBox(
              //       width: 10,
              //     ),
              //     Text("change Language".tr,
              //         style: Constants.mainTitleFont),
              //   ],
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              // const ChangeLangItem(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Divider(),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                visualDensity: const VisualDensity(
                  horizontal: -4,
                  vertical: -4,
                ),
                leading: SvgPicture.asset(
                  notificationIcon,
                  height: 20,
                  width: 20,
                ),
                title: Text("Notification".tr,
                    style: Constants.mainTitleFont.copyWith(
                      letterSpacing: 0,
                      wordSpacing: 0,
                    )),
                trailing: Switch(
                  inactiveThumbColor: Colors.black,
                  inactiveTrackColor: Colors.grey,
                  value: isNotificationValue!,
                  onChanged: (value) {
                    setState(() {
                      isNotificationValue = value;
                    });
                    context.read<IsNotificationCubit>().isNotify();
                  },
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Divider(),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                visualDensity: const VisualDensity(
                  horizontal: -4,
                  vertical: -4,
                ),
                leading: SvgPicture.asset(deleteUser),
                title: InkWell(
                  onTap: () => _showDeleteDialog(context),
                  child: Text("Delete Account".tr,
                      style: Constants.mainTitleFont.copyWith(
                          letterSpacing: 0, wordSpacing: 0, color: Colors.red)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _showDeleteDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return BlocBuilder<DeleteAccountCubit, DeleteAccountState>(
          builder: (context, state) => AlertDialog(
                // <-- SEE HERE
                // title: const Text('Cancel booking'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text("delete tile".tr),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text("No".tr),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  state is DeleteAccountLoading
                      ? const Center(
                          child: CircularProgressIndicator.adaptive())
                      : TextButton(
                          child: Text("Yes".tr),
                          onPressed: () {
                            context.read<DeleteAccountCubit>().delete(
                                  context: context,
                                );
                            // Navigator.pop(context);
                          },
                        ),
                ],
              ));
    },
  );
}
