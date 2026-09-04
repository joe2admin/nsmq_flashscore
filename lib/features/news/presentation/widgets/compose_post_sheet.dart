import 'package:flutter/material.dart';
import 'package:nsmq_flashscore/app/theme/app_borders.dart';
import 'package:nsmq_flashscore/app/theme/app_colors.dart';
import 'package:nsmq_flashscore/app/theme/app_shadows.dart';
import 'package:nsmq_flashscore/app/theme/app_typography.dart';
import 'package:nsmq_flashscore/core/constants/school_assets.dart';
import 'package:nsmq_flashscore/core/widgets/neo_button.dart';

class ComposePostSheet extends StatefulWidget {
  final Function({
    required String content,
    String? imageUrl,
    String? imageCaption,
    String category,
    required String authorName,
    required String authorHandle,
    String? authorRole,
    required Color authorColor,
    String? crestUrl,
  }) onPublish;

  const ComposePostSheet({super.key, required this.onPublish});

  static void show(
    BuildContext context, {
    required Function({
      required String content,
      String? imageUrl,
      String? imageCaption,
      String category,
      required String authorName,
      required String authorHandle,
      String? authorRole,
      required Color authorColor,
      String? crestUrl,
    }) onPublish,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ComposePostSheet(onPublish: onPublish),
    );
  }

  @override
  State<ComposePostSheet> createState() => _ComposePostSheetState();
}

class _ComposePostSheetState extends State<ComposePostSheet> {
  final TextEditingController _contentController = TextEditingController();
  int _characterCount = 0;
  bool _includePhoto = false;

  int _selectedPersonaIndex = 0;
  final List<Map<String, dynamic>> _personas = [
    {
      'name': 'NSMQ Fan',
      'handle': '@fan_gh',
      'role': 'FAN',
      'color': NeoColors.nsmqRed,
      'initials': 'FA',
      'crest': null,
    },
    {
      'name': 'PRESEC Ɔdadeɛ',
      'handle': '@PresecLegon',
      'role': '8x CHAMPIONS',
      'color': NeoColors.nsmqBlue,
      'initials': 'PL',
      'crest': SchoolAssets.presec,
    },
    {
      'name': 'Prempeh Amanfoo',
      'handle': '@PrempehCollege',
      'role': '5x CHAMPIONS',
      'color': NeoColors.green,
      'initials': 'PC',
      'crest': SchoolAssets.prempeh,
    },
    {
      'name': 'Wesley Girls High',
      'handle': '@WeyGeyHey',
      'role': 'CONTENDER',
      'color': NeoColors.gold,
      'initials': 'WG',
      'crest': SchoolAssets.wesleyGirls,
    },
  ];

  final List<String> _samplePhotos = [
    'https://images.unsplash.com/photo-1543269865-cbf427effbad?q=80&w=1000&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1523240795612-9a054b0db644?q=80&w=1000&auto=format&fit=crop',
  ];

  @override
  void initState() {
    super.initState();
    _contentController.addListener(() {
      setState(() {
        _characterCount = _contentController.text.length;
      });
    });
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _publish() {
    final text = _contentController.text.trim();
    if (text.isEmpty) return;

    final persona = _personas[_selectedPersonaIndex];
    widget.onPublish(
      content: text,
      imageUrl: _includePhoto ? _samplePhotos[0] : null,
      imageCaption: _includePhoto ? 'Live tournament dispatch from Kumasi' : null,
      category: _includePhoto ? 'PHOTOS' : 'LIVE BUZZ',
      authorName: persona['name'] as String,
      authorHandle: persona['handle'] as String,
      authorRole: persona['role'] as String,
      authorColor: persona['color'] as Color,
      crestUrl: persona['crest'] as String?,
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      decoration: const BoxDecoration(
        color: NeoColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(NeoBorders.lg),
          topRight: Radius.circular(NeoBorders.lg),
        ),
        border: Border(
          top: BorderSide(color: NeoColors.border, width: NeoBorders.strokeThick),
          left: BorderSide(color: NeoColors.border, width: NeoBorders.strokeThick),
          right: BorderSide(color: NeoColors.border, width: NeoBorders.strokeThick),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.edit_note, size: 22, color: NeoColors.nsmqRed),
                    const SizedBox(width: 8),
                    Text(
                      'NEW FEED DISPATCH',
                      style: NeoTypography.headingMedium(),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: NeoColors.textPrimary, size: 20),
                  onPressed: () => Navigator.of(context).pop(),
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: NeoColors.border, thickness: 1.5),

          // Persona Picker (Publish as...)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Row(
              children: [
                const Icon(Icons.account_circle, size: 14, color: NeoColors.textSecondary),
                const SizedBox(width: 6),
                Text(
                  'POST AS:',
                  style: NeoTypography.caption(color: NeoColors.textSecondary).copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(
            height: 38,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _personas.asMap().entries.map((entry) {
                final idx = entry.key;
                final p = entry.value;
                final isSelected = idx == _selectedPersonaIndex;

                return GestureDetector(
                  onTap: () => setState(() => _selectedPersonaIndex = idx),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? p['color'] as Color : NeoColors.surfaceMuted,
                      borderRadius: NeoBorders.radiusSm,
                      border: Border.all(color: NeoColors.border, width: 1),
                      boxShadow: isSelected ? NeoShadows.pill : null,
                    ),
                    child: Row(
                      children: [
                        if (p['crest'] != null) ...[
                          Image.asset(p['crest'] as String, width: 14, height: 14, fit: BoxFit.contain),
                          const SizedBox(width: 5),
                        ],
                        Text(
                          p['name'] as String,
                          style: NeoTypography.badge(
                            color: isSelected ? NeoColors.textLight : NeoColors.textPrimary,
                          ).copyWith(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 10),

          // Main Text Input Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: NeoColors.surfaceMuted,
                  borderRadius: NeoBorders.radiusSm,
                  border: Border.all(color: NeoColors.border, width: 1.5),
                ),
                child: TextField(
                  controller: _contentController,
                  maxLines: null,
                  expands: true,
                  maxLength: 280,
                  buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                  style: NeoTypography.bodyRegular(size: 14),
                  decoration: InputDecoration(
                    hintText: 'What\'s happening in the NSMQ stage? Buzz in with your thoughts...',
                    hintStyle: NeoTypography.bodyRegular(color: NeoColors.textSecondary, size: 13),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Actions & Attachment Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Attach photo toggle
                GestureDetector(
                  onTap: () => setState(() => _includePhoto = !_includePhoto),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _includePhoto ? NeoColors.surfaceYellow : NeoColors.surface,
                      borderRadius: NeoBorders.radiusSm,
                      border: Border.all(color: NeoColors.border, width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _includePhoto ? Icons.check_circle : Icons.add_photo_alternate,
                          size: 16,
                          color: _includePhoto ? NeoColors.nsmqRed : NeoColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _includePhoto ? 'PHOTO ATTACHED' : 'ATTACH PHOTO',
                          style: NeoTypography.badge(
                            color: _includePhoto ? NeoColors.nsmqRed : NeoColors.textSecondary,
                          ).copyWith(fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),

                // Character counter
                Text(
                  '${280 - _characterCount} left',
                  style: NeoTypography.caption(
                    color: _characterCount > 260 ? NeoColors.nsmqBrightRed : NeoColors.textSecondary,
                  ).copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: NeoColors.border, thickness: 1.5),

          // Bottom Publish Button
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: NeoButton(
                text: 'PUBLISH DISPATCH ⚡',
                onPressed: _characterCount > 0 ? _publish : null,
                backgroundColor: NeoColors.nsmqRed,
                textColor: NeoColors.textLight,
                width: double.infinity,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
