import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/router/app_router.dart';
import '../../calendar/data/nepali_calendar.dart';

/// Registration Form Screen - Final step in registration flow
/// Collects user details for marriage registration
class RegistrationFormScreen extends StatefulWidget {
  const RegistrationFormScreen({super.key});

  @override
  State<RegistrationFormScreen> createState() => _RegistrationFormScreenState();
}

class _RegistrationFormScreenState extends State<RegistrationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  bool _isSubmitting = false;

  // Form controllers
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _grandfatherNameController = TextEditingController();

  // Form state
  String? _selectedGender;
  DateTime? _dobGregorian;
  NepaliDate? _dobNepali;
  bool _useBsDate = true;
  String? _selectedMaritalStatus;
  String? _selectedReligion;
  String? _selectedCaste;

  final List<String> _genderOptions = [
    'पुरुष (Male)',
    'महिला (Female)',
    'अन्य (Other)'
  ];
  final List<String> _maritalStatusOptions = [
    'अविवाहित (Single)',
    'विधुर/विधवा (Widowed)',
    'सम्बन्ध विच्छेद (Divorced)',
  ];
  final List<String> _religionOptions = [
    'हिन्दु (Hindu)',
    'बौद्ध (Buddhist)',
    'इस्लाम (Islam)',
    'क्रिश्चियन (Christian)',
    'किरात (Kirat)',
    'अन्य (Other)',
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _fatherNameController.dispose();
    _motherNameController.dispose();
    _grandfatherNameController.dispose();
    super.dispose();
  }

  Future<void> _selectDateBS(BuildContext context) async {
    final today = NepaliDate.now();
    // Show a custom BS date picker dialog
    final result = await showDialog<NepaliDate>(
      context: context,
      builder: (context) => _BsDatePickerDialog(
        initialDate:
            _dobNepali ?? NepaliDate(year: today.year - 20, month: 1, day: 1),
        minYear: today.year - 80,
        maxYear: today.year - 18,
      ),
    );
    if (result != null) {
      setState(() {
        _dobNepali = result;
        _dobGregorian = result.toDateTime();
      });
    }
  }

  Future<void> _selectDateAD(BuildContext context) async {
    final today = DateTime.now();
    final result = await showDatePicker(
      context: context,
      initialDate: _dobGregorian ?? DateTime(today.year - 20, 1, 1),
      firstDate: DateTime(today.year - 80),
      lastDate: DateTime(today.year - 18),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryRed,
              onPrimary: AppColors.white,
              surface: AppColors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (result != null) {
      setState(() {
        _dobGregorian = result;
        _dobNepali = NepaliDate.fromDateTime(result);
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      // Scroll to top to show errors
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    // Show success toast and navigate back to home
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'दर्ता सफल भयो!',
                    style: AppTypography.titleSmall.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Registration submitted successfully',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
      ),
    );

    // Navigate back to home
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'दर्ता फारम',
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: 1.0,
            backgroundColor: AppColors.primaryRedDark,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.white),
          ),
        ),
      ),
      body: Column(
        children: [
          // Step indicator
          const _StepIndicator(currentStep: 3),
          // Form content
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Form header
                    _FormHeader(),
                    const SizedBox(height: 24),
                    // Personal Information Section
                    _SectionHeader(
                      icon: Icons.person_outline,
                      titleNepali: 'व्यक्तिगत विवरण',
                      titleEnglish: 'Personal Information',
                    ),
                    const SizedBox(height: 16),
                    // Full Name
                    _FormField(
                      labelNepali: 'पूरा नाम',
                      labelEnglish: 'Full Name',
                      isRequired: true,
                      child: TextFormField(
                        controller: _nameController,
                        decoration: _inputDecoration('नाम लेख्नुहोस्'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'नाम आवश्यक छ';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Gender
                    _FormField(
                      labelNepali: 'लिङ्ग',
                      labelEnglish: 'Gender',
                      isRequired: true,
                      child: DropdownButtonFormField<String>(
                        value: _selectedGender,
                        decoration: _inputDecoration('छान्नुहोस्'),
                        items: _genderOptions
                            .map((g) =>
                                DropdownMenuItem(value: g, child: Text(g)))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'लिङ्ग छान्नुहोस्';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Date of Birth
                    _FormField(
                      labelNepali: 'जन्म मिति',
                      labelEnglish: 'Date of Birth',
                      isRequired: true,
                      child: Column(
                        children: [
                          // BS/AD toggle
                          Row(
                            children: [
                              _DateToggleButton(
                                label: 'बि.सं. (BS)',
                                isSelected: _useBsDate,
                                onTap: () {
                                  setState(() {
                                    _useBsDate = true;
                                  });
                                },
                              ),
                              const SizedBox(width: 8),
                              _DateToggleButton(
                                label: 'ई.सं. (AD)',
                                isSelected: !_useBsDate,
                                onTap: () {
                                  setState(() {
                                    _useBsDate = false;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Date picker
                          InkWell(
                            onTap: () {
                              if (_useBsDate) {
                                _selectDateBS(context);
                              } else {
                                _selectDateAD(context);
                              }
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    color: AppColors.textTertiary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      _getFormattedDob(),
                                      style: AppTypography.bodyMedium.copyWith(
                                        color: _dobNepali != null
                                            ? AppColors.textPrimary
                                            : AppColors.textTertiary,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: AppColors.textTertiary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Marital Status
                    _FormField(
                      labelNepali: 'वैवाहिक स्थिति',
                      labelEnglish: 'Marital Status',
                      isRequired: true,
                      child: DropdownButtonFormField<String>(
                        value: _selectedMaritalStatus,
                        decoration: _inputDecoration('छान्नुहोस्'),
                        items: _maritalStatusOptions
                            .map((s) =>
                                DropdownMenuItem(value: s, child: Text(s)))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedMaritalStatus = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'वैवाहिक स्थिति छान्नुहोस्';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Contact Information Section
                    _SectionHeader(
                      icon: Icons.phone_outlined,
                      titleNepali: 'सम्पर्क विवरण',
                      titleEnglish: 'Contact Information',
                    ),
                    const SizedBox(height: 16),
                    // Mobile Number
                    _FormField(
                      labelNepali: 'मोबाइल नम्बर',
                      labelEnglish: 'Mobile Number',
                      isRequired: true,
                      child: TextFormField(
                        controller: _mobileController,
                        decoration: _inputDecoration('98XXXXXXXX'),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'मोबाइल नम्बर आवश्यक छ';
                          }
                          if (value.length != 10) {
                            return 'मोबाइल नम्बर १० अंकको हुनुपर्छ';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Email (optional)
                    _FormField(
                      labelNepali: 'इमेल',
                      labelEnglish: 'Email',
                      isRequired: false,
                      child: TextFormField(
                        controller: _emailController,
                        decoration: _inputDecoration('example@email.com'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            final emailRegex = RegExp(
                              r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
                            );
                            if (!emailRegex.hasMatch(value)) {
                              return 'मान्य इमेल लेख्नुहोस्';
                            }
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Address Section
                    _SectionHeader(
                      icon: Icons.location_on_outlined,
                      titleNepali: 'ठेगाना',
                      titleEnglish: 'Address',
                    ),
                    const SizedBox(height: 16),
                    // City/District
                    _FormField(
                      labelNepali: 'जिल्ला/शहर',
                      labelEnglish: 'District/City',
                      isRequired: true,
                      child: TextFormField(
                        controller: _cityController,
                        decoration: _inputDecoration('जस्तै: काठमाडौं'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'जिल्ला/शहर आवश्यक छ';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Full Address
                    _FormField(
                      labelNepali: 'पूर्ण ठेगाना',
                      labelEnglish: 'Full Address',
                      isRequired: true,
                      child: TextFormField(
                        controller: _addressController,
                        decoration: _inputDecoration(
                            'टोल, वडा नं., गाउँपालिका/नगरपालिका'),
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'ठेगाना आवश्यक छ';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Family Information Section
                    _SectionHeader(
                      icon: Icons.family_restroom_outlined,
                      titleNepali: 'पारिवारिक विवरण',
                      titleEnglish: 'Family Information',
                    ),
                    const SizedBox(height: 16),
                    // Father's Name
                    _FormField(
                      labelNepali: 'बुबाको नाम',
                      labelEnglish: 'Father\'s Name',
                      isRequired: true,
                      child: TextFormField(
                        controller: _fatherNameController,
                        decoration: _inputDecoration('बुबाको पूरा नाम'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'बुबाको नाम आवश्यक छ';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Mother's Name
                    _FormField(
                      labelNepali: 'आमाको नाम',
                      labelEnglish: 'Mother\'s Name',
                      isRequired: true,
                      child: TextFormField(
                        controller: _motherNameController,
                        decoration: _inputDecoration('आमाको पूरा नाम'),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'आमाको नाम आवश्यक छ';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Grandfather's Name
                    _FormField(
                      labelNepali: 'हजुरबुबाको नाम',
                      labelEnglish: 'Grandfather\'s Name',
                      isRequired: false,
                      child: TextFormField(
                        controller: _grandfatherNameController,
                        decoration: _inputDecoration('हजुरबुबाको पूरा नाम'),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Religion & Caste Section
                    _SectionHeader(
                      icon: Icons.account_balance_outlined,
                      titleNepali: 'धर्म र जात',
                      titleEnglish: 'Religion & Caste',
                    ),
                    const SizedBox(height: 16),
                    // Religion
                    _FormField(
                      labelNepali: 'धर्म',
                      labelEnglish: 'Religion',
                      isRequired: true,
                      child: DropdownButtonFormField<String>(
                        value: _selectedReligion,
                        decoration: _inputDecoration('छान्नुहोस्'),
                        items: _religionOptions
                            .map((r) =>
                                DropdownMenuItem(value: r, child: Text(r)))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedReligion = value;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'धर्म छान्नुहोस्';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Caste
                    _FormField(
                      labelNepali: 'जात',
                      labelEnglish: 'Caste',
                      isRequired: false,
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            _selectedCaste = value;
                          });
                        },
                        decoration: _inputDecoration('जात लेख्नुहोस्'),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
          // Submit button
          _SubmitSection(
            isSubmitting: _isSubmitting,
            onSubmit: _submitForm,
          ),
        ],
      ),
    );
  }

  String _getFormattedDob() {
    if (_dobNepali == null) {
      return 'जन्म मिति छान्नुहोस्';
    }
    if (_useBsDate) {
      return '${_dobNepali!.dayNepali} ${_dobNepali!.monthNameNepali} ${_dobNepali!.yearNepali} (BS)';
    } else {
      return '${_dobGregorian!.day} ${_getMonthName(_dobGregorian!.month)} ${_dobGregorian!.year} (AD)';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTypography.bodyMedium.copyWith(
        color: AppColors.textTertiary,
      ),
      filled: true,
      fillColor: AppColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primaryRed, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}

/// Step indicator showing registration progress
class _StepIndicator extends StatelessWidget {
  final int currentStep;

  const _StepIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      color: AppColors.white,
      child: Row(
        children: [
          _StepDot(step: 1, currentStep: currentStep, label: 'Privacy'),
          _StepLine(isActive: currentStep > 1),
          _StepDot(step: 2, currentStep: currentStep, label: 'Documents'),
          _StepLine(isActive: currentStep > 2),
          _StepDot(step: 3, currentStep: currentStep, label: 'Register'),
        ],
      ),
    );
  }
}

class _StepDot extends StatelessWidget {
  final int step;
  final int currentStep;
  final String label;

  const _StepDot({
    required this.step,
    required this.currentStep,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = step <= currentStep;
    final isCurrent = step == currentStep;
    final isCompleted = step < currentStep;

    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryRed : AppColors.border,
            shape: BoxShape.circle,
            border: isCurrent
                ? Border.all(color: AppColors.primaryRed, width: 2)
                : null,
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: AppColors.white, size: 18)
                : Text(
                    '$step',
                    style: AppTypography.labelMedium.copyWith(
                      color:
                          isActive ? AppColors.white : AppColors.textTertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: isActive ? AppColors.primaryRed : AppColors.textTertiary,
            fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _StepLine extends StatelessWidget {
  final bool isActive;

  const _StepLine({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: isActive ? AppColors.primaryRed : AppColors.border,
      ),
    );
  }
}

/// Form header
class _FormHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryRed.withOpacity(0.1),
            AppColors.peach.withOpacity(0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryRed.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryRed.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.how_to_reg_rounded,
              color: AppColors.primaryRed,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'विवाह दर्ता फारम',
                  style: AppTypography.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Marriage Registration Form',
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'कृपया सबै आवश्यक (*) जानकारी भर्नुहोस्',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.primaryRed,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Section header
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String titleNepali;
  final String titleEnglish;

  const _SectionHeader({
    required this.icon,
    required this.titleNepali,
    required this.titleEnglish,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primaryRed.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primaryRed, size: 18),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titleNepali,
              style: AppTypography.titleSmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              titleEnglish,
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Form field wrapper
class _FormField extends StatelessWidget {
  final String labelNepali;
  final String labelEnglish;
  final bool isRequired;
  final Widget child;

  const _FormField({
    required this.labelNepali,
    required this.labelEnglish,
    required this.isRequired,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              labelNepali,
              style: AppTypography.labelMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            if (isRequired)
              Text(
                ' *',
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            const SizedBox(width: 4),
            Text(
              '($labelEnglish)',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

/// Date toggle button
class _DateToggleButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DateToggleButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryRed : AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primaryRed : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: isSelected ? AppColors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

/// BS Date Picker Dialog
class _BsDatePickerDialog extends StatefulWidget {
  final NepaliDate initialDate;
  final int minYear;
  final int maxYear;

  const _BsDatePickerDialog({
    required this.initialDate,
    required this.minYear,
    required this.maxYear,
  });

  @override
  State<_BsDatePickerDialog> createState() => _BsDatePickerDialogState();
}

class _BsDatePickerDialogState extends State<_BsDatePickerDialog> {
  late int _selectedYear;
  late int _selectedMonth;
  late int _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedYear = widget.initialDate.year;
    _selectedMonth = widget.initialDate.month;
    _selectedDay = widget.initialDate.day;
  }

  List<int> _getYears() {
    return List.generate(
      widget.maxYear - widget.minYear + 1,
      (i) => widget.minYear + i,
    ).reversed.toList();
  }

  int _getDaysInMonth(int year, int month) {
    return NepaliCalendar.getDaysInMonth(year, month);
  }

  @override
  Widget build(BuildContext context) {
    final months = List.generate(12, (i) => i + 1);
    final daysInMonth = _getDaysInMonth(_selectedYear, _selectedMonth);
    final days = List.generate(daysInMonth, (i) => i + 1);

    // Adjust day if it exceeds days in selected month
    if (_selectedDay > daysInMonth) {
      _selectedDay = daysInMonth;
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.calendar_month, color: AppColors.primaryRed),
                const SizedBox(width: 8),
                Text(
                  'जन्म मिति छान्नुहोस्',
                  style: AppTypography.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Select Date of Birth (BS)',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            // Pickers
            Row(
              children: [
                // Year
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Text(
                        'वर्ष',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 40,
                          diameterRatio: 1.5,
                          physics: const FixedExtentScrollPhysics(),
                          controller: FixedExtentScrollController(
                            initialItem: _getYears().indexOf(_selectedYear),
                          ),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              _selectedYear = _getYears()[index];
                            });
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: _getYears().length,
                            builder: (context, index) {
                              final year = _getYears()[index];
                              final isSelected = year == _selectedYear;
                              return Center(
                                child: Text(
                                  NepaliCalendar.toNepaliNumeral(year),
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: isSelected
                                        ? AppColors.primaryRed
                                        : AppColors.textSecondary,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Month
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Text(
                        'महिना',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 40,
                          diameterRatio: 1.5,
                          physics: const FixedExtentScrollPhysics(),
                          controller: FixedExtentScrollController(
                            initialItem: _selectedMonth - 1,
                          ),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              _selectedMonth = months[index];
                            });
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: months.length,
                            builder: (context, index) {
                              final month = months[index];
                              final isSelected = month == _selectedMonth;
                              return Center(
                                child: Text(
                                  NepaliCalendar.getMonthName(month),
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: isSelected
                                        ? AppColors.primaryRed
                                        : AppColors.textSecondary,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Day
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Text(
                        'गते',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 40,
                          diameterRatio: 1.5,
                          physics: const FixedExtentScrollPhysics(),
                          controller: FixedExtentScrollController(
                            initialItem: _selectedDay - 1,
                          ),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              _selectedDay = days[index];
                            });
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            childCount: days.length,
                            builder: (context, index) {
                              final day = days[index];
                              final isSelected = day == _selectedDay;
                              return Center(
                                child: Text(
                                  NepaliCalendar.toNepaliNumeral(day),
                                  style: AppTypography.bodyMedium.copyWith(
                                    color: isSelected
                                        ? AppColors.primaryRed
                                        : AppColors.textSecondary,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Selected date preview
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.peach.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${NepaliCalendar.toNepaliNumeral(_selectedDay)} ${NepaliCalendar.getMonthName(_selectedMonth)} ${NepaliCalendar.toNepaliNumeral(_selectedYear)}',
                    style: AppTypography.titleSmall.copyWith(
                      color: AppColors.primaryRed,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'रद्द गर्नुहोस्',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(
                        NepaliDate(
                            year: _selectedYear,
                            month: _selectedMonth,
                            day: _selectedDay),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'छान्नुहोस्',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Submit section
class _SubmitSection extends StatelessWidget {
  final bool isSubmitting;
  final VoidCallback onSubmit;

  const _SubmitSection({
    required this.isSubmitting,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isSubmitting ? null : onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              disabledBackgroundColor: AppColors.primaryRed.withOpacity(0.5),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: isSubmitting
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'पेश गर्दै...',
                        style: AppTypography.buttonText.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: AppColors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'दर्ता पेश गर्नुहोस्',
                        style: AppTypography.buttonText.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
