import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/notification_service.dart';
import '../domain/drop.dart';
import '../data/drops_repository.dart';
import 'current_drop_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../notifications/data/notifications_provider.dart';

class ActiveExecutionPage extends ConsumerStatefulWidget {
  final Drop drop;

  const ActiveExecutionPage({super.key, required this.drop});

  @override
  ConsumerState<ActiveExecutionPage> createState() =>
      _ActiveExecutionPageState();
}

class _ActiveExecutionPageState extends ConsumerState<ActiveExecutionPage> {
  final _projectUrlController = TextEditingController();
  final _docUrlController = TextEditingController();
  // final _imageUrlController = TextEditingController(); // Replaced by file upload

  File? _selectedImageFile;
  String? _uploadedImageUrl;
  bool _isUploadingImage = false;

  bool _isSubmitting = false;

  // Timer State
  Timer? _countdownTimer;
  Duration _timeLeft = Duration.zero;
  bool _isTimerRunning = false;
  bool _isLoadingTimer = true;
  bool _isExpired = false;

  // Polling State
  Timer? _pollingTimer;
  int? _submissionId;
  String? _status;
  String? _feedback;
  int? _score;

  DateTime? _missionStartTime;

  @override
  void initState() {
    super.initState();
    _initTimer();
  }

  Future<void> _initTimer() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload(); // Ensure we have the latest data
    final key = 'drop_start_time_${widget.drop.id}';
    int? startTimeMillis = prefs.getInt(key);

    if (startTimeMillis == null) {
      _missionStartTime = DateTime.now();
      await prefs.setInt(key, _missionStartTime!.millisecondsSinceEpoch);

      // If Source B (External), show redirect dialog instead of instant launch
      if (widget.drop.sourceType == 'B' && widget.drop.sourceUrl != null) {
        // We delay slightly to let the UI build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showRedirectDialog();
        });
      }
    } else {
      _missionStartTime = DateTime.fromMillisecondsSinceEpoch(startTimeMillis);
    }

    _updateTimeLeft();
  }

  Future<void> _showRedirectDialog() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 30,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  color: Colors.blueAccent,
                  strokeWidth: 3,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                "CONNECTING TO SOURCE",
                style: GoogleFonts.spaceMono(
                  color: Colors.blueAccent,
                  fontSize: 12,
                  letterSpacing: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Redirecting to GitHub Repository...",
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Artificial Delay for Effect
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.of(context).pop(); // Close Dialog
      _launchSourceUrl(); // Finally Launch
    }
  }

  Future<void> _launchSourceUrl() async {
    if (widget.drop.sourceUrl == null) return;
    final uri = Uri.parse(widget.drop.sourceUrl!);
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $uri';
      }
    } catch (e) {
      debugPrint("Could not launch URL: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Could not open GitHub link: $e")),
        );
      }
    }
  }

  void _updateTimeLeft() {
    if (_missionStartTime == null) return;

    final now = DateTime.now();
    final elapsed = now.difference(_missionStartTime!);
    final limit = Duration(minutes: widget.drop.timeLimitMinutes);
    final remaining = limit - elapsed;

    if (mounted) {
      setState(() {
        if (remaining.isNegative) {
          _timeLeft = Duration.zero;
          _isExpired = true;
          _isLoadingTimer = false;
          _isTimerRunning = false;
          _countdownTimer?.cancel();
          // We do NOT clear mission state here automatically on load to avoid
          // jarring resets if the user just missed it by a second.
          // They will see "Time's Up" UI.
        } else {
          _timeLeft = remaining;
          _isLoadingTimer = false;
          if (!_isTimerRunning) {
            // Start Notification (One-time trigger when entering active state)
            NotificationService().showMissionTimer(
              widget.drop,
              _missionStartTime!
                  .add(Duration(minutes: widget.drop.timeLimitMinutes)),
            );
            _startTimer();
          }
        }
      });
    }
  }

  void _startTimer() {
    setState(() => _isTimerRunning = true);
    _countdownTimer?.cancel(); // Cancel any existing timer
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTimeLeft();
    });
  }

  @override
  void dispose() {
    _projectUrlController.dispose();
    _docUrlController.dispose();
    // _imageUrlController.dispose();
    _pollingTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImageFile = File(image.path);
        _isUploadingImage = true;
      });

      // Auto upload on pick
      await _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImageFile == null) return;

    try {
      final fileName =
          '${widget.drop.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = 'submissions/$fileName';

      // Assuming a public bucket named 'drop_assets' exists or similar
      final storage = Supabase.instance.client.storage.from('submissions');
      await storage.upload(path, _selectedImageFile!);

      final publicUrl = storage.getPublicUrl(path);

      setState(() {
        _uploadedImageUrl = publicUrl;
        _isUploadingImage = false;
      });
    } catch (e) {
      debugPrint(
          "Upload Error: $e. ACTION REQUIRED: Create 'submissions' bucket in Supabase Dashboard.");
      if (mounted) {
        setState(() => _isUploadingImage = false);

        String errorMessage = "Image Upload Failed";
        if (e.toString().contains("Bucket not found")) {
          errorMessage =
              "SETUP REQUIRED: Create 'submissions' bucket in Supabase Dashboard (Public).";
        } else if (e.toString().contains("statusCode: 403")) {
          errorMessage =
              "PERMISSION DENIED: Check RLS policies for 'submissions' bucket.";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: "Copy",
              textColor: Colors.white,
              onPressed: () =>
                  Clipboard.setData(ClipboardData(text: errorMessage)),
            ),
          ),
        );
      }
    }
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(d.inHours);
    String minutes = twoDigits(d.inMinutes.remainder(60));
    String seconds = twoDigits(d.inSeconds.remainder(60));
    return d.inHours > 0 ? "$hours:$minutes:$seconds" : "$minutes:$seconds";
  }

  void _startPolling(int submissionId) {
    _submissionId = submissionId;
    _status = 'evaluating';

    _pollingTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      try {
        final submission = await ref
            .read(dropsRepositoryProvider.notifier)
            .getSubmission(submissionId);

        if (submission.status.toLowerCase() == 'completed' ||
            submission.status.toLowerCase() == 'failed') {
          timer.cancel();

          try {
            NotificationService().cancelMissionTimer();
            ref.read(currentDropProvider.notifier).clearDrop();
          } catch (e) {
            debugPrint("Cleanup error: $e");
          }

          final isSuccess = submission.status.toLowerCase() == 'completed';
          final notificationTitle =
              isSuccess ? "Mission Accomplished!" : "Mission Failed";
          final notificationMessage = isSuccess
              ? "You successfully completed '${widget.drop.title}'. Reward: +${widget.drop.rewardXp} XP"
              : "Submission for '${widget.drop.title}' failed. Feedback: ${submission.feedback ?? 'Check requirements.'}";

          ref.read(notificationsProvider.notifier).addNotification(
                title: notificationTitle,
                message: notificationMessage,
                type: isSuccess
                    ? NotificationType.success
                    : NotificationType.error,
              );

          if (mounted) {
            setState(() {
              _status = submission.status.toLowerCase();
              _score = submission.score;
              _feedback = submission.feedback;
              _isSubmitting = false;
            });
            _showResultDialog();
          }
        }
      } catch (e) {
        debugPrint("Polling error: $e");
      }
    });
  }

  void _showResultDialog() {
    final isSuccess = _status == 'completed';
    final color = isSuccess ? const Color(0xFF00C853) : const Color(0xFFFF5252);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.1),
                ),
                child: Icon(
                  isSuccess ? Icons.check_circle_outline : Icons.error_outline,
                  color: color,
                  size: 48,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isSuccess ? "Mission Accomplished" : "Mission Failed",
                style: GoogleFonts.outfit(
                  color: theme.textTheme.titleLarge?.color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Score: $_score/100",
                style: GoogleFonts.outfit(
                  color:
                      theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.7),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isSuccess) ...[
                const SizedBox(height: 8),
                Text(
                  "+${widget.drop.rewardXp} ${widget.drop.domain.toUpperCase()} XP",
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF00C853),
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ).animate().scale(delay: 300.ms, curve: Curves.elasticOut),
              ],
              const SizedBox(height: 8),
              if (_feedback != null)
                Text(
                  _feedback!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    color: theme.textTheme.bodyMedium?.color,
                    fontSize: 14,
                  ),
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Start next drop or go home
                    // Also clear shared preferences for this drop maybe?
                    // For now keeping it simple.
                    Navigator.of(context).pop();
                    context.go('/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colors.white : Colors.black,
                    foregroundColor: isDark ? Colors.black : Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    "Continue",
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final projectUrl = _projectUrlController.text.trim();
    final docUrl = _docUrlController.text.trim();

    // Screenshots are required only for design/link submissions (Figma, etc.).
    // For code submissions (GitHub URLs), an image is optional.
    final bool isDesignSubmission = widget.drop.submissionType == 'link';
    final bool imageRequired = isDesignSubmission && _uploadedImageUrl == null;

    if (projectUrl.isEmpty || docUrl.isEmpty || imageRequired) {
      final message = imageRequired
          ? "Please fill all fields and upload a screenshot of your design"
          : "Please fill in all required fields";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: GoogleFonts.outfit()),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final submission = await ref
          .read(dropsRepositoryProvider.notifier)
          .submitDrop(
              dropId: widget.drop.id,
              submissionUrl: projectUrl,
              docUrl: docUrl,
              imageUrl: _uploadedImageUrl);

      if (mounted) {
        _startPolling(submission.id);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Submission failed: $e", style: GoogleFonts.outfit()),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Evaluation Loading State
    if (_submissionId != null && _status == 'evaluating') {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  color: Colors.blueAccent,
                  strokeWidth: 2,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                "Running Tests...",
                style: GoogleFonts.outfit(
                  color: theme.textTheme.titleLarge?.color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Evaluating your code submission",
                style: GoogleFonts.outfit(
                    color: theme.textTheme.bodyMedium?.color, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    // Input Form State
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        systemOverlayStyle:
            isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        title: (_isTimerRunning || !_isLoadingTimer)
            ? Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.timer_outlined,
                        color: Colors.redAccent, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      _formatDuration(_timeLeft),
                      style: GoogleFonts.spaceMono(
                        color: theme.textTheme.bodyLarge?.color,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            : Text(
                "Active Execution",
                style: GoogleFonts.outfit(fontSize: 18),
              ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          color: theme.iconTheme.color,
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: _isExpired
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.timer_off_outlined,
                        color: Colors.redAccent, size: 64),
                    const SizedBox(height: 24),
                    Text(
                      "Time's Up!",
                      style: GoogleFonts.outfit(
                        color: theme.textTheme.titleLarge?.color,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "You ran out of time for this mission.\nYou must restart to try again.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        color: theme.textTheme.bodyMedium?.color,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "PENALTY APPLIED: -50 XP",
                        style: GoogleFonts.outfit(
                          color: Colors.redAccent,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () async {
                            await _clearMissionState();
                            if (context.mounted) context.pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            "RESTART MISSION",
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Task Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: theme.dividerColor.withValues(alpha: 0.5)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.code,
                                color: Colors.blueAccent, size: 24),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("TASK",
                                    style: GoogleFonts.outfit(
                                        color: theme.textTheme.bodySmall?.color,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1)),
                                const SizedBox(height: 4),
                                Text(
                                  widget.drop.title,
                                  style: GoogleFonts.outfit(
                                    color: theme.textTheme.titleLarge?.color,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),
                    const SizedBox(height: 32),

                    // 0. External Source Link (Source B)
                    if (widget.drop.sourceType == 'B' &&
                        widget.drop.sourceUrl != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _launchSourceUrl,
                            icon:
                                const Icon(Icons.open_in_new_rounded, size: 20),
                            label: Text(
                                widget.drop.submissionType == 'code'
                                    ? "View Source on GitHub"
                                    : "View Mission Brief",
                                style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(color: Colors.blueAccent),
                              foregroundColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                          ),
                        ).animate().fadeIn(delay: 250.ms),
                      ),

                    // 1. Submission Input Fields (Dynamic based on Type)
                    if (widget.drop.submissionType == 'code')
                      _buildInputField(
                              label: "GitHub / Project URL",
                              hint: "Has to be public repo link",
                              controller: _projectUrlController,
                              icon: Icons.code_rounded)
                          .animate()
                          .fadeIn(delay: 300.ms)
                    else if (widget.drop.submissionType == 'link')
                      _buildInputField(
                              label: "Project Link",
                              hint: "Figma, Website, or Doc Link",
                              controller: _projectUrlController,
                              icon: Icons.link_rounded)
                          .animate()
                          .fadeIn(delay: 300.ms),

                    const SizedBox(height: 24),

                    // 2. Documentation Link with Info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Documentation URL",
                              style: GoogleFonts.outfit(
                                color: theme.textTheme.bodyLarge?.color,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: theme.cardColor,
                                    title: Text("Documentation Guide",
                                        style: GoogleFonts.outfit(
                                            color: theme
                                                .textTheme.titleLarge?.color,
                                            fontWeight: FontWeight.bold)),
                                    content: Text(
                                      "Please write your documentation in Google Docs, Notion, or a README file, and share the PUBLIC link here so we can access it.",
                                      style: GoogleFonts.outfit(
                                          color: theme
                                              .textTheme.bodyMedium?.color),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () => context.pop(),
                                          child: Text("Got it",
                                              style: GoogleFonts.outfit(
                                                  color: Colors.blueAccent)))
                                    ],
                                  ),
                                );
                              },
                              child: const Icon(Icons.info_outline,
                                  color: Colors.blueAccent, size: 18),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _docUrlController,
                          style: GoogleFonts.outfit(
                              color: theme.textTheme.bodyLarge?.color),
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.description_outlined,
                                color: theme.iconTheme.color
                                    ?.withValues(alpha: 0.5),
                                size: 20),
                            hintText: "https://docs.google.com/...",
                            hintStyle:
                                GoogleFonts.outfit(color: theme.hintColor),
                            filled: true,
                            fillColor: theme.cardColor,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: theme.dividerColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide:
                                  const BorderSide(color: Colors.blueAccent),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // 3. Upload Screenshot Area
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Upload Screenshot",
                          style: GoogleFonts.outfit(
                            color: theme.textTheme.bodyLarge?.color,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            height: 160,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: _uploadedImageUrl != null
                                      ? Colors.greenAccent
                                      : theme.dividerColor,
                                  width: 1.5),
                            ),
                            child: _isUploadingImage
                                ? const Center(
                                    child: CircularProgressIndicator(
                                        color: Colors.blueAccent))
                                : _selectedImageFile != null
                                    ? Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            child: Image.file(
                                              _selectedImageFile!,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black
                                                  .withValues(alpha: 0.4),
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                  Icons.check_circle_rounded,
                                                  color: Colors.greenAccent,
                                                  size: 48),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.cloud_upload_outlined,
                                              color: Colors.grey[600],
                                              size: 40),
                                          const SizedBox(height: 12),
                                          Text(
                                            "Tap to upload screenshot",
                                            style: GoogleFonts.outfit(
                                              color: theme
                                                  .textTheme.bodyMedium?.color,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            "as JPG / PNG",
                                            style: GoogleFonts.outfit(
                                              color: theme
                                                  .textTheme.bodySmall?.color,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                          ),
                        ).animate().fadeIn(delay: 500.ms),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Serious Warning Card
                    // Serious Warning Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF2B0E0E)
                            : Colors
                                .red[50], // Dark Red background or Light Red
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: isDark
                                ? Colors.redAccent.withValues(alpha: 0.3)
                                : Colors.redAccent.withValues(alpha: 0.2)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.warning_amber_rounded,
                                  color: Colors.redAccent, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                "PROFESSIONAL INTEGRITY VALIDATION",
                                style: GoogleFonts.outfit(
                                  color: Colors.redAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "All code link, docs, and screenshots are manually analyzed by Hiring Managers and Founders. Fake or invalid submissions will result in immediate penalty and account blacklisting.",
                            style: GoogleFonts.outfit(
                              color: isDark ? Colors.white70 : Colors.red[900],
                              fontSize: 13,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? Colors.white : Colors.black,
                          foregroundColor: isDark ? Colors.black : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: _isSubmitting
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: isDark ? Colors.black : Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                "SUBMIT SOLUTION",
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Quit Option
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: _handleQuit,
                        child: Text(
                          "Quit Mission",
                          style: GoogleFonts.outfit(
                            color: theme.textTheme.bodyMedium?.color,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.2),
                  ],
                ),
              ),
      ),
    );
  }

  Future<void> _handleQuit() async {
    final shouldQuit = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2B0E0E), Color(0xFF1A1A1A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.redAccent.withValues(alpha: 0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.redAccent.withValues(alpha: 0.1),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Warning Icon
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.redAccent.withValues(alpha: 0.1),
                  border: Border.all(
                      color: Colors.redAccent.withValues(alpha: 0.3)),
                ),
                child: const Icon(Icons.warning_amber_rounded,
                    color: Colors.redAccent, size: 48),
              ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.1, 1.1),
                  duration: 1.seconds),

              const SizedBox(height: 32),

              Text(
                "MISSION ABORT",
                style: GoogleFonts.spaceMono(
                  color: Colors.redAccent.withValues(alpha: 0.8),
                  fontSize: 12,
                  letterSpacing: 4,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Confirm Abort?",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Abandoning this mission will result in 0 XP and it will be marked as 'Failed' on your permanent record.",
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 48),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text("RESUME",
                          style: GoogleFonts.outfit(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          )),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                        shadowColor: Colors.redAccent.withValues(alpha: 0.5),
                      ),
                      child: Text(
                        "ABORT",
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (shouldQuit == true) {
      await _clearMissionState();
      if (mounted) {
        context.go('/home');
      }
    }
  }

  Future<void> _clearMissionState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('drop_start_time_${widget.drop.id}');
    await NotificationService().cancelMissionTimer();
    ref.read(currentDropProvider.notifier).clearDrop();
  }

  Widget _buildInputField(
      {required String label,
      required String hint,
      required TextEditingController controller,
      IconData icon = Icons.link}) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(
            color: theme.textTheme.bodyLarge?.color,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: GoogleFonts.outfit(color: theme.textTheme.bodyLarge?.color),
          decoration: InputDecoration(
            prefixIcon: Icon(icon,
                color: theme.iconTheme.color?.withValues(alpha: 0.5), size: 20),
            hintText: hint,
            hintStyle: GoogleFonts.outfit(color: theme.hintColor),
            filled: true,
            fillColor: theme.cardColor,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: theme.dividerColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.blueAccent),
            ),
          ),
        ),
      ],
    );
  }
}
