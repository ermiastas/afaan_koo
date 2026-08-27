import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/age_provider.dart';
import '../../../providers/profile_provider.dart';
import '../../../providers/progress_provider.dart';
import '../../../providers/reward_provider.dart';

import '../models/raji_message.dart';
import '../providers/raji_provider.dart';
import '../services/raji_context_builder.dart';
import '../services/raji_speech_service.dart';
import 'raji_cartoon.dart';

class RajiChatWidget extends StatefulWidget {
  const RajiChatWidget({
    super.key,
    this.currentLesson,
    this.currentCategory,
    this.currentItem,
    this.height,
    this.showHeader = true,
    this.showSuggestions = true,
    this.compact = false,

    // Raji callbacks
    this.onAction,
    this.onRewardEarned,
  });

  final String? currentLesson;
  final String? currentCategory;
  final String? currentItem;

  final double? height;

  final bool showHeader;
  final bool showSuggestions;
  final bool compact;

  /// Called when Raji sends an action such as opening
  /// a lesson, game, quiz, story, etc.
  final void Function(String actionType, String? actionId)? onAction;

  /// Called when Raji awards XP, stars or coins.
  final void Function(RajiMessage reward)? onRewardEarned;

  @override
  State<RajiChatWidget> createState() => _RajiChatWidgetState();
}

class _RajiChatWidgetState
    extends State<RajiChatWidget> {
  final TextEditingController _controller =
      TextEditingController();

  final ScrollController _scrollController =
      ScrollController();

  bool _initialized = false;

  bool _speaking = false;

  // =====================================================
  // INITIALIZE
  // =====================================================

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (mounted) {
          _initializeRaji();
        }
      },
    );
  }

  Future<void> _initializeRaji() async {
    if (_initialized) {
      return;
    }

    final raji =
        context.read<RajiProvider>();

    final profile =
        context.read<ProfileProvider>();

    final progress =
        context.read<ProgressProvider>();

    final rewards =
        context.read<RewardProvider>();

    final age =
        context.read<AgeProvider>();

    final rajiContext =
        RajiContextBuilder.build(
      profileProvider: profile,
      progressProvider: progress,
      rewardProvider: rewards,
      ageProvider: age,
      currentLesson:
          widget.currentLesson,
      currentCategory:
          widget.currentCategory,
      currentItem:
          widget.currentItem,
    );

    await raji.initialize(
      context: rajiContext,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _initialized = true;
    });
  }

  // =====================================================
  // SEND
  // =====================================================

  Future<void> _sendMessage(
    String text,
  ) async {
    final cleanText =
        text.trim();

    if (cleanText.isEmpty) {
      return;
    }

    final raji =
        context.read<RajiProvider>();

    if (raji.isLoading) {
      return;
    }

    _controller.clear();

    final oldMessageCount =
        raji.messages.length;

    await raji.sendMessage(
      cleanText,
    );

    if (!mounted) {
      return;
    }

    _scrollToBottom();

    // ---------------------------------------------------
    // Process newly received Raji messages.
    // ---------------------------------------------------

    if (raji.messages.length >
        oldMessageCount) {
      final newMessages =
          raji.messages
              .skip(oldMessageCount)
              .toList();

      for (final message
          in newMessages) {
        await _processRajiMessage(
          message,
        );
      }
    }
  }

  // =====================================================
  // PROCESS RAJI MESSAGE
  // =====================================================

  Future<void> _processRajiMessage(
    RajiMessage message,
  ) async {
    if (!mounted) {
      return;
    }

    // ---------------------------------------------------
    // Reward
    // ---------------------------------------------------

    if (message.isRaji &&
        message.hasReward) {
      await _handleReward(
        message,
      );
    }

    // ---------------------------------------------------
    // Action
    // ---------------------------------------------------

    if (message.isRaji &&
        message.hasAction) {
      // We intentionally don't execute the
      // action automatically.
      //
      // The child must press "Kottu".
    }
  }

  // =====================================================
  // REWARD
  // =====================================================

  Future<void> _handleReward(
    RajiMessage message,
  ) async {
    final rewardProvider =
        context.read<RewardProvider>();

    // ---------------------------------------------------
    // Apply ONLY backend-provided reward values.
    //
    // The backend must validate these values.
    // ---------------------------------------------------

    if (message.xp > 0) {
      await rewardProvider.addXP(
        message.xp,
      );
    }

    if (message.stars > 0) {
      await rewardProvider.addStars(
        message.stars,
      );
    }

    if (message.coins > 0) {
      await rewardProvider.addCoins(
        message.coins,
      );
    }

    if (widget.onRewardEarned != null) {
      widget.onRewardEarned!(
        message,
      );
    }
  }

  // =====================================================
  // ACTION
  // =====================================================

  Future<void> _handleAction(
    RajiMessage message,
  ) async {
    if (!message.hasAction) {
      return;
    }

    if (widget.onAction != null) {
      widget.onAction!(
        message.actionType!,
        message.actionId,
      );

      return;
    }

    // ---------------------------------------------------
    // Default fallback
    // ---------------------------------------------------

    await _showActionDialog(
      message,
    );
  }

  // =====================================================
  // ACTION DIALOG
  // =====================================================

  Future<void> _showActionDialog(
    RajiMessage message,
  ) async {
    if (!mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Raji',
          ),
          content: Text(
            'Raji action: '
            '${message.actionType}'
            '${message.actionId != null ? ' (${message.actionId})' : ''}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(
                  context,
                ).pop();
              },
              child: const Text(
                'Cufi',
              ),
            ),
          ],
        );
      },
    );
  }

  // =====================================================
  // SPEECH
  // =====================================================

  Future<void> _speak(
    String text,
  ) async {
    if (_speaking) {
      await RajiSpeechService.stop();

      if (mounted) {
        setState(() {
          _speaking = false;
        });
      }

      return;
    }

    if (mounted) {
      setState(() {
        _speaking = true;
      });
    }

    await RajiSpeechService.speak(
      text,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _speaking = false;
    });
  }

  // =====================================================
  // SUGGESTION
  // =====================================================

  void _useSuggestion(
    String suggestion,
  ) {
    _sendMessage(
      suggestion,
    );
  }

  // =====================================================
  // SCROLL
  // =====================================================

  void _scrollToBottom() {
    WidgetsBinding.instance
        .addPostFrameCallback(
      (_) {
        if (!_scrollController.hasClients) {
          return;
        }

        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration:
              const Duration(
            milliseconds: 250,
          ),
          curve: Curves.easeOut,
        );
      },
    );
  }

  // =====================================================
  // CLEAR
  // =====================================================

  Future<void> _clearChat() async {
    await RajiSpeechService.stop();

    if (!mounted) {
      return;
    }

    context
        .read<RajiProvider>()
        .clearChat();

    setState(() {
      _speaking = false;
    });
  }

  // =====================================================
  // DISPOSE
  // =====================================================

  @override
  void dispose() {
    RajiSpeechService.stop();

    _controller.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  // =====================================================
  // BUILD
  // =====================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Consumer<RajiProvider>(
      builder: (
        context,
        raji,
        child,
      ) {
        if (!_initialized) {
          return const Center(
            child:
                CircularProgressIndicator(),
          );
        }

        return Container(
          height:
              widget.height,
          decoration:
              BoxDecoration(
            color:
                Theme.of(context)
                    .colorScheme
                    .surface,
            borderRadius:
                BorderRadius.circular(
              widget.compact
                  ? 16
                  : 24,
            ),
            border:
                Border.all(
              color:
                  Theme.of(context)
                      .dividerColor,
            ),
          ),
          child: Column(
            children: [
              if (widget.showHeader)
                _buildHeader(
                  context,
                  raji,
                ),

              Expanded(
                child:
                    _buildChatBody(
                  context,
                  raji,
                ),
              ),

              if (widget.showSuggestions &&
                  raji.messages.isNotEmpty)
                _buildSuggestions(
                  context,
                  raji,
                ),

              if (raji.error != null)
                _buildError(
                  context,
                  raji,
                ),

              _buildInput(
                context,
                raji,
              ),
            ],
          ),
        );
      },
    );
  }

  // =====================================================
  // HEADER
  // =====================================================

  Widget _buildHeader(
    BuildContext context,
    RajiProvider raji,
  ) {
    final profile =
        context.watch<ProfileProvider>();

    return Container(
      padding:
          EdgeInsets.symmetric(
        horizontal:
            widget.compact
                ? 12
                : 16,
        vertical:
            widget.compact
                ? 10
                : 14,
      ),
      decoration:
          BoxDecoration(
        color:
            Theme.of(context)
                .colorScheme
                .primaryContainer,
        borderRadius:
            BorderRadius.vertical(
          top:
              Radius.circular(
            widget.compact
                ? 16
                : 24,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width:
                widget.compact
                    ? 42
                    : 52,
            height:
                widget.compact
                    ? 42
                    : 52,
            decoration:
                const BoxDecoration(
              shape:
                  BoxShape.circle,
              color:
                  Colors.white,
            ),
            alignment:
                Alignment.center,
            child: RajiCartoon(
              size: widget.compact ? 38 : 46,
              thinking: raji.isLoading,
            ),
          ),

          const SizedBox(
            width: 10,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'Raji',
                  style:
                      TextStyle(
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                Text(
                  'Hiriyyaa barnootaa kee 🌟',
                  style:
                      Theme.of(context)
                          .textTheme
                          .bodySmall,
                ),

                if (profile.name.isNotEmpty)
                  Text(
                    profile.name,
                    style:
                        Theme.of(context)
                            .textTheme
                            .labelSmall,
                  ),
              ],
            ),
          ),

          IconButton(
            tooltip:
                'Raji sagalee dhaabi',

            onPressed:
                _speaking
                    ? () async {
                        await RajiSpeechService
                            .stop();

                        if (mounted) {
                          setState(() {
                            _speaking =
                                false;
                          });
                        }
                      }
                    : null,

            icon:
                Icon(
              _speaking
                  ? Icons.volume_off_rounded
                  : Icons.volume_up_rounded,
            ),
          ),

          IconButton(
            tooltip:
                'Qubee haaraa',

            onPressed:
                raji.messages.isEmpty
                    ? null
                    : _clearChat,

            icon:
                const Icon(
              Icons.refresh_rounded,
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // CHAT BODY
  // =====================================================

  Widget _buildChatBody(
    BuildContext context,
    RajiProvider raji,
  ) {
    if (raji.messages.isEmpty) {
      return _buildWelcome(
        context,
      );
    }

    return ListView.builder(
      controller:
          _scrollController,
      padding:
          const EdgeInsets.all(16),
      itemCount:
          raji.messages.length +
              (raji.isLoading ? 1 : 0),
      itemBuilder:
          (context, index) {
        if (index ==
            raji.messages.length) {
          return _buildTypingIndicator(
            context,
          );
        }

        final message =
            raji.messages[index];

        return _buildMessage(
          context,
          message,
        );
      },
    );
  }

  // =====================================================
  // WELCOME
  // =====================================================

  Widget _buildWelcome(
    BuildContext context,
  ) {
    final profile =
        context.watch<ProfileProvider>();

    return Center(
      child:
          SingleChildScrollView(
        padding:
            const EdgeInsets.all(24),
        child:
            Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Text(
              '🤖',
              style:
                  TextStyle(
                fontSize: 64,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            Text(
              'Akkam ${profile.name}! 👋',
              textAlign:
                  TextAlign.center,
              style:
                  Theme.of(context)
                      .textTheme
                      .headlineSmall
                      ?.copyWith(
                        fontWeight:
                            FontWeight.bold,
                      ),
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              'Ani Raji dha! Barnoota, tapha fi '
              'gaaffii kee keessatti si gargaaruuf '
              'as jira. 🌟',
              textAlign:
                  TextAlign.center,
              style:
                  Theme.of(context)
                      .textTheme
                      .bodyLarge,
            ),

            const SizedBox(
              height: 24,
            ),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment:
                  WrapAlignment.center,
              children: [
                _WelcomeChip(
                  text:
                      'Hibboo naaf kenni 🧩',
                  onPressed: () {
                    _sendMessage(
                      'Hibboo naaf kenni',
                    );
                  },
                ),
                _WelcomeChip(
                  text:
                      'Qubee na barsiisi 🔤',
                  onPressed: () {
                    _sendMessage(
                      'Qubee na barsiisi',
                    );
                  },
                ),
                _WelcomeChip(
                  text:
                      'Seenaa naaf himi 📖',
                  onPressed: () {
                    _sendMessage(
                      'Seenaa naaf himi',
                    );
                  },
                ),
                _WelcomeChip(
                  text:
                      'Tapha naaf kenni 🎮',
                  onPressed: () {
                    _sendMessage(
                      'Tapha naaf kenni',
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // MESSAGE
  // =====================================================

  Widget _buildMessage(
    BuildContext context,
    RajiMessage message,
  ) {
    final isUser =
        message.isUser;

    return Align(
      alignment:
          isUser
              ? Alignment.centerRight
              : Alignment.centerLeft,
      child: Container(
        constraints:
            const BoxConstraints(
          maxWidth: 520,
        ),
        margin:
            const EdgeInsets.only(
          bottom: 12,
        ),
        padding:
            const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 11,
        ),
        decoration:
            BoxDecoration(
          color:
              isUser
                  ? Theme.of(context)
                      .colorScheme
                      .primary
                  : Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest,
          borderRadius:
              BorderRadius.circular(
            18,
          ),
        ),
        child:
            Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Expanded(
                  child:
                      Text(
                    message.text,
                    style:
                        TextStyle(
                      color:
                          isUser
                              ? Theme.of(context)
                                  .colorScheme
                                  .onPrimary
                              : null,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ),

                if (message.isRaji)
                  IconButton(
                    visualDensity:
                        VisualDensity.compact,
                    tooltip:
                        _speaking
                            ? 'Sagalee dhaabi'
                            : 'Dhaggeeffadhu',
                    onPressed: () {
                      _speak(
                        message.text,
                      );
                    },
                    icon:
                        Icon(
                      _speaking
                          ? Icons
                              .volume_off_rounded
                          : Icons
                              .volume_up_rounded,
                      size: 20,
                    ),
                  ),
              ],
            ),

            if (message.hasReward)
              _buildReward(
                context,
                message,
              ),

            if (message.hasAction)
              _buildAction(
                context,
                message,
              ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // REWARD
  // =====================================================

  Widget _buildReward(
    BuildContext context,
    RajiMessage message,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(
        top: 10,
      ),
      padding:
          const EdgeInsets.all(8),
      decoration:
          BoxDecoration(
        color:
            Theme.of(context)
                .colorScheme
                .secondaryContainer,
        borderRadius:
            BorderRadius.circular(
          12,
        ),
      ),
      child:
          Wrap(
        spacing: 10,
        runSpacing: 4,
        children: [
          if (message.xp > 0)
            Text(
              '+${message.xp} XP ⭐',
            ),

          if (message.stars > 0)
            Text(
              '+${message.stars} 🌟',
            ),

          if (message.coins > 0)
            Text(
              '+${message.coins} 🪙',
            ),
        ],
      ),
    );
  }

  // =====================================================
  // ACTION
  // =====================================================
Widget _buildAction(
  BuildContext context,
  RajiMessage message,
) {
  return Padding(
    padding: const EdgeInsets.only(top: 10),
    child: OutlinedButton.icon(
      onPressed: () {
        _handleAction(message);
      },
      icon: const Icon(
        Icons.play_arrow_rounded,
      ),
      label: Text(
        _actionLabel(message.actionType),
      ),
    ),
  );
}

  // =====================================================
  // ACTION LABEL
  // =====================================================

String _actionLabel(String? actionType) {
  switch (actionType) {
    case 'lesson':
      return 'Baradhu';

    case 'game':
      return 'Kottu';

    case 'quiz':
      return 'Qormaata';

    case 'story':
      return 'Seenaa dubbisi';

    case 'hibboo':
      return 'Hibboo taphadhu';

    case 'mammaaksa':
      return 'Mammaaksa ilaali';

    case 'alphabet':
      return 'Qubee ilaali';

    default:
      return 'Bani';
  }
}
  // =====================================================
  // SUGGESTIONS
  // =====================================================

  Widget _buildSuggestions(
    BuildContext context,
    RajiProvider raji,
  ) {
    final lastMessage =
        raji.messages.last;

    if (!lastMessage.isRaji ||
        lastMessage.suggestions
            .isEmpty) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: 48,
      child:
          ListView.separated(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        scrollDirection:
            Axis.horizontal,
        itemCount:
            lastMessage
                .suggestions
                .length,
        separatorBuilder:
            (_, __) =>
                const SizedBox(
          width: 8,
        ),
        itemBuilder:
            (context, index) {
          final suggestion =
              lastMessage
                  .suggestions[index];

          return ActionChip(
            label:
                Text(
              suggestion,
            ),
            onPressed:
                raji.isLoading
                    ? null
                    : () {
                        _useSuggestion(
                          suggestion,
                        );
                      },
          );
        },
      ),
    );
  }

  // =====================================================
  // ERROR
  // =====================================================

  Widget _buildError(
    BuildContext context,
    RajiProvider raji,
  ) {
    if (raji.error == null) {
      return const SizedBox.shrink();
    }

    return Container(
      width:
          double.infinity,
      margin:
          const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      padding:
          const EdgeInsets.all(10),
      decoration:
          BoxDecoration(
        color:
            Theme.of(context)
                .colorScheme
                .errorContainer,
        borderRadius:
            BorderRadius.circular(
          12,
        ),
      ),
      child:
          Row(
        children: [
          Icon(
            Icons
                .error_outline_rounded,
            color:
                Theme.of(context)
                    .colorScheme
                    .onErrorContainer,
          ),

          const SizedBox(
            width: 8,
          ),

          Expanded(
            child:
                Text(
              raji.error!,
              style:
                  TextStyle(
                color:
                    Theme.of(context)
                        .colorScheme
                        .onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // TYPING INDICATOR
  // =====================================================

  Widget _buildTypingIndicator(
    BuildContext context,
  ) {
    return Align(
      alignment:
          Alignment.centerLeft,
      child:
          Container(
        margin:
            const EdgeInsets.only(
          bottom: 12,
        ),
        padding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration:
            BoxDecoration(
          color:
              Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest,
          borderRadius:
              BorderRadius.circular(
            18,
          ),
        ),
        child:
            const Row(
          mainAxisSize:
              MainAxisSize.min,
          children: [
            Text(
              'Raji',
              style:
                  TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 8,
            ),
            SizedBox(
              width: 14,
              height: 14,
              child:
                  CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
  // INPUT
  // =====================================================

  Widget _buildInput(
    BuildContext context,
    RajiProvider raji,
  ) {
    return SafeArea(
      top: false,
      child:
          Padding(
        padding:
            const EdgeInsets.all(10),
        child:
            Row(
          crossAxisAlignment:
              CrossAxisAlignment.end,
          children: [
            Expanded(
              child:
                  TextField(
                controller:
                    _controller,
                minLines: 1,
                maxLines: 4,
                textInputAction:
                    TextInputAction.send,
                onSubmitted:
                    raji.isLoading
                        ? null
                        : _sendMessage,
                decoration:
                    InputDecoration(
                  hintText:
                      'Raji gaafadhu...',
                  filled:
                      true,
                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                    borderSide:
                        BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),

            const SizedBox(
              width: 8,
            ),

            SizedBox(
              width: 48,
              height: 48,
              child:
                  IconButton.filled(
                onPressed:
                    raji.isLoading
                        ? null
                        : () {
                            _sendMessage(
                              _controller
                                  .text,
                            );
                          },
                icon:
                    raji.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child:
                                CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(
                            Icons
                                .send_rounded,
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =======================================================
// WELCOME CHIP
// =======================================================

class _WelcomeChip
    extends StatelessWidget {
  const _WelcomeChip({
    required this.text,
    required this.onPressed,
  });

  final String text;

  final VoidCallback onPressed;

  @override
  Widget build(
    BuildContext context,
  ) {
    return ActionChip(
      label:
          Text(text),
      onPressed:
          onPressed,
    );
  }
}
