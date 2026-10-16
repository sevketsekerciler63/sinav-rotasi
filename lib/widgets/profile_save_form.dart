import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../theme/app_motion.dart';

Future<T?> showRetainedBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = false,
  Color? backgroundColor,
  ShapeBorder? shape,
}) async {
  final navigator = Navigator.of(context);
  final route = ModalBottomSheetRoute<T>(
    builder: builder,
    isScrollControlled: isScrollControlled,
    backgroundColor: backgroundColor,
    shape: shape,
    capturedThemes: InheritedTheme.capture(
      from: context,
      to: navigator.context,
    ),
    isDismissible: false,
    enableDrag: false,
    useSafeArea: true,
    sheetAnimationStyle: AppMotion.reduced(context)
        ? AnimationStyle.noAnimation
        : const AnimationStyle(
            duration: AppMotion.standard,
            reverseDuration: AppMotion.standard,
          ),
  );
  final value = await navigator.push(route);
  await route.completed;
  return value;
}

Future<T?> showRetainedDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) async {
  final navigator = Navigator.of(context, rootNavigator: true);
  final route = DialogRoute<T>(
    context: context,
    builder: builder,
    barrierDismissible: false,
  );
  final value = await navigator.push(route);
  await route.completed;
  return value;
}

class ProfileSaveForm extends StatefulWidget {
  final Widget Function(
    BuildContext,
    Future<void> Function(Future<bool> Function()),
  )
  builder;
  const ProfileSaveForm({super.key, required this.builder});
  @override
  State<ProfileSaveForm> createState() => _ProfileSaveFormState();
}

class _ProfileSaveFormState extends State<ProfileSaveForm> {
  late final String profile = context.read<AppState>().activeProfile.id;
  bool busy = false;
  String? error;
  Future<void> submit(Future<bool> Function() save) async {
    if (busy) return;
    final state = context.read<AppState>();
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      busy = true;
      error = null;
    });
    try {
      if (state.activeProfile.id != profile || state.isProfileTransitioning) {
        throw const FormatException(
          'Profil değişti. Formu kapatıp yeniden aç.',
        );
      }
      final ok = await save();
      if (!mounted) return;
      if (ok) {
        Navigator.pop(context);
        return;
      }
      error = state.recordSaveError ?? 'Kayıt yapılamadı. Yeniden dene.';
    } on FormatException catch (exception) {
      error = exception.message;
    } catch (_) {
      error = 'Kayıt yapılamadı. Alanları kontrol edip yeniden dene.';
    }
    if (mounted) setState(() => busy = false);
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !busy,
    child: SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FocusScope(
            canRequestFocus: !busy,
            descendantsAreFocusable: !busy,
            child: AbsorbPointer(
              absorbing: busy,
              child: widget.builder(context, submit),
            ),
          ),
          if (busy)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text('Kaydediliyor…'),
            ),
          if (error != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          TextButton(
            onPressed: busy ? null : () => Navigator.pop(context),
            child: const Text('Vazgeç'),
          ),
        ],
      ),
    ),
  );
}

Future<void> showRecordResult(BuildContext context, Future<bool> result) async {
  final state = context.read<AppState>();
  final ok = await result;
  if (!ok && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          state.recordSaveError ?? 'Kayıt yapılamadı. Yeniden dene.',
        ),
      ),
    );
  }
}
