import 'dart:io';

import 'package:get/get.dart';
import 'package:nasooh/Presentation/screens/AuthenticationScreens/LoginScreen/check_mob_screen.dart';
import 'package:nasooh/app/utils/exports.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../Data/cubit/authentication/log_out_cubit/log_out_cubit.dart';
import '../../../../Data/cubit/authentication/log_out_cubit/log_out_state.dart';
import '../../../../app/style/icons.dart';
import '../../../../app/utils/shared_preference.dart';
import '../../../widgets/shared.dart';
import '../list_drawer.dart';
import 'widgets/user_info_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: customABarNoIcon(
          txt: "personal_profile", context: context, back: false),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 16),
        child: SingleChildScrollView(
            // physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const UserInfoCard(),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) => BuildItem(
                      drawerModel: getDrawer(context)[index],
                    ),
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.grey[300],
                      height: 1,
                      thickness: 1,
                    ),
                    itemCount: getDrawer(context).length,
                  ),
                ),
                Divider(
                  color: Colors.grey[300],
                  height: 1,
                  thickness: 1,
                ),
                const SizedBox(height: 6),
                if (sharedPrefs.getToken() != '')
                  BlocBuilder<LogOutCubit, LogOutState>(
                    builder: (context, state) => state is LogOutLoading
                        ? const Center(
                            child: CircularProgressIndicator.adaptive())
                        : ListTile(
                            minLeadingWidth: 0,
                            onTap: () {
                              context.read<LogOutCubit>().logOut(
                                    context: context,
                                  );
                            },
                            title: Text(
                              "signout".tr,
                              style: Constants.mainTitleFont,
                            ),
                            leading: SvgPicture.asset(
                              logoutIcon,
                            ),
                          ),
                  )
                else
                  ListTile(
                    minLeadingWidth: 0,
                    onTap: () {
                      MyApplication.navigateToReplaceAllPrevious(
                          context, const CheckMobScreen());
                    },
                    title: Text(
                      "login".tr,
                      style: Constants.mainTitleFont,
                    ),
                    leading: SvgPicture.asset(
                      logoutIcon,
                    ),
                  ),
                Platform.isAndroid
                    ? Center(
                        child: Container(
                          margin: const EdgeInsets.only(top: 80, bottom: 10),
                          width: MediaQuery.of(context).size.width * 0.42,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Constants.primaryAppColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.share,
                                color: Colors.white,
                              ),
                              label: Text(
                                "share_app".tr,
                                style: Constants.subtitleFont1.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 80,
                      ),
                Center(
                  child: Text(
                      "if you are specialist and want to register as adviser download advisers app"
                          .tr,
                      style: Constants.subtitleRegularFontHint.copyWith(
                        color: Colors.black,
                      )),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        launchUrl(Uri.parse(
                            'https://apps.apple.com/eg/app/%D9%86%D8%A7%D8%B5%D8%AD/id6475194728'));
                      },
                      child: Image.asset(
                        appStoreIcon,
                        fit: BoxFit.fill,
                        width: 35,
                        height: 35,
                      ),
                    ),
                    if (!Platform.isIOS) ...[
                      const SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          launchUrl(Uri.parse(
                              'https://play.google.com/store/apps/details?id=com.lun.nasooh.NASE7'));
                        },
                        child: Image.asset(
                          googlePlayIcon,
                          fit: BoxFit.fill,
                          width: 35,
                          height: 35,
                        ),
                      ),
                    ]
                  ],
                ),
                const SizedBox(height: 15),
              ],
            )),
      ),
    );
  }
}
