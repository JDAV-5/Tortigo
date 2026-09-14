import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data/services/torti_chat_service.dart';

class TortiChatPage extends StatefulWidget {
  final String playerName;

  const TortiChatPage({
    super.key,
    this.playerName = 'Héroe',
  });

  @override
  State<TortiChatPage> createState() =>
      _TortiChatPageState();
}

class _TortiChatPageState
    extends State<TortiChatPage> {
  final TextEditingController
      _messageController =
      TextEditingController();

  final ScrollController
      _scrollController =
      ScrollController();

  final FocusNode _focusNode =
      FocusNode();

  final TortiChatService
      _chatService =
      TortiChatService();

  final List<ChatMessage>
      _messages = [];

  bool _isSending = false;

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    _messages.add(
      ChatMessage(
        text:
            '¡Hola ${widget.playerName}! 🐢 Soy Torti. '
            '¿Qué te gustaría aprender hoy? 🌱',
        isTorti: true,
      ),
    );
  }

  // ============================================================
  // ENVIAR MENSAJE
  // ============================================================

  Future<void> _sendMessage() async {
    if (_isSending) {
      return;
    }

    final message =
        _messageController.text.trim();

    if (message.isEmpty) {
      return;
    }

    if (message.length > 1000) {
      _showMessage(
        'El mensaje es demasiado largo.',
      );

      return;
    }

    HapticFeedback.selectionClick();

    _messageController.clear();

    setState(() {
      _messages.add(
        ChatMessage(
          text: message,
          isTorti: false,
        ),
      );

      _isSending = true;
    });

    _scrollToBottom();

    try {
      final reply =
          await _chatService.sendMessage(
        message,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _messages.add(
          ChatMessage(
            text: reply,
            isTorti: true,
          ),
        );

        _isSending = false;
      });

      HapticFeedback.lightImpact();

      _scrollToBottom();
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSending = false;

        _messages.add(
          const ChatMessage(
            text:
                'Ups... tuve un pequeño problema para responder. 🐢 '
                'Inténtalo nuevamente en un momento.',
            isTorti: true,
            isError: true,
          ),
        );
      });

      _scrollToBottom();
    }
  }

  // ============================================================
  // SCROLL
  // ============================================================

  void _scrollToBottom() {
    WidgetsBinding.instance
        .addPostFrameCallback(
      (_) {
        if (!_scrollController
            .hasClients) {
          return;
        }

        _scrollController.animateTo(
          _scrollController
              .position
              .maxScrollExtent,
          duration:
              const Duration(
            milliseconds: 350,
          ),
          curve:
              Curves.easeOutCubic,
        );
      },
    );
  }

  // ============================================================
  // SNACKBAR
  // ============================================================

  void _showMessage(
    String message,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
          ),
        ),
      );
  }

  // ============================================================
  // VOLVER
  // ============================================================

  void _goBack() {
    HapticFeedback.selectionClick();

    Navigator.pop(context);
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final keyboardHeight =
        MediaQuery.viewInsetsOf(
      context,
    ).bottom;

    return AnnotatedRegion<
        SystemUiOverlayStyle>(
      value:
          const SystemUiOverlayStyle(
        statusBarColor:
            Colors.transparent,
        statusBarIconBrightness:
            Brightness.light,
        statusBarBrightness:
            Brightness.dark,
        systemStatusBarContrastEnforced:
            false,
      ),

      child: Scaffold(
        resizeToAvoidBottomInset:
            true,

        backgroundColor:
            const Color(
          0xFF236B3A,
        ),

        body: Stack(
          fit: StackFit.expand,
          children: [
            // =================================================
            // FONDO
            // =================================================

            Image.asset(
              'assets/images/fondo3.png',
              fit: BoxFit.cover,
              alignment:
                  Alignment.center,
            ),

            // =================================================
            // CAPA SUAVE
            // =================================================

            Container(
              color: Colors.black
                  .withValues(
                alpha: 0.04,
              ),
            ),

            // =================================================
            // CONTENIDO
            // =================================================

            SafeArea(
              bottom: false,

              child: Column(
                children: [
                  // =============================================
                  // CABECERA
                  // =============================================

                  _ChatHeader(
                    onBack:
                        _goBack,
                  ),

                  // =============================================
                  // CHAT
                  // =============================================

                  Expanded(
                    child:
                        ListView.builder(
                      controller:
                          _scrollController,

                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior
                              .onDrag,

                      padding:
                          const EdgeInsets
                              .fromLTRB(
                        14,
                        18,
                        14,
                        20,
                      ),

                      itemCount:
                          _messages.length +
                              (_isSending
                                  ? 1
                                  : 0),

                      itemBuilder:
                          (
                        context,
                        index,
                      ) {
                        // =======================================
                        // TORTI ESTÁ PENSANDO
                        // =======================================

                        if (_isSending &&
                            index ==
                                _messages
                                    .length) {
                          return const Padding(
                            padding:
                                EdgeInsets.only(
                              bottom:
                                  12,
                            ),

                            child:
                                _ThinkingBubble(),
                          );
                        }

                        final message =
                            _messages[
                                index];

                        return Padding(
                          padding:
                              const EdgeInsets
                                  .only(
                            bottom:
                                12,
                          ),

                          child:
                              _ChatBubble(
                            message:
                                message,
                          ),
                        );
                      },
                    ),
                  ),

                  // =============================================
                  // CAJA PARA ESCRIBIR
                  // =============================================

                  _MessageInput(
                    controller:
                        _messageController,

                    focusNode:
                        _focusNode,

                    isSending:
                        _isSending,

                    onSend:
                        _sendMessage,

                    keyboardHeight:
                        keyboardHeight,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// MODELO MENSAJE
// =====================================================================

class ChatMessage {
  final String text;

  final bool isTorti;

  final bool isError;

  const ChatMessage({
    required this.text,
    required this.isTorti,
    this.isError = false,
  });
}

// =====================================================================
// CABECERA
// =====================================================================

class _ChatHeader
    extends StatelessWidget {
  final VoidCallback onBack;

  const _ChatHeader({
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.fromLTRB(
        12,
        8,
        12,
        0,
      ),

      padding:
          const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),

      decoration:
          BoxDecoration(
        color: Colors.white
            .withValues(
          alpha: 0.95,
        ),

        borderRadius:
            BorderRadius.circular(
          22,
        ),

        border:
            Border.all(
          color:
              const Color(
            0xFF7BCB4D,
          ).withValues(
            alpha:
                0.55,
          ),

          width: 1.5,
        ),

        boxShadow: [
          BoxShadow(
            color:
                const Color(
              0xFF236B3A,
            ).withValues(
              alpha:
                  0.20,
            ),
            blurRadius:
                12,
            offset:
                const Offset(
              0,
              4,
            ),
          ),
        ],
      ),

      child: Row(
        children: [
          // ===================================================
          // VOLVER
          // ===================================================

          Material(
            color:
                const Color(
              0xFFE7F7D8,
            ),

            shape:
                const CircleBorder(),

            child: InkWell(
              onTap:
                  onBack,

              customBorder:
                  const CircleBorder(),

              child:
                  const SizedBox(
                width: 42,
                height: 42,

                child:
                    Icon(
                  Icons
                      .arrow_back_rounded,

                  color:
                      Color(
                    0xFF2D7A3F,
                  ),

                  size: 25,
                ),
              ),
            ),
          ),

          const SizedBox(
            width: 10,
          ),

          // ===================================================
          // AVATAR TORTI
          // ===================================================

          Container(
            width: 53,
            height: 53,

            padding:
                const EdgeInsets.all(
              3,
            ),

            decoration:
                BoxDecoration(
              color:
                  const Color(
                0xFFE7F7D8,
              ),

              shape:
                  BoxShape.circle,

              border:
                  Border.all(
                color:
                    const Color(
                  0xFF59B83A,
                ),
                width: 2,
              ),
            ),

            child:
                ClipOval(
              child:
                  Image.asset(
                'assets/images/tortigo_splash.png',
                fit:
                    BoxFit.cover,
                alignment:
                    Alignment.topCenter,
              ),
            ),
          ),

          const SizedBox(
            width: 11,
          ),

          // ===================================================
          // NOMBRE
          // ===================================================

          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

              children: [
                Text(
                  'Torti',
                  style:
                      TextStyle(
                    color:
                        Color(
                      0xFF236B3A,
                    ),
                    fontSize:
                        19,
                    fontWeight:
                        FontWeight
                            .w800,
                  ),
                ),

                SizedBox(
                  height: 2,
                ),

                Row(
                  children: [
                    _OnlineDot(),

                    SizedBox(
                      width: 6,
                    ),

                    Text(
                      'Tu guía de TortiGo',
                      style:
                          TextStyle(
                        color:
                            Color(
                          0xFF718089,
                        ),
                        fontSize:
                            11,
                        fontWeight:
                            FontWeight
                                .w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ===================================================
          // HOJA
          // ===================================================

          Container(
            width: 38,
            height: 38,

            decoration:
                BoxDecoration(
              color:
                  const Color(
                0xFF59B83A,
              ).withValues(
                alpha:
                    0.12,
              ),

              shape:
                  BoxShape.circle,
            ),

            child:
                const Icon(
              Icons.eco_rounded,
              color:
                  Color(
                0xFF45A049,
              ),
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// ONLINE
// =====================================================================

class _OnlineDot
    extends StatelessWidget {
  const _OnlineDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,

      decoration:
          const BoxDecoration(
        color:
            Color(
          0xFF59B83A,
        ),
        shape:
            BoxShape.circle,
      ),
    );
  }
}

// =====================================================================
// BURBUJA
// =====================================================================

class _ChatBubble
    extends StatelessWidget {
  final ChatMessage message;

  const _ChatBubble({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final isTorti =
        message.isTorti;

    return Row(
      mainAxisAlignment:
          isTorti
              ? MainAxisAlignment
                  .start
              : MainAxisAlignment
                  .end,

      crossAxisAlignment:
          CrossAxisAlignment
              .end,

      children: [
        // =====================================================
        // AVATAR TORTI
        // =====================================================

        if (isTorti) ...[
          Container(
            width: 37,
            height: 37,

            padding:
                const EdgeInsets.all(
              2,
            ),

            decoration:
                BoxDecoration(
              color:
                  Colors.white,

              shape:
                  BoxShape.circle,

              border:
                  Border.all(
                color:
                    const Color(
                  0xFF59B83A,
                ),

                width: 1.5,
              ),
            ),

            child:
                ClipOval(
              child:
                  Image.asset(
                'assets/images/tortigo_splash.png',

                fit:
                    BoxFit.cover,

                alignment:
                    Alignment.topCenter,
              ),
            ),
          ),

          const SizedBox(
            width: 7,
          ),
        ],

        Flexible(
          child:
              Container(
            constraints:
                BoxConstraints(
              maxWidth:
                  MediaQuery.sizeOf(
                        context,
                      ).width *
                      0.72,
            ),

            padding:
                const EdgeInsets
                    .symmetric(
              horizontal: 15,
              vertical: 12,
            ),

            decoration:
                BoxDecoration(
              color: isTorti
                  ? message
                          .isError
                      ? const Color(
                          0xFFFFF0F0,
                        )
                      : Colors
                          .white
                          .withValues(
                          alpha:
                              0.96,
                        )
                  : const Color(
                      0xFF45A049,
                    ),

              borderRadius:
                  BorderRadius.only(
                topLeft:
                    const Radius.circular(
                  18,
                ),

                topRight:
                    const Radius.circular(
                  18,
                ),

                bottomLeft:
                    Radius.circular(
                  isTorti
                      ? 5
                      : 18,
                ),

                bottomRight:
                    Radius.circular(
                  isTorti
                      ? 18
                      : 5,
                ),
              ),

              border: isTorti
                  ? Border.all(
                      color:
                          const Color(
                        0xFF7BCB4D,
                      ).withValues(
                        alpha:
                            0.28,
                      ),
                    )
                  : null,

              boxShadow: [
                BoxShadow(
                  color:
                      Colors.black
                          .withValues(
                    alpha:
                        0.10,
                  ),
                  blurRadius:
                      8,
                  offset:
                      const Offset(
                    0,
                    3,
                  ),
                ),
              ],
            ),

            child:
                SelectableText(
              message.text,

              style:
                  TextStyle(
                color: isTorti
                    ? message
                            .isError
                        ? const Color(
                            0xFFC62828,
                          )
                        : const Color(
                            0xFF31413A,
                          )
                    : Colors
                        .white,

                fontSize: 14,
                height:
                    1.35,
                fontWeight:
                    FontWeight
                        .w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =====================================================================
// TORTI PENSANDO
// =====================================================================

class _ThinkingBubble
    extends StatefulWidget {
  const _ThinkingBubble();

  @override
  State<_ThinkingBubble>
      createState() =>
          _ThinkingBubbleState();
}

class _ThinkingBubbleState
    extends State<_ThinkingBubble>
    with
        SingleTickerProviderStateMixin {
  late final AnimationController
      _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(
      vsync: this,

      duration:
          const Duration(
        milliseconds: 900,
      ),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.end,

      children: [
        Container(
          width: 37,
          height: 37,

          padding:
              const EdgeInsets.all(
            2,
          ),

          decoration:
              BoxDecoration(
            color:
                Colors.white,

            shape:
                BoxShape.circle,

            border:
                Border.all(
              color:
                  const Color(
                0xFF59B83A,
              ),
              width: 1.5,
            ),
          ),

          child:
              ClipOval(
            child:
                Image.asset(
              'assets/images/tortigo_splash.png',
              fit:
                  BoxFit.cover,
              alignment:
                  Alignment.topCenter,
            ),
          ),
        ),

        const SizedBox(
          width: 7,
        ),

        Container(
          padding:
              const EdgeInsets
                  .symmetric(
            horizontal: 14,
            vertical: 12,
          ),

          decoration:
              BoxDecoration(
            color: Colors.white
                .withValues(
              alpha: 0.96,
            ),

            borderRadius:
                const BorderRadius
                    .only(
              topLeft:
                  Radius.circular(
                18,
              ),

              topRight:
                  Radius.circular(
                18,
              ),

              bottomLeft:
                  Radius.circular(
                5,
              ),

              bottomRight:
                  Radius.circular(
                18,
              ),
            ),

            border:
                Border.all(
              color:
                  const Color(
                0xFF7BCB4D,
              ).withValues(
                alpha:
                    0.28,
              ),
            ),
          ),

          child: Row(
            mainAxisSize:
                MainAxisSize.min,

            children: [
              const Text(
                'Torti está pensando',
                style:
                    TextStyle(
                  color:
                      Color(
                    0xFF59666D,
                  ),
                  fontSize:
                      12,
                  fontWeight:
                      FontWeight
                          .w600,
                ),
              ),

              const SizedBox(
                width: 8,
              ),

              AnimatedBuilder(
                animation:
                    _controller,

                builder:
                    (
                  context,
                  child,
                ) {
                  return Row(
                    children:
                        List.generate(
                      3,
                      (
                        index,
                      ) {
                        final phase =
                            ((_controller.value *
                                        3) -
                                    index)
                                .abs();

                        final opacity =
                            (1 -
                                    phase.clamp(
                                      0.0,
                                      1.0,
                                    ))
                                .clamp(
                                  0.25,
                                  1.0,
                                );

                        return Container(
                          width:
                              6,
                          height:
                              6,

                          margin:
                              const EdgeInsets
                                  .only(
                            left:
                                3,
                          ),

                          decoration:
                              BoxDecoration(
                            color:
                                const Color(
                              0xFF45A049,
                            ).withValues(
                              alpha:
                                  opacity,
                            ),

                            shape:
                                BoxShape.circle,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// =====================================================================
// INPUT
// =====================================================================

class _MessageInput
    extends StatelessWidget {
  final TextEditingController
      controller;

  final FocusNode focusNode;

  final bool isSending;

  final VoidCallback onSend;

  final double keyboardHeight;

  const _MessageInput({
    required this.controller,
    required this.focusNode,
    required this.isSending,
    required this.onSend,
    required this.keyboardHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.fromLTRB(
        12,
        10,
        12,

        keyboardHeight > 0
            ? 10
            : MediaQuery.paddingOf(
                  context,
                ).bottom +
                10,
      ),

      decoration:
          BoxDecoration(
        color: Colors.white
            .withValues(
          alpha:
              0.97,
        ),

        boxShadow: [
          BoxShadow(
            color:
                Colors.black
                    .withValues(
              alpha:
                  0.12,
            ),
            blurRadius:
                16,
            offset:
                const Offset(
              0,
              -4,
            ),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.end,

        children: [
          // ===================================================
          // CAMPO
          // ===================================================

          Expanded(
            child:
                Container(
              constraints:
                  const BoxConstraints(
                minHeight:
                    50,
                maxHeight:
                    115,
              ),

              decoration:
                  BoxDecoration(
                color:
                    const Color(
                  0xFFF1F6EF,
                ),

                borderRadius:
                    BorderRadius
                        .circular(
                  23,
                ),

                border:
                    Border.all(
                  color:
                      const Color(
                    0xFF7BCB4D,
                  ).withValues(
                    alpha:
                        0.38,
                  ),
                ),
              ),

              child:
                  TextField(
                controller:
                    controller,

                focusNode:
                    focusNode,

                enabled:
                    !isSending,

                minLines:
                    1,

                maxLines:
                    4,

                maxLength:
                    1000,

                textCapitalization:
                    TextCapitalization
                        .sentences,

                keyboardType:
                    TextInputType
                        .multiline,

                textInputAction:
                    TextInputAction
                        .newline,

                style:
                    const TextStyle(
                  color:
                      Color(
                    0xFF31413A,
                  ),
                  fontSize:
                      14,
                ),

                decoration:
                    const InputDecoration(
                  hintText:
                      'Pregúntale algo a Torti...',

                  hintStyle:
                      TextStyle(
                    color:
                        Color(
                      0xFF8A969D,
                    ),
                  ),

                  border:
                      InputBorder
                          .none,

                  counterText:
                      '',

                  contentPadding:
                      EdgeInsets
                          .symmetric(
                    horizontal:
                        17,

                    vertical:
                        14,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(
            width: 9,
          ),

          // ===================================================
          // ENVIAR
          // ===================================================

          Material(
            color:
                isSending
                    ? const Color(
                        0xFF9AC88A,
                      )
                    : const Color(
                        0xFF45A049,
                      ),

            shape:
                const CircleBorder(),

            child:
                InkWell(
              onTap:
                  isSending
                      ? null
                      : onSend,

              customBorder:
                  const CircleBorder(),

              child:
                  SizedBox(
                width: 50,
                height: 50,

                child:
                    isSending
                        ? const Padding(
                            padding:
                                EdgeInsets.all(
                              14,
                            ),

                            child:
                                CircularProgressIndicator(
                              strokeWidth:
                                  2.5,
                              color:
                                  Colors.white,
                            ),
                          )
                        : const Icon(
                            Icons
                                .send_rounded,
                            color:
                                Colors.white,
                            size:
                                25,
                          ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}