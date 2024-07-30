import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart' as u;
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:nasooh/Data/cubit/send_chat_cubit/send_chat_cubit.dart';
import 'package:nasooh/Data/cubit/send_chat_cubit/send_chat_state.dart';
import 'package:nasooh/Data/cubit/show_advice_cubit/show_advice_cubit/show_advice_cubit.dart';
import 'package:nasooh/Data/cubit/show_advice_cubit/show_advice_cubit/show_advice_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import '../../../Data/models/advisor_profile_model/advisor_profile.dart';
import '../../../app/style/icons.dart';
import '../../../app/style/sizes.dart';
import '../../../app/utils/exports.dart';
import '../../widgets/custom_loading_widget.dart';
import 'widgets/can_not_speak.dart';
import 'widgets/custom_app_bar.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      {super.key,
      this.adviserProfileData,
      required this.adviceId,
      required this.description,
      this.openedStatus = false,
      this.labelToShow = false,
      this.statusClickable = false});

  final AdviserProfileData? adviserProfileData;
  final int adviceId;
  final bool labelToShow;
  final bool? openedStatus;
  final bool statusClickable;
  final String description;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController chatController = TextEditingController();

  File? voiceSelected;
  File? pickedFile;
  late SendChatCubit sendChatCubit;
  late ShowAdviceCubit showAdviceCubit;

  final record = AudioRecorder();
  File? voiceFile;
  bool isRecording = false;
  Timer? countdownTimer;

  void startTimer() {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {});
    });
  }

  void startRecord() async {
    await openTheRecorder();
    startTimer();
    String uniqueKey = const u.Uuid().v4() +
        DateTime.now().toIso8601String().replaceAll('.', '-');
    Directory tempDir = await getApplicationDocumentsDirectory();
    String tempPath = tempDir.path;
    if (Platform.isIOS) {
      voiceFile = File('$tempPath/$uniqueKey.m4a');
    } else {
      voiceFile = File('$tempPath/$uniqueKey.mp3');
    }
    record.stop();
    record.start(const RecordConfig(), path: voiceFile!.path).then((value) {
      isRecording = true;
      setState(() {});
    }).onError((error, stackTrace) {
      isRecording = false;
    });
  }

  stopRecord() async {
    countdownTimer?.cancel();
    await record.stop();
    isRecording = false;
    if (voiceFile!.existsSync()) {
      voiceSelected = voiceFile;
    }
    setState(() {});
  }

  Future<void> openTheRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted && await record.hasPermission()) {
      throw Exception('Microphone permission not granted');
    }
  }

  final player = AudioPlayer();

  int playingIndex = -1;

  Future<void> playAudioFromUrl(String url, int index) async {
    if (playingIndex == index) {
      await player.stop();
      setState(() {
        playingIndex = -1; // Reset playingIndex
      });
    } else {
      await player.play(UrlSource(url));

      player.onPlayerComplete.listen((event) {
        setState(() {
          playingIndex = -1; // Reset playingIndex
        });
      });

      setState(() {
        playingIndex = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    sendChatCubit = context.read<SendChatCubit>();
    showAdviceCubit = context.read<ShowAdviceCubit>();
    sendChatCubit.emitChatInitial();
    showAdviceCubit.getAdviceFunction(adviceId: widget.adviceId);
  }

  @override
  void dispose() {
    super.dispose();
    chatController.clear();
    player.dispose();
  }

  deleteRecord() async {
    await record.stop();
    isRecording = false;
    voiceFile = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SendChatCubit, SendChatState>(
      listener: (context, state) {
        if (state is SendChatLoaded) {
          showAdviceCubit.getAdviceFunction(adviceId: widget.adviceId);
          chatController.clear();
          pickedFile = null;
          voiceSelected = null;
          setState(() {});
        }
      },
      child: Scaffold(
          appBar: customChatAppBar(context),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 18),
                child: OutlinedAdvisorCard(
                  description: widget.description,
                  labelToShow: widget.labelToShow,
                  adviceId: widget.adviceId,
                  adviserProfileData: widget.adviserProfileData,
                  isClickable: widget.statusClickable,
                ),
              ),
              // const ShowMessagesWidget(),
              Expanded(
                  child: BlocBuilder<ShowAdviceCubit, ShowAdviceState>(
                buildWhen: (previous, current) {
                  return current is! ShowAdviceLoading;
                },
                builder: (context, state) {
                  if (state is ShowAdviceLoaded) {
                    return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ListView.builder(
                          reverse: true,
                          itemCount: state.response?.data?.chat?.length,
                          itemBuilder: (context, index) =>
                              buildAlign(state, index, context),
                        ));
                  } else if (state is ShowAdviceError) {
                    return const SizedBox.shrink();
                  } else {
                    return const CustomLoadingIndicator();
                  }
                },
              )),
              widget.openedStatus == true
                  ? Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        children: [
                          if (voiceSelected != null)
                            Row(
                              children: [
                                buildVoiceShapeWidget(context),
                              ],
                            ),
                          if (pickedFile != null)
                            pickedFile!.path.endsWith('.pdf')
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                            padding: const EdgeInsets.all(5),
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 5),
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
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                    child: Text(
                                                  pickedFile!.path
                                                      .replaceRange(0, 56, ""),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )),
                                                const SizedBox(width: 10),
                                                SvgPicture.asset(
                                                  filePdf,
                                                  width: 20,
                                                  height: 20,
                                                ),
                                              ],
                                            )),
                                      ),
                                      if (pickedFile != null)
                                        IconButton(
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
                                    ],
                                  )
                                : Container(
                                    padding: const EdgeInsets.all(5),
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    height: 50,
                                    width: width(context),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      children: [
                                        Flexible(
                                            child: Text(
                                          pickedFile!.path,
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                          maxLines: 1,
                                        )),
                                        const SizedBox(width: 5),
                                        //
                                        Image.file(
                                          File(pickedFile!.path),
                                          width: 25,
                                          height: 25,
                                        ),
                                        if (pickedFile != null)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: CircleAvatar(
                                              radius: 15,
                                              backgroundColor:
                                                  Colors.grey.shade200,
                                              child: IconButton(
                                                padding: EdgeInsets.zero,
                                                icon: const Icon(
                                                  Icons.close,
                                                  color: Colors.black,
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    pickedFile = null;
                                                    // fileSelected = null;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                      ],
                                    )),
                          const SizedBox(width: 20),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: chatController,
                                  decoration: Constants.setTextInputDecoration(
                                    isSuffix: true,
                                    suffixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        GestureDetector(
                                            onTap: () async {
                                              FilePickerResult? result =
                                                  await FilePicker.platform
                                                      .pickFiles();
                                              if (result != null) {
                                                setState(() {
                                                  pickedFile = File(
                                                      result.files.first.path!);
                                                });
                                              }
                                              return;
                                            },
                                            child:
                                                SvgPicture.asset(attachFiles)),
                                        const SizedBox(width: 8),
                                        isRecording
                                            ? GestureDetector(
                                                onTap: () {
                                                  stopRecord();
                                                },
                                                child: const Icon(
                                                    Icons.stop_circle_outlined))
                                            : GestureDetector(
                                                onTap: startRecord,
                                                child: SvgPicture.asset(micee)),
                                        const SizedBox(width: 8)
                                      ],
                                    ),
                                    hintText: isRecording
                                        ? " جار التسجيل...  ${countdownTimer?.tick} ثواني "
                                        : "آكتب رسالتك...",
                                  ).copyWith(
                                    hintStyle: Constants.subtitleRegularFontHint
                                        .copyWith(
                                            color: const Color(0XFF5C5E6B)),
                                    enabledBorder: const OutlineInputBorder(
                                      gapPadding: 0,
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
                                    ),
                                    filled: true,
                                    fillColor: const Color(0xffF5F4F5),
                                  ),
                                ),
                              ),
                              if (!isRecording) buildRecordingWidget()
                            ],
                          ),
                        ],
                      ),
                    )
                  : const CanNotSpeak()
            ],
          )),
    );
  }

  BlocBuilder<ShowAdviceCubit, ShowAdviceState> buildRecordingWidget() {
    return BlocBuilder<ShowAdviceCubit, ShowAdviceState>(
      builder: (context, state2) {
        return BlocBuilder<SendChatCubit, SendChatState>(
          builder: (context, state3) {
            return GestureDetector(
              onTap: () async {
                if (state2 is ShowAdviceLoading || state3 is SendChatLoading) {
                  return;
                }
                if (pickedFile != null) {
                  var fileLength = await pickedFile!.length();
                  debugPrint('file length is $fileLength');
                  if (fileLength >= 5242880 == true) {
                    MyApplication.showToastView(
                        message: ' 5 MB لا يمكن ان يتعدي الملف');
                    return;
                  } else {
                    context.read<SendChatCubit>().sendChatFunction(
                        file: pickedFile,
                        msg: chatController.text,
                        adviceId: widget.adviceId.toString());
                    setState(() {
                      pickedFile = null;
                    });
                  }
                } else if (voiceFile != null) {
                  log(voiceSelected?.path ?? "", name: "the voice is");
                  // log(voiceSelected?.path??""  , name: "the voice is");
                  context.read<SendChatCubit>().sendChatFunction(
                      file: voiceSelected,
                      msg: chatController.text,
                      adviceId: widget.adviceId.toString());
                  setState(() {
                    voiceSelected = null;
                    voiceFile = null;
                  });
                } else if (chatController.text.isNotEmpty) {
                  context.read<SendChatCubit>().sendChatFunction(
                      file: pickedFile,
                      msg: chatController.text,
                      adviceId: widget.adviceId.toString());
                  log("printed");
                }
              },
              child: Container(
                  margin: const EdgeInsetsDirectional.only(start: 8),
                  padding: const EdgeInsets.all(10),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color(0XFF273043)),
                  child: state3 is SendChatLoading?
                      ? const CustomLoadingIndicator()
                      : SvgPicture.asset(sendChat)),
            );
          },
        );
      },
    );
  }

  buildVoiceShapeWidget(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.symmetric(vertical: 5),
        height: 50,
        // width: width(context),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                offset: const Offset(5.0, 5.0),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              )
            ],
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            SvgPicture.asset(voiceShape),
            if (voiceFile != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: CircleAvatar(
                  backgroundColor: Colors.grey.shade400,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        voiceFile = null;
                        voiceSelected = null;
                      });
                    },
                  ),
                ),
              ),
          ],
        ));
  }

  Align buildAlign(ShowAdviceLoaded state, int index, BuildContext context) {
    return Align(
      alignment: state.response?.data?.chat?[index].client == null
          ? AlignmentDirectional.centerStart
          : AlignmentDirectional.centerEnd,
      child: state.response?.data?.chat?[index].mediaType == "1"
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                state.response?.data?.chat?[index].message == null
                    ? const SizedBox()
                    : Container(
                        constraints: const BoxConstraints(maxWidth: 220),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: state.response?.data?.chat?[index].client ==
                                    null
                                ? const Color.fromARGB(255, 185, 184, 180)
                                    .withOpacity(0.2)
                                : Constants.primaryAppColor.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20)),
                        child: Linkify(
                          onOpen: (value) {
                            launchUrl(Uri.parse(value.url));
                          },
                          text:
                              state.response?.data?.chat?[index].message ?? "",
                          style: Constants.subtitleFont,
                        )),
                state.response?.data?.chat?[index].document?.isEmpty ?? false
                    ? const SizedBox.shrink()
                    : GestureDetector(
                        onTap: () {
                          if (isImage(
                              '${state.response?.data!.chat?[index].document![0].file}')) {
                            showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    contentPadding: EdgeInsets.zero,
                                    content: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            '${state.response!.data!.chat![index].document![0].file}',
                                      ),
                                    ),
                                  );
                                });
                          } else {
                            launchUrl(Uri.parse(
                                '${state.response?.data?.chat?[index].document?[0].file}'));
                          }
                        },
                        child: Container(
                          width: width(context) * 0.7,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey.shade400)),
                          child: (state.response?.data?.chat?[index]
                                              .document?[0].file
                                              ?.endsWith("mp4") ??
                                          false) &&
                                      (state.response?.data?.chat?[index]
                                              .document?[0].type ==
                                          "audio") ||
                                  (state.response?.data?.chat?[index]
                                          .document?[0].file
                                          ?.endsWith("m4a") ??
                                      false) ||
                                  (state.response?.data?.chat?[index]
                                          .document?[0].file
                                          ?.endsWith("mp3") ??
                                      false)
                              ? GestureDetector(
                                  onTap: () => playAudioFromUrl(
                                    state.response?.data?.chat?[index]
                                            .document?[0].file ??
                                        "",
                                    index,
                                  ),
                                  child: playingIndex == index
                                      ? audioPlayingWidget()
                                      : audioStopWidget(),
                                )
                              : chatImageWidget(state, index),
                        ),
                      ),
              ],
            )
          : Container(
              constraints: const BoxConstraints(maxWidth: 220),
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(8),
              // constraints: BoxConstraints(mi),
              decoration: BoxDecoration(
                  color: state.response?.data?.chat?[index].client == null
                      ? const Color.fromARGB(255, 185, 184, 180)
                          .withOpacity(0.2)
                      : Constants.primaryAppColor.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20)),
              child: Linkify(
                onOpen: (value) {
                  launchUrl(Uri.parse(value.url));
                },
                text: state.response?.data?.chat?[index].message ?? "",
                style: Constants.subtitleFont,
              )),
    );
  }

  chatImageWidget(ShowAdviceLoaded state, int index) {
    String file = state.response?.data?.chat?[index].document?[0].file ?? '';
    return Row(
      children: [
        isImage(file)
            ? ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: CachedNetworkImage(
                  width: 50,
                  height: 50,
                  imageUrl:
                      '${state.response?.data?.chat?[index].document?[0].file}',
                  placeholder: (c, g) {
                    return const CustomLoadingIndicator();
                  },
                  errorWidget: (c, g, h) {
                    return const Center(
                      child: Icon(
                        Icons.error,
                        color: Colors.red,
                      ),
                    );
                  },
                ),
              )
            : isPDF(file)
                ? SvgPicture.asset(filePdf)
                : isMP4(file) &&
                        state.response?.data?.chat?[index].document?[0].type ==
                            "video"
                    ? SvgPicture.asset(mp4Icon)
                    : const SizedBox.shrink(),
        if (isPDF(file) || isImage(file) || isMP4(file))
          const Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                'اضغط لرؤية الملف',
                maxLines: 2,
                overflow: TextOverflow.clip,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                ),
              ),
            ),
          ),
        const SizedBox(width: 7),
      ],
    );
  }

  Row audioStopWidget() {
    return Row(
      children: [
        SizedBox(
          height: 40,
          width: 205,
          child: SvgPicture.asset(voiceShape, fit: BoxFit.fill),
        ),
        const SizedBox(width: 5),
        CircleAvatar(
            backgroundColor: Constants.primaryAppColor,
            child: SvgPicture.asset(voice)),
      ],
    );
  }

  Row audioPlayingWidget() {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(
        height: 40,
        width: 210,
        child: Image.asset('assets/images/PNG/gifnasoh.gif', fit: BoxFit.fill),
      ),
      const SizedBox(width: 10),
      const CircleAvatar(
          backgroundColor: Constants.primaryAppColor,
          child: Icon(Icons.pause, color: Colors.white)),
    ]);
  }
}

bool isImage(String file) =>
    file.endsWith('png') || file.endsWith('jpg') || file.endsWith('jpeg');

bool isPDF(file) => file.endsWith('pdf');

bool isMP4(file) => file.endsWith('mp4');
