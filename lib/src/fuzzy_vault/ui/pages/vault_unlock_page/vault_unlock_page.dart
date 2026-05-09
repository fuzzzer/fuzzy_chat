import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/lib.dart';

class VaultUnlockPage extends StatefulWidget {
  const VaultUnlockPage({super.key});

  @override
  State<VaultUnlockPage> createState() => _VaultUnlockPageState();
}

class _VaultUnlockPageState extends State<VaultUnlockPage>
    with SingleTickerProviderStateMixin {
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _autoBiometricAttempted = false;
  late final AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() => setState(() {}));
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _autoBiometricAttempted) return;
      final cubit = context.read<VaultAuthCubit>();
      if (cubit.state.biometricEnabled &&
          cubit.state.authState == VaultAuthEnum.locked) {
        _autoBiometricAttempted = true;
        cubit.unlockWithBiometrics();
      }
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _onUnlock() {
    if (_passwordController.text.isEmpty) return;
    context.read<VaultAuthCubit>().unlock(_passwordController.text);
  }

  void _onBiometricUnlock() {
    context.read<VaultAuthCubit>().unlockWithBiometrics();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VaultAuthCubit, VaultAuthState>(
      listener: (context, state) {
        if (state.failureType != null) {
          _shakeController.forward(from: 0);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                currentContextLocalization
                    .vaultUnlockFailed(state.failureType!.name),
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.authState == VaultAuthEnum.unlocking;

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  Icon(
                    Icons.lock_rounded,
                    size: 80,
                    color: context.uiColors.primaryColor,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    currentContextLocalization.vaultUnlockVault,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.uiColors.primaryTextColor,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  AnimatedBuilder(
                    animation: _shakeController,
                    builder: (context, child) {
                      final sineValue =
                          math.sin(4 * 3.14159265 * _shakeController.value) *
                              8 *
                              (1 - _shakeController.value);
                      return Transform.translate(
                        offset: Offset(sineValue, 0),
                        child: child,
                      );
                    },
                    child: FuzzyTextField(
                      controller: _passwordController,
                      labelText: currentContextLocalization.vaultPassword,
                      obscureText: !_isPasswordVisible,
                      onSubmitted: (_) => _onUnlock(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: context.uiColors.secondaryTextColor,
                        ),
                        onPressed: () => setState(
                          () => _isPasswordVisible = !_isPasswordVisible,
                        ),
                      ),
                    ),
                  ),
                  if (state.failureType != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      currentContextLocalization.vaultIncorrectPassword,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 40),
                  FuzzyButton(
                    text: currentContextLocalization.vaultUnlock,
                    isEnabled:
                        _passwordController.text.isNotEmpty && !isLoading,
                    onTap: _passwordController.text.isNotEmpty && !isLoading
                        ? _onUnlock
                        : () {},
                  ),
                  if (state.biometricEnabled) ...[
                    const SizedBox(height: 24),
                    InkWell(
                      onTap: isLoading ? null : _onBiometricUnlock,
                      borderRadius: BorderRadius.circular(48),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Icon(
                              Icons.fingerprint,
                              size: 56,
                              color: context.uiColors.primaryColor,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              currentContextLocalization.vaultBiometricUnlock,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: context.uiColors.secondaryTextColor,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 40),
                  Text(
                    currentContextLocalization.vaultForgotPassword,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: context.uiColors.secondaryTextColor,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            if (isLoading)
              const ColoredBox(
                color: Colors.black54,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        );
      },
    );
  }
}
