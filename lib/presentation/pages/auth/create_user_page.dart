import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../data/services/current_user_service.dart';
import '../../../data/services/user_service.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({
    super.key,
  });

  @override
  State<CreateUserPage> createState() =>
      _CreateUserPageState();
}

class _CreateUserPageState
    extends State<CreateUserPage> {
  // ============================================================
  // FORMULARIO
  // ============================================================

  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>();

  // ============================================================
  // CONTROLLERS
  // ============================================================

  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController _ageController =
      TextEditingController();

  final TextEditingController _teacherController =
      TextEditingController();

  final TextEditingController _pinController =
      TextEditingController();

  final TextEditingController
      _confirmPinController =
      TextEditingController();

  // ============================================================
  // SERVICIOS
  // ============================================================

  final UserService _userService =
      UserService.instance;

  final CurrentUserService _currentUserService =
      CurrentUserService.instance;

  // ============================================================
  // ESTADO
  // ============================================================

  String? _selectedGrade;

  String _selectedAvatar =
      '🐢';

  bool _isLoading =
      false;

  bool _obscurePin =
      true;

  bool _obscureConfirmPin =
      true;

  // ============================================================
  // GRADOS
  // ============================================================

  final List<String> _grades = const [
    'Primero',
    'Segundo',
    'Tercero',
    'Cuarto',
    'Quinto',
    'Sexto',
  ];

  // ============================================================
  // AVATARES
  // ============================================================

  final List<String> _avatars = const [
    '🐢',
    '🐼',
    '🦫',
    '🐸',
    '🐰',
    '🦊',
    '🐨',
    '🐯',
  ];

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _teacherController.dispose();
    _pinController.dispose();
    _confirmPinController.dispose();

    super.dispose();
  }

  // ============================================================
  // CREAR USUARIO
  // ============================================================

  Future<void> _createUser() async {
    FocusScope.of(context).unfocus();

    // ==========================================================
    // VALIDAR FORMULARIO
    // ==========================================================

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedGrade == null) {
      _showMessage(
        'Selecciona el grado del niño.',
      );

      return;
    }

    // ==========================================================
    // VALIDAR PIN
    // ==========================================================

    if (_pinController.text.trim() !=
        _confirmPinController.text.trim()) {
      _showMessage(
        'Los PIN no coinciden.',
      );

      return;
    }

    // ==========================================================
    // MOSTRAR CARGA
    // ==========================================================

    setState(() {
      _isLoading = true;
    });

    try {
      // ========================================================
      // LLAMAR BACKEND
      // ========================================================

      final Map<String, dynamic> response =
          await _userService.createUser(
        displayName:
            _nameController.text.trim(),

        age: int.parse(
          _ageController.text.trim(),
        ),

        gradeName:
            _selectedGrade!,

        teacherName:
            _teacherController.text.trim(),

        pin:
            _pinController.text.trim(),

        avatarType:
            'emoji',

        avatarValue:
            _selectedAvatar,
      );

      if (!mounted) {
        return;
      }

      // ========================================================
      // OBTENER DATOS DEVUELTOS POR EL BACKEND
      //
      // Soporta:
      //
      // {
      //   "data": {
      //      "userId": ...
      //   }
      // }
      //
      // y también:
      //
      // {
      //   "data": {
      //     "user": {
      //       ...
      //     }
      //   }
      // }
      // ========================================================

      final dynamic data =
          response['data'];

      Map<String, dynamic>? user;

      if (data is Map<String, dynamic>) {
        final dynamic nestedUser =
            data['user'];

        if (nestedUser
            is Map<String, dynamic>) {
          user =
              Map<String, dynamic>.from(
            nestedUser,
          );
        } else {
          user =
              Map<String, dynamic>.from(
            data,
          );
        }
      }

      // ========================================================
      // VALIDAR RESPUESTA
      // ========================================================

      if (user == null ||
          user.isEmpty) {
        throw Exception(
          'El usuario fue creado, pero el servidor no devolvió sus datos.',
        );
      }

      // ========================================================
      // ASEGURAR ESTRELLAS INICIALES
      //
      // Todavía no tenemos progreso conectado al backend,
      // por lo tanto todo usuario nuevo inicia en 0.
      // ========================================================

      user['stars'] ??= 0;

      // ========================================================
      // GUARDAR USUARIO COMO ACTIVO
      // ========================================================

      _currentUserService.setCurrentUser(
        user,
      );

      // ========================================================
      // DATOS PARA DIÁLOGO
      // ========================================================

      final String displayName =
          user['displayName']
                  ?.toString() ??
              _nameController.text.trim();

      final String avatar =
          user['avatarValue']
                  ?.toString() ??
              _selectedAvatar;

      // ========================================================
      // MOSTRAR CONFIRMACIÓN
      // ========================================================

      await _showSuccessDialog(
        displayName:
            displayName,
        avatar:
            avatar,
      );

      if (!mounted) {
        return;
      }

      // ========================================================
      // IR DIRECTAMENTE AL HOME
      //
      // Eliminamos las rutas anteriores para evitar que
      // el botón "atrás" regrese al formulario de registro.
      // ========================================================

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (route) => false,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      String message =
          error.toString();

      if (message.startsWith(
        'Exception: ',
      )) {
        message =
            message.substring(
          'Exception: '.length,
        );
      }

      _showMessage(
        message,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // ============================================================
  // MOSTRAR MENSAJE
  // ============================================================

  void _showMessage(
    String message,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content:
              Text(message),
          behavior:
              SnackBarBehavior.floating,
        ),
      );
  }

  // ============================================================
  // DIÁLOGO PERFIL CREADO
  // ============================================================

  Future<void> _showSuccessDialog({
    required String displayName,
    required String avatar,
  }) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (
        BuildContext dialogContext,
      ) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(
              24,
            ),
          ),
          title:
              const Text(
            '¡Perfil creado!',
            textAlign:
                TextAlign.center,
            style:
                TextStyle(
              color:
                  Color(
                0xFF236B3A,
              ),
              fontWeight:
                  FontWeight.w800,
            ),
          ),
          content:
              Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              Container(
                width: 90,
                height: 90,
                alignment:
                    Alignment.center,
                decoration:
                    const BoxDecoration(
                  shape:
                      BoxShape.circle,
                  color:
                      Color(
                    0xFFE7F7D8,
                  ),
                ),
                child:
                    Text(
                  avatar,
                  style:
                      const TextStyle(
                    fontSize: 58,
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                displayName,
                textAlign:
                    TextAlign.center,
                style:
                    const TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.bold,
                  color:
                      Color(
                    0xFF236B3A,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Tu perfil fue creado correctamente.\n¡Bienvenido a TortiGo!',
                textAlign:
                    TextAlign.center,
                style:
                    TextStyle(
                  color:
                      Color(
                    0xFF718089,
                  ),
                  height: 1.4,
                ),
              ),
            ],
          ),
          actionsAlignment:
              MainAxisAlignment.center,
          actions: [
            FilledButton(
              style:
                  FilledButton.styleFrom(
                backgroundColor:
                    const Color(
                  0xFF59A83B,
                ),
                foregroundColor:
                    Colors.white,
              ),
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child:
                  const Text(
                'Continuar',
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          const Color(
        0xFFF4F8EF,
      ),

      appBar:
          AppBar(
        elevation: 0,
        backgroundColor:
            const Color(
          0xFFE8F0E3,
        ),
        foregroundColor:
            const Color(
          0xFF236B3A,
        ),
        title:
            const Text(
          'Crear perfil',
          style:
              TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      body:
          SafeArea(
        child:
            SingleChildScrollView(
          physics:
              const BouncingScrollPhysics(),
          padding:
              const EdgeInsets.fromLTRB(
            20,
            22,
            20,
            40,
          ),
          child:
              Form(
            key:
                _formKey,
            child:
                Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                // =================================================
                // ENCABEZADO
                // =================================================

                const Center(
                  child:
                      Text(
                    '🌱',
                    style:
                        TextStyle(
                      fontSize: 62,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                const Center(
                  child:
                      Text(
                    '¡Crea tu perfil en TortiGo!',
                    textAlign:
                        TextAlign.center,
                    style:
                        TextStyle(
                      fontSize: 24,
                      fontWeight:
                          FontWeight.w800,
                      color:
                          Color(
                        0xFF236B3A,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                const Center(
                  child:
                      Text(
                    'Completa tus datos y elige el avatar que más te guste.',
                    textAlign:
                        TextAlign.center,
                    style:
                        TextStyle(
                      fontSize: 14,
                      color:
                          Color(
                        0xFF718089,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                // =================================================
                // NOMBRE
                // =================================================

                _buildLabel(
                  'Nombre del niño',
                ),

                const SizedBox(
                  height: 8,
                ),

                TextFormField(
                  controller:
                      _nameController,
                  textCapitalization:
                      TextCapitalization.words,
                  textInputAction:
                      TextInputAction.next,
                  decoration:
                      _inputDecoration(
                    hint:
                        'Ej. Sofia Gómez',
                    icon:
                        Icons.person_outline,
                  ),
                  validator:
                      (value) {
                    final String text =
                        value?.trim() ??
                            '';

                    if (text.isEmpty) {
                      return 'Ingresa el nombre.';
                    }

                    if (text.length < 2) {
                      return 'El nombre es demasiado corto.';
                    }

                    if (text.length > 100) {
                      return 'El nombre no puede superar los 100 caracteres.';
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height: 20,
                ),

                // =================================================
                // EDAD
                // =================================================

                _buildLabel(
                  'Edad',
                ),

                const SizedBox(
                  height: 8,
                ),

                TextFormField(
                  controller:
                      _ageController,
                  keyboardType:
                      TextInputType.number,
                  textInputAction:
                      TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter
                        .digitsOnly,
                    LengthLimitingTextInputFormatter(
                      2,
                    ),
                  ],
                  decoration:
                      _inputDecoration(
                    hint:
                        'Ej. 8',
                    icon:
                        Icons.cake_outlined,
                  ),
                  validator:
                      (value) {
                    final int? age =
                        int.tryParse(
                      value ?? '',
                    );

                    if (age == null) {
                      return 'Ingresa la edad.';
                    }

                    if (age < 3 ||
                        age > 20) {
                      return 'La edad debe estar entre 3 y 20 años.';
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height: 20,
                ),

                // =================================================
                // GRADO
                // =================================================

                _buildLabel(
                  'Grado',
                ),

                const SizedBox(
                  height: 8,
                ),

                DropdownButtonFormField<String>(
                  value:
                      _selectedGrade,
                  isExpanded:
                      true,
                  decoration:
                      _inputDecoration(
                    hint:
                        'Selecciona el grado',
                    icon:
                        Icons.school_outlined,
                  ),
                  items:
                      _grades
                          .map(
                    (
                      String grade,
                    ) {
                      return DropdownMenuItem<
                          String>(
                        value:
                            grade,
                        child:
                            Text(
                          grade,
                        ),
                      );
                    },
                  ).toList(),
                  onChanged:
                      (value) {
                    setState(() {
                      _selectedGrade =
                          value;
                    });
                  },
                  validator:
                      (value) {
                    if (value == null) {
                      return 'Selecciona el grado.';
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height: 20,
                ),

                // =================================================
                // PROFESOR
                // =================================================

                _buildLabel(
                  'Nombre del profesor',
                ),

                const SizedBox(
                  height: 8,
                ),

                TextFormField(
                  controller:
                      _teacherController,
                  textCapitalization:
                      TextCapitalization.words,
                  textInputAction:
                      TextInputAction.next,
                  decoration:
                      _inputDecoration(
                    hint:
                        'Ej. Manuel Rivera',
                    icon:
                        Icons.badge_outlined,
                  ),
                  validator:
                      (value) {
                    final String teacher =
                        value?.trim() ??
                            '';

                    if (teacher.isEmpty) {
                      return 'Ingresa el nombre del profesor.';
                    }

                    if (teacher.length > 150) {
                      return 'El nombre del profesor es demasiado largo.';
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height: 30,
                ),

                // =================================================
                // AVATAR
                // =================================================

                _buildLabel(
                  'Elige tu avatar',
                ),

                const SizedBox(
                  height: 12,
                ),

                GridView.builder(
                  shrinkWrap:
                      true,
                  physics:
                      const NeverScrollableScrollPhysics(),
                  itemCount:
                      _avatars.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        4,
                    mainAxisSpacing:
                        12,
                    crossAxisSpacing:
                        12,
                  ),
                  itemBuilder:
                      (
                    context,
                    index,
                  ) {
                    final String avatar =
                        _avatars[
                            index];

                    final bool selected =
                        avatar ==
                            _selectedAvatar;

                    return Material(
                      color:
                          Colors.transparent,
                      child:
                          InkWell(
                        borderRadius:
                            BorderRadius.circular(
                          22,
                        ),
                        onTap:
                            () {
                          HapticFeedback
                              .selectionClick();

                          setState(() {
                            _selectedAvatar =
                                avatar;
                          });
                        },
                        child:
                            AnimatedContainer(
                          duration:
                              const Duration(
                            milliseconds:
                                180,
                          ),
                          decoration:
                              BoxDecoration(
                            color:
                                selected
                                    ? const Color(
                                        0xFFE2F3D9,
                                      )
                                    : Colors.white,
                            borderRadius:
                                BorderRadius.circular(
                              22,
                            ),
                            border:
                                Border.all(
                              color:
                                  selected
                                      ? const Color(
                                          0xFF59A83B,
                                        )
                                      : const Color(
                                          0xFFDCE5D7,
                                        ),
                              width:
                                  selected
                                      ? 3
                                      : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    Colors.black.withValues(
                                  alpha:
                                      0.05,
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
                              Stack(
                            children: [
                              Center(
                                child:
                                    Text(
                                  avatar,
                                  style:
                                      const TextStyle(
                                    fontSize:
                                        42,
                                  ),
                                ),
                              ),
                              if (selected)
                                const Positioned(
                                  right:
                                      6,
                                  top:
                                      6,
                                  child:
                                      CircleAvatar(
                                    radius:
                                        11,
                                    backgroundColor:
                                        Color(
                                      0xFF59A83B,
                                    ),
                                    child:
                                        Icon(
                                      Icons
                                          .check,
                                      size:
                                          15,
                                      color:
                                          Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(
                  height: 30,
                ),

                // =================================================
                // PIN
                // =================================================

                _buildLabel(
                  'Crea tu PIN',
                ),

                const SizedBox(
                  height: 8,
                ),

                TextFormField(
                  controller:
                      _pinController,
                  obscureText:
                      _obscurePin,
                  keyboardType:
                      TextInputType.number,
                  textInputAction:
                      TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter
                        .digitsOnly,
                    LengthLimitingTextInputFormatter(
                      4,
                    ),
                  ],
                  decoration:
                      _inputDecoration(
                    hint:
                        '4 números',
                    icon:
                        Icons.lock_outline,
                    suffixIcon:
                        IconButton(
                      onPressed:
                          () {
                        setState(() {
                          _obscurePin =
                              !_obscurePin;
                        });
                      },
                      icon:
                          Icon(
                        _obscurePin
                            ? Icons
                                .visibility_outlined
                            : Icons
                                .visibility_off_outlined,
                      ),
                    ),
                  ),
                  validator:
                      (value) {
                    final String pin =
                        value?.trim() ??
                            '';

                    if (pin.length != 4) {
                      return 'El PIN debe tener exactamente 4 números.';
                    }

                    if (!RegExp(
                      r'^\d{4}$',
                    ).hasMatch(
                      pin,
                    )) {
                      return 'El PIN solo puede contener números.';
                    }

                    return null;
                  },
                ),

                const SizedBox(
                  height: 20,
                ),

                // =================================================
                // CONFIRMAR PIN
                // =================================================

                _buildLabel(
                  'Confirma tu PIN',
                ),

                const SizedBox(
                  height: 8,
                ),

                TextFormField(
                  controller:
                      _confirmPinController,
                  obscureText:
                      _obscureConfirmPin,
                  keyboardType:
                      TextInputType.number,
                  textInputAction:
                      TextInputAction.done,
                  inputFormatters: [
                    FilteringTextInputFormatter
                        .digitsOnly,
                    LengthLimitingTextInputFormatter(
                      4,
                    ),
                  ],
                  decoration:
                      _inputDecoration(
                    hint:
                        'Repite tu PIN',
                    icon:
                        Icons.lock_person_outlined,
                    suffixIcon:
                        IconButton(
                      onPressed:
                          () {
                        setState(() {
                          _obscureConfirmPin =
                              !_obscureConfirmPin;
                        });
                      },
                      icon:
                          Icon(
                        _obscureConfirmPin
                            ? Icons
                                .visibility_outlined
                            : Icons
                                .visibility_off_outlined,
                      ),
                    ),
                  ),
                  validator:
                      (value) {
                    final String pin =
                        value?.trim() ??
                            '';

                    if (pin.length != 4) {
                      return 'Confirma los 4 números.';
                    }

                    if (pin !=
                        _pinController.text
                            .trim()) {
                      return 'Los PIN no coinciden.';
                    }

                    return null;
                  },
                  onFieldSubmitted:
                      (_) {
                    if (!_isLoading) {
                      _createUser();
                    }
                  },
                ),

                const SizedBox(
                  height: 32,
                ),

                // =================================================
                // BOTÓN CREAR
                // =================================================

                SizedBox(
                  width:
                      double.infinity,
                  height:
                      56,
                  child:
                      FilledButton(
                    onPressed:
                        _isLoading
                            ? null
                            : _createUser,
                    style:
                        FilledButton.styleFrom(
                      backgroundColor:
                          const Color(
                        0xFF59A83B,
                      ),
                      foregroundColor:
                          Colors.white,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          18,
                        ),
                      ),
                    ),
                    child:
                        _isLoading
                            ? const SizedBox(
                                width:
                                    24,
                                height:
                                    24,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth:
                                      3,
                                  color:
                                      Colors.white,
                                ),
                              )
                            : const Text(
                                'Crear mi perfil',
                                style:
                                    TextStyle(
                                  fontSize:
                                      17,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LABEL
  // ============================================================

  Widget _buildLabel(
    String text,
  ) {
    return Text(
      text,
      style:
          const TextStyle(
        fontSize:
            15,
        fontWeight:
            FontWeight.w700,
        color:
            Color(
          0xFF2D5A37,
        ),
      ),
    );
  }

  // ============================================================
  // DECORACIÓN INPUT
  // ============================================================

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText:
          hint,

      prefixIcon:
          Icon(
        icon,
        color:
            const Color(
          0xFF59A83B,
        ),
      ),

      suffixIcon:
          suffixIcon,

      filled:
          true,

      fillColor:
          Colors.white,

      contentPadding:
          const EdgeInsets.symmetric(
        horizontal:
            16,
        vertical:
            18,
      ),

      border:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        borderSide:
            BorderSide.none,
      ),

      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        borderSide:
            const BorderSide(
          color:
              Color(
            0xFFDCE5D7,
          ),
        ),
      ),

      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        borderSide:
            const BorderSide(
          color:
              Color(
            0xFF59A83B,
          ),
          width:
              2,
        ),
      ),

      errorBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        borderSide:
            const BorderSide(
          color:
              Colors.redAccent,
        ),
      ),

      focusedErrorBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        borderSide:
            const BorderSide(
          color:
              Colors.redAccent,
          width:
              2,
        ),
      ),
    );
  }
}