import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:tap_builder/tap_builder.dart';
import 'package:zaplab_design/zaplab_design.dart';

class LabNpubDisplay extends StatefulWidget {
  final Profile? profile;
  final String? pubkey;
  final bool copyable;

  const LabNpubDisplay({
    super.key,
    this.profile,
    this.pubkey,
    this.copyable = true,
  });

  @override
  State<LabNpubDisplay> createState() => _LabNpubDisplayState();
}

class _LabNpubDisplayState extends State<LabNpubDisplay> {
  bool _showCheck = false;
  bool _isHoveringColor = false;
  String _copiedType = '';

  void _handleCopy(String text, String type) {
    if (text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: text));
      setState(() {
        _showCheck = true;
        _copiedType = type;
      });
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showCheck = false;
            _copiedType = '';
          });
        }
      });
    }
  }

  void _handleNpubTap() {
    final npub = widget.profile?.npub ??
        Utils.encodeShareableFromString(widget.pubkey ?? '', type: 'npub');
    _handleCopy(npub, 'Public Identifier');
  }

  void _handleColorTap() {
    final hexColor = widget.profile != null
        ? profileToHexColor(widget.profile!)
        : npubToHexColor(
            Utils.encodeShareableFromString(widget.pubkey ?? '', type: 'npub'));
    _handleCopy(hexColor, 'Profile Color');
  }

  String _getHexColor() {
    return widget.profile != null
        ? profileToHexColor(widget.profile!)
        : npubToHexColor(
            Utils.encodeShareableFromString(widget.pubkey ?? '', type: 'npub'));
  }

  @override
  Widget build(BuildContext context) {
    final theme = LabTheme.of(context);

    Widget content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TapBuilder(
          onTap: _handleColorTap,
          builder: (context, state, hasFocus) {
            return MouseRegion(
              onEnter: (_) => setState(() => _isHoveringColor = true),
              onExit: (_) => setState(() => _isHoveringColor = false),
              child: LabContainer(
                height: theme.sizes.s8,
                width: theme.sizes.s8,
                decoration: BoxDecoration(
                  color: widget.profile != null
                      ? Color(profileToColor(widget.profile!))
                      : Color(npubToColor(Utils.encodeShareableFromString(
                          widget.pubkey ?? '',
                          type: 'npub'))),
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: theme.colors.white16,
                    width: LabLineThicknessData.normal().thin,
                  ),
                ),
              ),
            );
          },
        ),
        const LabGap.s8(),
        _isHoveringColor
            ? RichText(
                text: TextSpan(
                  style: theme.typography.med12.copyWith(
                    color: theme.colors.white66,
                  ),
                  children: [
                    TextSpan(
                      text: _getHexColor(),
                      style: TextStyle(
                        color: widget.profile != null
                            ? Color(profileToColor(widget.profile!))
                            : Color(npubToColor(Utils.encodeShareableFromString(
                                widget.pubkey ?? '',
                                type: 'npub'))),
                      ),
                    ),
                    const TextSpan(text: ' Profile Color'),
                  ],
                ),
              )
            : LabText.med12(
                _showCheck
                    ? 'Copied $_copiedType'
                    : (widget.profile != null
                        ? formatNpub(widget.profile!.npub)
                        : Utils.encodeShareableFromString(widget.pubkey ?? '',
                            type: 'npub')),
                color: theme.colors.white66,
              ),
        const SizedBox(width: 8),
        if (_showCheck)
          LabIcon.s8(
            theme.icons.characters.check,
            outlineColor: theme.colors.blurpleLightColor,
            outlineThickness: LabLineThicknessData.normal().medium,
          ),
        if (!_showCheck && widget.copyable)
          LabIcon.s14(
            theme.icons.characters.copy,
            outlineColor: theme.colors.white33,
            outlineThickness: LabLineThicknessData.normal().medium,
          ),
      ],
    );

    if (!widget.copyable) {
      return content;
    }

    return TapBuilder(
      onTap: _handleNpubTap,
      builder: (context, state, hasFocus) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TapBuilder(
              onTap: _handleColorTap,
              builder: (context, colorState, hasColorFocus) {
                return MouseRegion(
                  onEnter: (_) => setState(() => _isHoveringColor = true),
                  onExit: (_) => setState(() => _isHoveringColor = false),
                  child: LabContainer(
                    height: theme.sizes.s8,
                    width: theme.sizes.s8,
                    decoration: BoxDecoration(
                      color: widget.profile != null
                          ? Color(profileToColor(widget.profile!))
                          : Color(npubToColor(Utils.encodeShareableFromString(
                              widget.pubkey ?? '',
                              type: 'npub'))),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color: theme.colors.white16,
                        width: LabLineThicknessData.normal().thin,
                      ),
                    ),
                  ),
                );
              },
            ),
            const LabGap.s8(),
            _isHoveringColor
                ? RichText(
                    text: TextSpan(
                      style: theme.typography.med12.copyWith(
                        color: theme.colors.white66,
                      ),
                      children: [
                        TextSpan(
                          text: _getHexColor(),
                          style: TextStyle(
                            color: widget.profile != null
                                ? Color(profileToColor(widget.profile!))
                                : Color(npubToColor(
                                    Utils.encodeShareableFromString(
                                        widget.pubkey ?? '',
                                        type: 'npub'))),
                          ),
                        ),
                        const TextSpan(text: ' Profile Color'),
                      ],
                    ),
                  )
                : LabText.med12(
                    _showCheck
                        ? 'Copied $_copiedType'
                        : (widget.profile != null
                            ? formatNpub(widget.profile!.npub)
                            : formatNpub(Utils.encodeShareableFromString(
                                widget.pubkey ?? '',
                                type: 'npub'))),
                    color: theme.colors.white66,
                  ),
            const SizedBox(width: 8),
            if (_showCheck)
              LabIcon.s8(
                theme.icons.characters.check,
                outlineColor: theme.colors.blurpleLightColor,
                outlineThickness: LabLineThicknessData.normal().medium,
              ),
            if (!_showCheck && widget.copyable)
              LabIcon.s14(
                theme.icons.characters.copy,
                outlineColor: theme.colors.white33,
                outlineThickness: LabLineThicknessData.normal().medium,
              ),
          ],
        );
      },
    );
  }
}
