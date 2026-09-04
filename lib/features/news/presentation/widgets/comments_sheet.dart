import 'package:flutter/material.dart';
import 'package:nsmq_flashscore/app/theme/app_borders.dart';
import 'package:nsmq_flashscore/app/theme/app_colors.dart';
import 'package:nsmq_flashscore/app/theme/app_shadows.dart';
import 'package:nsmq_flashscore/app/theme/app_typography.dart';
import 'package:nsmq_flashscore/core/constants/school_assets.dart';
import 'package:nsmq_flashscore/core/utils/number_formatter.dart';
import 'package:nsmq_flashscore/core/widgets/neo_button.dart';
import 'package:nsmq_flashscore/features/news/domain/entities/feed_post.dart';

class CommentsSheet extends StatefulWidget {
  final FeedPost post;
  final Function(String commentText, {String? replyingToHandle}) onAddComment;
  final Function(String commentId)? onToggleLikeComment;

  const CommentsSheet({
    super.key,
    required this.post,
    required this.onAddComment,
    this.onToggleLikeComment,
  });

  static void show(
    BuildContext context, {
    required FeedPost post,
    required Function(String commentText, {String? replyingToHandle}) onAddComment,
    Function(String commentId)? onToggleLikeComment,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CommentsSheet(
        post: post,
        onAddComment: onAddComment,
        onToggleLikeComment: onToggleLikeComment,
      ),
    );
  }

  @override
  State<CommentsSheet> createState() => _CommentsSheetState();
}

class _CommentsSheetState extends State<CommentsSheet> {
  final TextEditingController _replyController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late List<FeedComment> _comments;
  FeedComment? _replyingToComment;

  @override
  void initState() {
    super.initState();
    _comments = List.from(widget.post.comments);
  }

  @override
  void dispose() {
    _replyController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleLikeComment(int index) {
    setState(() {
      final comment = _comments[index];
      final newLiked = !comment.isLiked;
      final newCount = newLiked ? comment.likesCount + 1 : (comment.likesCount > 0 ? comment.likesCount - 1 : 0);

      _comments[index] = comment.copyWith(
        isLiked: newLiked,
        likesCount: newCount,
      );
    });

    widget.onToggleLikeComment?.call(_comments[index].id);
  }

  void _startReplyTo(FeedComment comment) {
    setState(() {
      _replyingToComment = comment;
    });

    _replyController.text = '${comment.authorHandle} ';
    _replyController.selection = TextSelection.fromPosition(
      TextPosition(offset: _replyController.text.length),
    );
    _focusNode.requestFocus();
  }

  void _cancelReply() {
    setState(() {
      _replyingToComment = null;
    });
    _replyController.clear();
  }

  void _submitReply() {
    final text = _replyController.text.trim();
    if (text.isEmpty) return;

    final targetHandle = _replyingToComment?.authorHandle;

    widget.onAddComment(text, replyingToHandle: targetHandle);

    setState(() {
      _comments.insert(
        0,
        FeedComment(
          id: 'c_${DateTime.now().millisecondsSinceEpoch}',
          authorName: 'You (Fan)',
          authorHandle: '@you_gh',
          authorInitials: 'YO',
          authorColor: NeoColors.nsmqRed,
          content: text,
          timeAgo: 'Just now',
          likesCount: 0,
          isLiked: false,
          replyingToHandle: targetHandle,
        ),
      );
      _replyingToComment = null;
    });

    _replyController.clear();
    _focusNode.unfocus();
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
          // Drag Handle & Header
          _buildHeader(context),

          const Divider(height: 1, color: NeoColors.border, thickness: 1.5),

          // Original Post Mini Quote
          _buildOriginalPostSnippet(),

          const Divider(height: 1, color: NeoColors.neutralMuted),

          // Comments Scrollable List
          Expanded(
            child: _comments.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.chat_bubble_outline, size: 36, color: NeoColors.textSecondary),
                          const SizedBox(height: 8),
                          Text(
                            'NO REPLIES YET',
                            style: NeoTypography.headingMedium(),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Be the first to chime in and start the discussion!',
                            style: NeoTypography.bodyRegular(color: NeoColors.textSecondary),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: _comments.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 16,
                      color: NeoColors.neutralMuted,
                    ),
                    itemBuilder: (context, index) {
                      final comment = _comments[index];
                      return _buildCommentTile(comment, index);
                    },
                  ),
          ),

          // Replying to Banner (if active)
          if (_replyingToComment != null) _buildReplyingBanner(),

          const Divider(height: 1, color: NeoColors.border, thickness: 1.5),

          // Bottom Reply Input Bar
          _buildReplyInput(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.forum, size: 20, color: NeoColors.nsmqRed),
              const SizedBox(width: 8),
              Text(
                'CONVERSATION',
                style: NeoTypography.headingMedium(),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: NeoColors.surfaceBlue,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: NeoColors.border, width: 1),
                ),
                child: Text(
                  '${_comments.length}',
                  style: NeoTypography.badge(color: NeoColors.nsmqBlue).copyWith(fontSize: 10),
                ),
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
    );
  }

  Widget _buildOriginalPostSnippet() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: NeoColors.surfaceMuted,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPostSnippetAvatar(),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        widget.post.authorName,
                        style: NeoTypography.bodyBold(size: 11),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.post.authorHandle,
                      style: NeoTypography.caption(color: NeoColors.textSecondary).copyWith(fontSize: 10),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  widget.post.content,
                  style: NeoTypography.bodyRegular(color: NeoColors.textSecondary, size: 11),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostSnippetAvatar() {
    final crest = widget.post.crestUrl ??
        SchoolAssets.getBadge(widget.post.schoolId) ??
        SchoolAssets.getBadge(widget.post.authorHandle) ??
        SchoolAssets.getBadge(widget.post.authorName) ??
        SchoolAssets.getBadge(widget.post.authorRole) ??
        (widget.post.authorHandle == '@NSMQGhana' || widget.post.category == 'OFFICIAL'
            ? SchoolAssets.nsmqLogo
            : null);

    final hasImage = crest != null && crest.isNotEmpty;

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: hasImage ? Colors.white : widget.post.authorColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: NeoColors.border, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: hasImage
          ? Padding(
              padding: const EdgeInsets.all(2.0),
              child: Image.asset(
                crest,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => Center(
                  child: Text(
                    widget.post.authorInitials,
                    style: NeoTypography.badge(color: NeoColors.textPrimary).copyWith(fontSize: 9),
                  ),
                ),
              ),
            )
          : Center(
              child: Text(
                widget.post.authorInitials,
                style: NeoTypography.badge(color: NeoColors.textLight).copyWith(fontSize: 9),
              ),
            ),
    );
  }

  Widget _buildCommentTile(FeedComment comment, int index) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar with school crest fallback to initials
        _buildCommentAvatar(comment),
        const SizedBox(width: 10),

        // Comment body & actions
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Author Name, Handle & Time
              Row(
                children: [
                  Flexible(
                    child: Text(
                      comment.authorName,
                      style: NeoTypography.bodyBold(size: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    comment.authorHandle,
                    style: NeoTypography.caption(color: NeoColors.textSecondary).copyWith(fontSize: 10),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '• ${comment.timeAgo}',
                    style: NeoTypography.caption(color: NeoColors.textSecondary).copyWith(fontSize: 10),
                  ),
                ],
              ),

              // Replying indicator (if this comment is a reply)
              if (comment.replyingToHandle != null) ...[
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.reply, size: 11, color: NeoColors.nsmqBlue),
                    const SizedBox(width: 3),
                    Text(
                      'Replying to ${comment.replyingToHandle}',
                      style: NeoTypography.caption(color: NeoColors.nsmqBlue).copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 4),

              // Content
              Text(
                comment.content,
                style: NeoTypography.bodyRegular(size: 12),
              ),

              const SizedBox(height: 6),

              // Action buttons (Like & Reply)
              Row(
                children: [
                  // Like Comment Button
                  InkWell(
                    onTap: () => _toggleLikeComment(index),
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            comment.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                            size: 14,
                            color: comment.isLiked ? NeoColors.nsmqBrightRed : NeoColors.textSecondary,
                          ),
                          if (comment.likesCount > 0) ...[
                            const SizedBox(width: 4),
                            Text(
                              NumberFormatter.formatCount(comment.likesCount),
                              style: NeoTypography.caption(
                                color: comment.isLiked ? NeoColors.nsmqBrightRed : NeoColors.textSecondary,
                              ).copyWith(fontSize: 10, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Reply to Comment Button
                  InkWell(
                    onTap: () => _startReplyTo(comment),
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.reply, size: 13, color: NeoColors.textSecondary),
                          const SizedBox(width: 3),
                          Text(
                            'Reply',
                            style: NeoTypography.caption(color: NeoColors.textSecondary).copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReplyingBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      color: NeoColors.surfaceBlue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.reply, size: 14, color: NeoColors.nsmqBlue),
              const SizedBox(width: 6),
              Text(
                'Replying to ${_replyingToComment!.authorHandle}',
                style: NeoTypography.caption(color: NeoColors.nsmqBlue).copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          InkWell(
            onTap: _cancelReply,
            borderRadius: BorderRadius.circular(10),
            child: const Padding(
              padding: EdgeInsets.all(2.0),
              child: Icon(Icons.close, size: 15, color: NeoColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReplyInput() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: NeoColors.surface,
                  borderRadius: NeoBorders.radiusSm,
                  border: Border.all(color: NeoColors.border, width: NeoBorders.strokeDefault),
                  boxShadow: NeoShadows.pill,
                ),
                child: TextField(
                  controller: _replyController,
                  focusNode: _focusNode,
                  maxLines: null,
                  style: NeoTypography.bodyRegular(size: 13),
                  decoration: InputDecoration(
                    hintText: _replyingToComment != null
                        ? 'Write a reply to ${_replyingToComment!.authorHandle}...'
                        : 'Post your reply...',
                    hintStyle: const TextStyle(fontSize: 12, color: NeoColors.textSecondary),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            NeoButton(
              text: 'REPLY',
              onPressed: _submitReply,
              backgroundColor: NeoColors.nsmqRed,
              textColor: NeoColors.textLight,
              isDense: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentAvatar(FeedComment comment) {
    final crest = SchoolAssets.getBadge(comment.authorHandle) ??
        SchoolAssets.getBadge(comment.authorName);
    final hasImage = crest != null && crest.isNotEmpty;

    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: hasImage ? Colors.white : comment.authorColor,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: NeoColors.border, width: 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: hasImage
          ? Padding(
              padding: const EdgeInsets.all(2.0),
              child: Image.asset(
                crest,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => Center(
                  child: Text(
                    comment.authorInitials,
                    style: NeoTypography.badge(color: NeoColors.textPrimary).copyWith(fontSize: 10),
                  ),
                ),
              ),
            )
          : Center(
              child: Text(
                comment.authorInitials,
                style: NeoTypography.badge(color: NeoColors.textLight).copyWith(fontSize: 11),
              ),
            ),
    );
  }
}
