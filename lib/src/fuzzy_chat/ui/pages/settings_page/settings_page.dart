import 'package:flutter/material.dart';
import 'package:fuzzy_chat/lib.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late CopySecurityLevel _securityLevel;

  @override
  void initState() {
    super.initState();
    _securityLevel = sl.get<PreferencesService>().copySecurityLevel;
  }

  void _onSecurityLevelChanged(CopySecurityLevel level) {
    sl.get<PreferencesService>().setCopySecurityLevel(level);
    setState(() {
      _securityLevel = level;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final uiColors = theme.extension<UiColors>()!;
    final uiTextStyles = theme.extension<UiTextStyles>()!;
    final localizations = context.fuzzyChatLocalizations;

    final isStrict = _securityLevel == CopySecurityLevel.strict;

    return FuzzyScaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: FuzzyHeader(
              title: localizations.settings,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.securityLevel,
                    style: uiTextStyles.bodyLarge20.copyWith(
                      color: uiColors.primaryTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isStrict
                        ? localizations.strictSecurityDescription
                        : localizations.moderateSecurityDescription,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: uiColors.secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _SecurityLevelTile(
                    label: localizations.strict,
                    icon: Icons.lock,
                    isSelected: isStrict,
                    color: uiColors.errorColor,
                    onTap: () => _onSecurityLevelChanged(CopySecurityLevel.strict),
                    uiColors: uiColors,
                    uiTextStyles: uiTextStyles,
                  ),
                  const SizedBox(height: 12),
                  _SecurityLevelTile(
                    label: localizations.moderate,
                    icon: Icons.lock_open,
                    isSelected: !isStrict,
                    color: uiColors.focusColor,
                    onTap: () => _onSecurityLevelChanged(CopySecurityLevel.moderate),
                    uiColors: uiColors,
                    uiTextStyles: uiTextStyles,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurityLevelTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;
  final UiColors uiColors;
  final UiTextStyles uiTextStyles;

  const _SecurityLevelTile({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.color,
    required this.onTap,
    required this.uiColors,
    required this.uiTextStyles,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.12)
              : uiColors.backgroundSecondaryColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? color : uiColors.focusColor.withOpacity(0.2),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? color : uiColors.secondaryTextColor,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: uiTextStyles.body16.copyWith(
                  color: isSelected ? color : uiColors.primaryTextColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: color, size: 20),
          ],
        ),
      ),
    );
  }
}
