import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../config/theme.dart';
import '../../widgets/custom_button.dart';

class VerifyOTPScreen extends StatefulWidget {
  final String phoneNumber;

  const VerifyOTPScreen({Key? key, required this.phoneNumber})
    : super(key: key);

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  int _resendTimerSeconds = 30;
  Timer? _resendTimer;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();

    // Setup focus listeners
    for (int i = 0; i < _focusNodes.length; i++) {
      _controllers[i].addListener(() {
        if (_controllers[i].text.length == 1 && i < _focusNodes.length - 1) {
          _focusNodes[i + 1].requestFocus();
        }
      });
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendTimerSeconds > 0) {
          _resendTimerSeconds--;
        } else {
          _resendTimer?.cancel();
        }
      });
    });
  }

  void _resendCode() {
    if (_resendTimerSeconds > 0) return;

    // In a real app, this would resend the verification code
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Verification code resent')));

    setState(() {
      _resendTimerSeconds = 30;
      _startResendTimer();
    });
  }

  String _getOtpCode() {
    return _controllers.map((controller) => controller.text).join();
  }

  Future<void> _verifyOTP() async {
    String code = _getOtpCode();

    if (code.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid verification code'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isVerifying = true;
    });

    // In a real app, this would verify the OTP with a backend service
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isVerifying = false;
    });

    if (mounted) {
      // For demo, let's just accept any 4-digit code
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Phone Number')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Verification Code',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'We have sent a verification code to ${widget.phoneNumber}',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 32),

            // OTP Input fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) => _buildOtpDigitField(index)),
            ),

            const SizedBox(height: 24),

            // Resend code option
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Didn\'t receive the code?',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                TextButton(
                  onPressed: _resendTimerSeconds > 0 ? null : _resendCode,
                  child: Text(
                    _resendTimerSeconds > 0
                        ? 'Resend in $_resendTimerSeconds s'
                        : 'Resend',
                    style: TextStyle(
                      color:
                          _resendTimerSeconds > 0
                              ? Colors.grey
                              : AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Verify button
            CustomButton(
              text: 'Verify',
              onPressed: _isVerifying ? () {} : () => _verifyOTP(),
              isLoading: _isVerifying,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpDigitField(int index) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              _focusNodes[index].hasFocus
                  ? AppTheme.primaryColor
                  : Colors.grey.shade300,
          width: _focusNodes[index].hasFocus ? 2 : 1,
        ),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onChanged: (value) {
          if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }

          if (value.isNotEmpty && index == 3) {
            _focusNodes[index].unfocus();
          }
        },
      ),
    );
  }
}
