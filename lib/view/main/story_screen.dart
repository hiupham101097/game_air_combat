import 'package:flutter/material.dart';
import 'package:mini__game2/l10n/generated/app_localizations.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFF050713),
      appBar: AppBar(
        title: Text(l10n.storyTitle),
        backgroundColor: const Color(0xFF090D20),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        children: [
          const Positioned(
            top: -110,
            right: -100,
            child: _StoryRiftGlow(),
          ),
          SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.storySubtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF80D9FF),
                      fontSize: 13,
                      letterSpacing: 1.1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _StoryChapter(
                    title: l10n.storyChapterOneTitle,
                    body: l10n.storyChapterOneBody,
                    color: const Color(0xFF58D8FF),
                    icon: Icons.public,
                  ),
                  _StoryChapter(
                    title: l10n.storyChapterTwoTitle,
                    body: l10n.storyChapterTwoBody,
                    color: const Color(0xFFBD83FF),
                    icon: Icons.dangerous_outlined,
                  ),
                  _StoryChapter(
                    title: l10n.storyChapterThreeTitle,
                    body: l10n.storyChapterThreeBody,
                    color: const Color(0xFFFFC857),
                    icon: Icons.rocket_launch,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF102137).withAlpha(225),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF41CFFF)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.track_changes,
                            color: Color(0xFF74E8FF), size: 23),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.storyObjectiveTitle,
                                style: const TextStyle(
                                  color: Color(0xFF74E8FF),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.4,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                l10n.storyObjectiveBody,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  FilledButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.flight_takeoff),
                    label: Text(l10n.storyBackToHangar),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF087BAA),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
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

class _StoryChapter extends StatelessWidget {
  const _StoryChapter({
    required this.title,
    required this.body,
    required this.color,
    required this.icon,
  });

  final String title;
  final String body;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 13),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xD710172A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withAlpha(130)),
        boxShadow: [
          BoxShadow(
              color: color.withAlpha(22), blurRadius: 18, spreadRadius: 1),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withAlpha(28),
              shape: BoxShape.circle,
              border: Border.all(color: color.withAlpha(170)),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    letterSpacing: 0.6,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  body,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.45,
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

class _StoryRiftGlow extends StatelessWidget {
  const _StoryRiftGlow();

  @override
  Widget build(BuildContext context) => Container(
        width: 280,
        height: 280,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [Color(0x553C42D8), Color(0x003C42D8)],
          ),
        ),
      );
}
