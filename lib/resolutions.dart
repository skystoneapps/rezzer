import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class Resolutions extends StatelessWidget {
  const Resolutions({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Column(
        children: [
          _Title(),
          SizedBox(height: 16),
          _ResolutionsList(),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return const Text(
      '2024 Resolutions 💪',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _ResolutionsList extends StatefulWidget {
  const _ResolutionsList();

  @override
  State<_ResolutionsList> createState() => _ResolutionsListState();
}

class _ResolutionsListState extends State<_ResolutionsList> {
  List<String> resolutions = [
    'Attend more meetups',
    'Travel every 6 weeks',
    'Exercise 3 times per week',
  ];

  bool _deleteMode = false;

  void onAddResolutionTap() {
    setState(() {
      resolutions.add('New resolution');
    });
  }

  void onDeleteResolutionTap(int index) {
    setState(() {
      resolutions.removeAt(index);
    });
  }

  void _onLongPressResolution() {
    setState(() {
      _deleteMode = !_deleteMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (resolutions.isEmpty) {
      return _NoResolutions(
        onTap: onAddResolutionTap,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      itemCount: resolutions.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        if (index >= resolutions.length) {
          return InkWell(
            onTap: onAddResolutionTap,
            child: DottedBorder(
              borderType: BorderType.RRect,
              padding: const EdgeInsets.all(16),
              radius: const Radius.circular(8),
              child: const Text(
                'Add a new resolution',
              ),
            ),
          );
        }
        final resolution = resolutions[index];

        return _ResolutionTile(
          onLongPress: _onLongPressResolution,
          resolution: resolution,
          showDelete: _deleteMode,
          onDeleteTapped: () => onDeleteResolutionTap(index),
        );
      },
    );
  }
}

const _deleteButtonSize = 24.0;

class _ResolutionTile extends StatelessWidget {
  final String resolution;
  final bool showDelete;
  final VoidCallback? onLongPress;
  final VoidCallback? onDeleteTapped;

  const _ResolutionTile({
    required this.resolution,
    this.onLongPress,
    this.onDeleteTapped,
    this.showDelete = false,
  });

  @override
  Widget build(BuildContext context) {
    final child = InkWell(
      onLongPress: onLongPress,
      child: DottedBorder(
        borderType: BorderType.RRect,
        padding: const EdgeInsets.all(16),
        radius: const Radius.circular(8),
        child: Text(
          resolution,
        ),
      ),
    );

    if (showDelete) {
      return _Shaker(
        child: Stack(
          fit: StackFit.passthrough,
          clipBehavior: Clip.none,
          children: [
            child,
            Positioned(
              top: -_deleteButtonSize / 2,
              left: -_deleteButtonSize / 2,
              child: SizedBox(
                width: _deleteButtonSize,
                height: _deleteButtonSize,
                child: _DeleteBadge(
                  onTap: onDeleteTapped,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return child;
  }
}

class _Shaker extends StatefulWidget {
  final Widget child;
  const _Shaker({
    required this.child,
  });

  @override
  State<_Shaker> createState() => _ShakerState();
}

class _ShakerState extends State<_Shaker> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  )..repeat(reverse: true);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Transform.rotate(
          angle: 0.02 - _controller.value * 0.04,
          child: widget.child,
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _DeleteBadge extends StatelessWidget {
  final VoidCallback? onTap;
  const _DeleteBadge({
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      style: IconButton.styleFrom(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      padding: const EdgeInsets.all(0),
      iconSize: _deleteButtonSize,
      icon: const Icon(
        Icons.remove,
        color: Colors.white,
      ),
      onPressed: onTap,
    );
  }
}

class _NoResolutions extends StatelessWidget {
  final VoidCallback onTap;
  const _NoResolutions({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onTap,
        child: DottedBorder(
          borderType: BorderType.RRect,
          padding: const EdgeInsets.all(16),
          radius: const Radius.circular(8),
          child: const Text(
            'Add your first resolution!',
          ),
        ),
      ),
    );
  }
}
