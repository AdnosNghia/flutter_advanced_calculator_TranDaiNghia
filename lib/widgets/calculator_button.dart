import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';

class CalculatorButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final int flex;
  final bool isCircular;

  const CalculatorButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.onLongPress,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.flex = 1,
    this.isCircular = true,
  });

  @override
  State<CalculatorButton> createState() => _CalculatorButtonState();
}

class _CalculatorButtonState extends State<CalculatorButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: AppConstants.buttonAnimDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) {
    _animController.forward();
  }

  void _onTapUp(TapUpDetails _) {
    _animController.reverse();
  }

  void _onTapCancel() {
    _animController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.flex,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onLongPress: widget.onLongPress,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(scale: _scaleAnimation.value, child: child);
          },
          child: Container(
            margin: const EdgeInsets.all(AppConstants.buttonSpacing / 2),
            child: Material(
              color: widget.backgroundColor ?? Colors.grey[800],
              borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
              child: InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  widget.onPressed();
                },
                onLongPress: widget.onLongPress,
                borderRadius: BorderRadius.circular(AppConstants.buttonRadius),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        fontSize:
                            widget.fontSize ?? AppConstants.buttonFontSize,
                        fontWeight: FontWeight.w500,
                        color: widget.textColor ?? Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedBuilder extends StatelessWidget {
  final Animation<double> animation;
  final Widget Function(BuildContext, Widget?) builder;
  final Widget? child;

  const AnimatedBuilder({
    super.key,
    required this.animation,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder2(
      animation: animation,
      builder: builder,
      child: child,
    );
  }
}

class AnimatedBuilder2 extends AnimatedWidget {
  final Widget Function(BuildContext, Widget?) builder;
  final Widget? child;

  const AnimatedBuilder2({
    super.key,
    required Animation<double> animation,
    required this.builder,
    this.child,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}
