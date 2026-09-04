import 'package:flutter/material.dart';
import 'package:nsmq_flashscore/app/theme/app_borders.dart';
import 'package:nsmq_flashscore/app/theme/app_colors.dart';
import 'package:nsmq_flashscore/app/theme/app_shadows.dart';
import 'package:nsmq_flashscore/app/theme/app_typography.dart';
import 'package:nsmq_flashscore/core/constants/school_assets.dart';
import 'package:nsmq_flashscore/core/utils/number_formatter.dart';
import 'package:nsmq_flashscore/features/news/domain/entities/feed_post.dart';

class FeedPostCard extends StatelessWidget {
  final FeedPost post;
  final VoidCallback onLikeTap;
  final VoidCallback onCommentTap;
  final VoidCallback onShareTap;
  final VoidCallback onBookmarkTap;
  final VoidCallback? onRetweetTap;
  final ValueChanged<int>? onVotePoll;

  const FeedPostCard({
    super.key,
    required this.post,
    required this.onLikeTap,
    required this.onCommentTap,
    required this.onShareTap,
    required this.onBookmarkTap,
    this.onRetweetTap,
    this.onVotePoll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: NeoColors.surface,
        borderRadius: NeoBorders.radiusMd,
        border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
        boxShadow: NeoShadows.card,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: NeoBorders.radiusMd,
          onTap: onCommentTap,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Avatar, Name, Handle, Time, Badge
                _buildHeader(),

                const SizedBox(height: 10),

                // Post Content (Tweet text with mentions/hashtags)
                _buildContent(),

                // Attached Picture (if any)
                if (post.imageUrl != null && post.imageUrl!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  _buildPictureFrame(),
                ],

                // Attached Poll / Quiz (if any)
                if (post.poll != null) ...[
                  const SizedBox(height: 12),
                  _buildPollCard(post.poll!),
                ],

                const SizedBox(height: 12),

                // Divider line
                Container(
                  height: 1,
                  color: NeoColors.neutralMuted,
                  margin: const EdgeInsets.only(bottom: 10),
                ),

                // Engagement Actions (Comments, Retweets, Likes, Share, Bookmark)
                _buildEngagementBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Neo Avatar with solid border
        _buildAvatar(),
        const SizedBox(width: 10),

        // Author Name, Handle & Time
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      post.authorName,
                      style: NeoTypography.bodyBold(size: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (post.isVerified) ...[
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.verified,
                      size: 15,
                      color: NeoColors.nsmqBlue,
                    ),
                  ],
                  if (post.authorRole != null) ...[
                    const SizedBox(width: 6),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: NeoColors.surfaceYellow,
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(color: NeoColors.border, width: 1),
                        ),
                        child: Text(
                          post.authorRole!,
                          style: NeoTypography.badge(color: NeoColors.textPrimary).copyWith(fontSize: 8),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 1),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      post.authorHandle,
                      style: NeoTypography.caption(color: NeoColors.textSecondary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '• ${post.timeAgo}',
                    style: NeoTypography.caption(color: NeoColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    final crest = post.crestUrl ??
        SchoolAssets.getBadge(post.schoolId) ??
        SchoolAssets.getBadge(post.authorHandle) ??
        SchoolAssets.getBadge(post.authorName) ??
        SchoolAssets.getBadge(post.authorRole) ??
        (post.authorHandle == '@NSMQGhana' || post.category == 'OFFICIAL'
            ? SchoolAssets.nsmqLogo
            : null);

    final hasImage = crest != null && crest.isNotEmpty;

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: hasImage ? Colors.white : post.authorColor,
        borderRadius: NeoBorders.radiusSm,
        border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
        boxShadow: NeoShadows.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: hasImage
          ? Padding(
              padding: const EdgeInsets.all(3.0),
              child: Image.asset(
                crest,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => Center(
                  child: Text(
                    post.authorInitials,
                    style: NeoTypography.badge(color: NeoColors.textPrimary).copyWith(fontSize: 13),
                  ),
                ),
              ),
            )
          : Center(
              child: Text(
                post.authorInitials,
                style: NeoTypography.badge(color: NeoColors.textLight).copyWith(fontSize: 13),
              ),
            ),
    );
  }

  Widget _buildContent() {
    // Rich rendering of hashtags and mentions while strictly preserving
    // all whitespace, newlines, and punctuation.
    final text = post.content;
    final regex = RegExp(r'([#@][a-zA-Z0-9_ɔɛƆƐ]+)');
    final matches = regex.allMatches(text);
    final textSpans = <TextSpan>[];

    final regularStyle = NeoTypography.bodyRegular(
      color: NeoColors.textPrimary,
      size: 13,
    );
    final highlightStyle = NeoTypography.bodyBold(
      color: NeoColors.nsmqBlue,
      size: 13,
    );

    int lastIndex = 0;
    for (final match in matches) {
      if (match.start > lastIndex) {
        textSpans.add(
          TextSpan(
            text: text.substring(lastIndex, match.start),
            style: regularStyle,
          ),
        );
      }
      textSpans.add(
        TextSpan(
          text: match.group(0),
          style: highlightStyle,
        ),
      );
      lastIndex = match.end;
    }

    if (lastIndex < text.length) {
      textSpans.add(
        TextSpan(
          text: text.substring(lastIndex),
          style: regularStyle,
        ),
      );
    }

    return Text.rich(
      TextSpan(children: textSpans),
      style: regularStyle,
    );
  }

  Widget _buildPictureFrame() {
    return Container(
      decoration: BoxDecoration(
        color: NeoColors.darkCanvas,
        borderRadius: NeoBorders.radiusSm,
        border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
        boxShadow: NeoShadows.pill,
      ),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(
        aspectRatio: post.imageAspectRatio ?? (16 / 9),
        child: Image.network(
          post.imageUrl!,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: NeoColors.surfaceMuted,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                  color: NeoColors.nsmqRed,
                  strokeWidth: 2.5,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            // Stylish Neo fallback card if network image is unavailable
            return Container(
              color: NeoColors.nsmqElectricBlue,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Center(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.flash_on, size: 22, color: NeoColors.gold),
                      const SizedBox(height: 3),
                      Text(
                        'NSMQ MATCHDAY MOMENT',
                        style: NeoTypography.badge(color: NeoColors.textLight).copyWith(fontSize: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPollCard(FeedPoll poll) {
    final hasVoted = poll.userVotedIndex != null;
    final total = poll.totalVotes > 0 ? poll.totalVotes : 1;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: NeoColors.surfaceMuted,
        borderRadius: NeoBorders.radiusSm,
        border: Border.all(color: NeoColors.border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  poll.question,
                  style: NeoTypography.bodyBold(size: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${poll.totalVotes} votes',
                style: NeoTypography.caption(color: NeoColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Options list
          for (int i = 0; i < poll.options.length; i++) ...[
            _buildPollOption(poll.options[i], i, hasVoted, total, poll),
            if (i < poll.options.length - 1) const SizedBox(height: 6),
          ],

          if (hasVoted && poll.explanation != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: NeoColors.surfaceYellow,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: NeoColors.border, width: 1),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.lightbulb, size: 14, color: NeoColors.nsmqRed),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      poll.explanation!,
                      style: NeoTypography.caption(color: NeoColors.textPrimary).copyWith(fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPollOption(
    FeedPollOption option,
    int index,
    bool hasVoted,
    int total,
    FeedPoll poll,
  ) {
    final percentage = (option.votes / total) * 100;
    final isSelected = poll.userVotedIndex == index;

    if (!hasVoted) {
      return InkWell(
        onTap: () => onVotePoll?.call(index),
        borderRadius: NeoBorders.radiusSm,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: NeoColors.surface,
            borderRadius: NeoBorders.radiusSm,
            border: Border.all(color: NeoColors.border, width: 1),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  option.text,
                  style: NeoTypography.bodyBold(size: 12),
                ),
              ),
              const Icon(Icons.radio_button_unchecked, size: 14, color: NeoColors.textSecondary),
            ],
          ),
        ),
      );
    }

    // After voting: show percentage bars
    Color barColor = isSelected ? NeoColors.surfaceBlue : NeoColors.neutralMuted;
    if (poll.isQuiz) {
      if (option.isCorrect) {
        barColor = const Color(0xFFD1FAE5); // soft green
      } else if (isSelected && !option.isCorrect) {
        barColor = NeoColors.surfaceRed;
      }
    }

    return Container(
      width: double.infinity,
      height: 36,
      decoration: BoxDecoration(
        color: NeoColors.surface,
        borderRadius: NeoBorders.radiusSm,
        border: Border.all(
          color: isSelected ? NeoColors.nsmqBlue : NeoColors.border,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // Fill progress bar
          FractionallySizedBox(
            widthFactor: (percentage / 100).clamp(0.0, 1.0),
            child: Container(color: barColor),
          ),
          // Option Text & Percentage
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      if (isSelected) ...[
                        const Icon(Icons.check_circle, size: 14, color: NeoColors.nsmqBlue),
                        const SizedBox(width: 4),
                      ],
                      Flexible(
                        child: Text(
                          option.text,
                          style: NeoTypography.bodyBold(size: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${percentage.toStringAsFixed(0)}%',
                  style: NeoTypography.badge(color: NeoColors.textPrimary).copyWith(fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEngagementBar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTiny = constraints.maxWidth < 280;
        final isCompact = constraints.maxWidth < 320;
        final iconSize = isTiny ? 18.5 : (isCompact ? 20.5 : 22.0);
        final fontSize = isTiny ? 11.0 : (isCompact ? 11.5 : 12.5);
        final itemGap = isTiny ? 8.0 : (isCompact ? 10.0 : 12.0);
        final itemPadding = isTiny
            ? const EdgeInsets.symmetric(horizontal: 2.0, vertical: 4)
            : (isCompact
                ? const EdgeInsets.symmetric(horizontal: 2.5, vertical: 4)
                : const EdgeInsets.symmetric(horizontal: 3.5, vertical: 4));

        return Row(
          children: [
            // 1. Likes (First, Thumbs up + count)
            _buildActionItem(
              icon: post.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
              count: post.likesCount,
              activeColor: NeoColors.nsmqBrightRed,
              isActive: post.isLiked,
              onTap: onLikeTap,
              iconSize: iconSize,
              fontSize: fontSize,
              padding: itemPadding,
            ),
            SizedBox(width: itemGap),

            // 2. Comments (Chat bubble + count)
            _buildActionItem(
              icon: Icons.chat_bubble_outline,
              count: post.commentsCount,
              activeColor: NeoColors.nsmqBlue,
              isActive: false,
              onTap: onCommentTap,
              iconSize: iconSize,
              fontSize: fontSize,
              padding: itemPadding,
            ),
            SizedBox(width: itemGap),

            // 3. Share (Share icon + count)
            _buildActionItem(
              icon: Icons.share_outlined,
              count: post.sharesCount,
              activeColor: NeoColors.nsmqElectricBlue,
              isActive: false,
              onTap: onShareTap,
              iconSize: iconSize,
              fontSize: fontSize,
              padding: itemPadding,
            ),

            const Spacer(),

            // 4. Bookmark (Far right, Instagram-style save icon)
            InkWell(
              onTap: onBookmarkTap,
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: itemPadding,
                child: Icon(
                  post.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  size: iconSize,
                  color: post.isBookmarked ? NeoColors.gold : NeoColors.textSecondary,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required int count,
    required Color activeColor,
    required bool isActive,
    required VoidCallback onTap,
    required double iconSize,
    required double fontSize,
    required EdgeInsets padding,
  }) {
    final color = isActive ? activeColor : NeoColors.textSecondary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: iconSize, color: color),
            if (count > 0) ...[
              const SizedBox(width: 4),
              Text(
                _formatCount(count),
                style: NeoTypography.caption(color: color).copyWith(
                  fontWeight: isActive ? FontWeight.w800 : FontWeight.w700,
                  fontSize: fontSize,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatCount(int count) => NumberFormatter.formatCount(count);
}
