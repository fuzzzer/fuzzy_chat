import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuzzy_chat/lib.dart';

class VaultSearchBar extends StatelessWidget {
  const VaultSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: FuzzyTextField(
              labelText: currentContextLocalization.vaultSearchHint,
              suffixIcon: const Icon(Icons.search),
              onChanged: (query) {
                context.read<VaultSearchCubit>().updateQuery(query);
              },
            ),
          ),
          const SizedBox(width: 8),
          const _VaultBiometricButton(),
        ],
      ),
    );
  }
}

class _VaultBiometricButton extends StatelessWidget {
  const _VaultBiometricButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VaultAuthCubit, VaultAuthState>(
      buildWhen: (prev, curr) => prev.biometricEnabled != curr.biometricEnabled,
      builder: (context, state) {
        return IconButton(
          tooltip: currentContextLocalization.vaultBiometricSettings,
          icon: Icon(
            state.biometricEnabled ? Icons.fingerprint : Icons.fingerprint_outlined,
            color: state.biometricEnabled
                ? context.uiColors.primaryColor
                : context.uiColors.secondaryTextColor,
          ),
          onPressed: () => _openSheet(context),
        );
      },
    );
  }

  Future<void> _openSheet(BuildContext context) {
    final cubit = context.read<VaultAuthCubit>();
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.uiColors.backgroundPrimaryColor,
      builder: (_) => BlocProvider<VaultAuthCubit>.value(
        value: cubit,
        child: const _VaultBiometricSheet(),
      ),
    );
  }
}

class _VaultBiometricSheet extends StatefulWidget {
  const _VaultBiometricSheet();

  @override
  State<_VaultBiometricSheet> createState() => _VaultBiometricSheetState();
}

class _VaultBiometricSheetState extends State<_VaultBiometricSheet> {
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _errorMessage;
  bool? _canUseBiometrics;

  @override
  void initState() {
    super.initState();
    _checkAvailability();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkAvailability() async {
    final canUse = await sl.get<BiometricAuthRepository>().canUseBiometrics();
    if (!mounted) return;
    setState(() => _canUseBiometrics = canUse);
  }

  Future<void> _onEnable() async {
    if (_passwordController.text.isEmpty) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    final success = await context.read<VaultAuthCubit>().enableBiometric(_passwordController.text);
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      if (!success) _errorMessage = currentContextLocalization.vaultBiometricInvalidPassword;
    });
    if (success) Navigator.of(context).pop();
  }

  Future<void> _onDisable() async {
    setState(() => _isLoading = true);
    await context.read<VaultAuthCubit>().disableBiometric();
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uiColors = theme.extension<UiColors>()!;
    final localizations = currentContextLocalization;
    final biometricEnabled = context.watch<VaultAuthCubit>().state.biometricEnabled;
    final canUse = _canUseBiometrics;

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            localizations.vaultBiometricSettings,
            style: theme.textTheme.titleLarge?.copyWith(
              color: uiColors.primaryTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          if (canUse == null)
            const Center(child: CircularProgressIndicator())
          else if (canUse == false)
            Text(
              localizations.vaultBiometricUnavailable,
              style: theme.textTheme.bodyMedium?.copyWith(color: uiColors.secondaryTextColor),
            )
          else if (biometricEnabled) ...[
            Text(
              localizations.vaultBiometricEnabled,
              style: theme.textTheme.bodyMedium?.copyWith(color: uiColors.focusColor),
            ),
            const SizedBox(height: 16),
            FuzzyButton(
              text: localizations.vaultBiometricDisable,
              isEnabled: !_isLoading,
              onTap: !_isLoading ? _onDisable : () {},
            ),
          ] else ...[
            Text(
              localizations.vaultBiometricDescription,
              style: theme.textTheme.bodySmall?.copyWith(color: uiColors.secondaryTextColor),
            ),
            const SizedBox(height: 16),
            FuzzyTextField(
              controller: _passwordController,
              labelText: localizations.vaultMasterPassword,
              obscureText: !_isPasswordVisible,
              onSubmitted: (_) => _onEnable(),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: uiColors.secondaryTextColor,
                ),
                onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
              ),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 16),
            FuzzyButton(
              text: localizations.vaultBiometricEnable,
              isEnabled: !_isLoading,
              onTap: !_isLoading ? _onEnable : () {},
            ),
          ],
        ],
      ),
    );
  }
}
