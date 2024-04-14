import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/config/theme/text_data.dart';
import 'package:frontend/config/theme/theme_data.dart';
import 'package:frontend/ui/components/bottom_button.dart';
import 'package:frontend/utils/library/date_time_spinner/base_picker_model.dart';
import 'package:frontend/utils/library/date_time_spinner/date_picker_theme.dart' as picker_theme;
import 'package:frontend/utils/library/date_time_spinner/i18n_model.dart';

typedef DateChangedCallback = Function(DateTime time);
typedef DateCancelledCallback = Function();
typedef StringAtIndexCallBack = String? Function(int index);

class DatePicker {
  ///
  /// Display date picker bottom sheet.
  ///
  static Future<DateTime?> showDatePicker(
    BuildContext context, {
    bool showTitleActions = true,
    DateTime? minTime,
    DateTime? maxTime,
    DateChangedCallback? onChanged,
    DateChangedCallback? onConfirm,
    DateCancelledCallback? onCancel,
    locale = LocaleType.en,
    DateTime? currentTime,
    picker_theme.DatePickerTheme? theme,
  }) async {
    return await Navigator.push(
      context,
      _DatePickerRoute(
        showTitleActions: showTitleActions,
        onChanged: onChanged,
        onConfirm: onConfirm,
        onCancel: onCancel,
        locale: locale,
        theme: theme,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        pickerModel: DatePickerModel(
          currentTime: currentTime,
          maxTime: maxTime,
          minTime: minTime,
          locale: locale,
        ),
      ),
    );
  }

  ///
  /// Display time picker bottom sheet.
  ///
  static Future<DateTime?> showTimePicker(
    BuildContext context, {
    bool showTitleActions = true,
    bool showSecondsColumn = true,
    DateChangedCallback? onChanged,
    DateChangedCallback? onConfirm,
    DateCancelledCallback? onCancel,
    locale = LocaleType.en,
    DateTime? currentTime,
    picker_theme.DatePickerTheme? theme,
  }) async {
    return await Navigator.push(
      context,
      _DatePickerRoute(
        showTitleActions: showTitleActions,
        onChanged: onChanged,
        onConfirm: onConfirm,
        onCancel: onCancel,
        locale: locale,
        theme: theme,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        pickerModel: TimePickerModel(
          currentTime: currentTime,
          locale: locale,
          showSecondsColumn: showSecondsColumn,
        ),
      ),
    );
  }

  ///
  /// Display time picker bottom sheet with AM/PM.
  ///
  static Future<DateTime?> showTime12hPicker(
    BuildContext context, {
    bool showTitleActions = true,
    DateChangedCallback? onChanged,
    DateChangedCallback? onConfirm,
    DateCancelledCallback? onCancel,
    locale = LocaleType.en,
    DateTime? currentTime,
    picker_theme.DatePickerTheme? theme,
  }) async {
    return await Navigator.push(
      context,
      _DatePickerRoute(
        showTitleActions: showTitleActions,
        onChanged: onChanged,
        onConfirm: onConfirm,
        onCancel: onCancel,
        locale: locale,
        theme: theme,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        pickerModel: Time12hPickerModel(
          currentTime: currentTime,
          locale: locale,
        ),
      ),
    );
  }

  ///
  /// Display date&time picker bottom sheet.
  ///
  static Future<DateTime?> showDateTimePicker(
    BuildContext context, {
    bool showTitleActions = true,
    DateTime? minTime,
    DateTime? maxTime,
    DateChangedCallback? onChanged,
    DateChangedCallback? onConfirm,
    DateCancelledCallback? onCancel,
    locale = LocaleType.en,
    DateTime? currentTime,
    picker_theme.DatePickerTheme? theme,
  }) async {
    return await Navigator.push(
      context,
      _DatePickerRoute(
        showTitleActions: showTitleActions,
        onChanged: onChanged,
        onConfirm: onConfirm,
        onCancel: onCancel,
        locale: locale,
        theme: theme,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        pickerModel: DateTimePickerModel(
          currentTime: currentTime,
          minTime: minTime,
          maxTime: maxTime,
          locale: locale,
        ),
      ),
    );
  }

  ///
  /// Display date picker bottom sheet witch custom picker model.
  ///
  static Future<DateTime?> showPicker(
    BuildContext context, {
    bool showTitleActions = true,
    DateChangedCallback? onChanged,
    DateChangedCallback? onConfirm,
    DateCancelledCallback? onCancel,
    locale = LocaleType.en,
    BasePickerModel? pickerModel,
    picker_theme.DatePickerTheme? theme,
  }) async {
    return await Navigator.push(
      context,
      _DatePickerRoute(
        showTitleActions: showTitleActions,
        onChanged: onChanged,
        onConfirm: onConfirm,
        onCancel: onCancel,
        locale: locale,
        theme: theme,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        pickerModel: pickerModel,
      ),
    );
  }
}

class _DatePickerRoute<T> extends PopupRoute<T> {
  _DatePickerRoute({
    this.showTitleActions,
    this.onChanged,
    this.onConfirm,
    this.onCancel,
    picker_theme.DatePickerTheme? theme,
    this.barrierLabel,
    this.locale,
    RouteSettings? settings,
    BasePickerModel? pickerModel,
  })  : pickerModel = pickerModel ?? DatePickerModel(),
        theme = theme ?? const picker_theme.DatePickerTheme(),
        super(settings: settings);

  final bool? showTitleActions;
  final DateChangedCallback? onChanged;
  final DateChangedCallback? onConfirm;
  final DateCancelledCallback? onCancel;
  final LocaleType? locale;
  final picker_theme.DatePickerTheme theme;
  final BasePickerModel pickerModel;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  bool get barrierDismissible => true;

  @override
  final String? barrierLabel;

  @override
  Color get barrierColor => Colors.black54;

  AnimationController? _animationController;

  @override
  AnimationController createAnimationController() {
    assert(_animationController == null);
    _animationController = BottomSheet.createAnimationController(navigator!.overlay!);
    return _animationController!;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    Widget bottomSheet = MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: _DatePickerComponent(
        onChanged: onChanged,
        locale: locale,
        route: this,
        pickerModel: pickerModel,
      ),
    );
    return InheritedTheme.captureAll(context, bottomSheet);
  }
}

class _DatePickerComponent extends StatefulWidget {
  const _DatePickerComponent({
    Key? key,
    required this.route,
    required this.pickerModel,
    this.onChanged,
    this.locale,
  }) : super(key: key);

  final DateChangedCallback? onChanged;

  final _DatePickerRoute route;

  final LocaleType? locale;

  final BasePickerModel pickerModel;

  @override
  State<StatefulWidget> createState() {
    return _DatePickerState();
  }
}

class _DatePickerState extends State<_DatePickerComponent> {
  late FixedExtentScrollController leftScrollCtrl, middleScrollCtrl, rightScrollCtrl;

  int currentFirstIndex = 0;
  int currentSecondIndex = 0;
  int currentThirdIndex = 0;

  @override
  void initState() {
    super.initState();
    refreshScrollOffset();
  }

  void refreshScrollOffset() {
    currentFirstIndex = widget.pickerModel.currentLeftIndex();
    currentSecondIndex = widget.pickerModel.currentMiddleIndex();
    currentThirdIndex = widget.pickerModel.currentRightIndex();
    leftScrollCtrl = FixedExtentScrollController(initialItem: widget.pickerModel.currentLeftIndex());
    middleScrollCtrl = FixedExtentScrollController(initialItem: widget.pickerModel.currentMiddleIndex());
    rightScrollCtrl = FixedExtentScrollController(initialItem: widget.pickerModel.currentRightIndex());
  }

  @override
  Widget build(BuildContext context) {
    picker_theme.DatePickerTheme theme = widget.route.theme;
    return GestureDetector(
      child: AnimatedBuilder(
        animation: widget.route.animation!,
        builder: (BuildContext context, Widget? child) {
          final double bottomPadding = 110.0.h;

          return ClipRect(
            child: CustomSingleChildLayout(
              delegate: _BottomPickerLayout(
                widget.route.animation!.value,
                theme,
                showTitleActions: widget.route.showTitleActions!,
                bottomPadding: bottomPadding,
              ),
              child: GestureDetector(
                child: Material(
                  color: Theme.of(context).colorScheme.backgroundModal,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25.0),
                    ),
                  ),
                  child: _renderPickerView(theme),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _notifyDateChanged() {
    if (widget.onChanged != null) {
      widget.onChanged!(widget.pickerModel.finalTime()!);
    }
  }

  Widget _renderPickerView(picker_theme.DatePickerTheme theme) {
    Widget itemView = _renderItemView(theme);
    if (widget.route.showTitleActions == true) {
      return Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 32.0.h, left: 24.0.w),
              child: Text(
                theme.title,
                style: kHeader4Style.copyWith(color: Theme.of(context).colorScheme.textTitle),
              ),
            ),
          ),
          itemView,
          _renderBottomActionsView(),
        ],
      );
    }
    return itemView;
  }

  Widget _firstColumnView(
    ValueKey key,
    picker_theme.DatePickerTheme theme,
    StringAtIndexCallBack stringAtIndexCB,
    ScrollController scrollController,
    int layoutProportion,
    ValueChanged<int> selectedChangedWhenScrolling,
    ValueChanged<int> selectedChangedWhenScrollEnd,
  ) {
    return Expanded(
      flex: layoutProportion,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        height: theme.containerHeight + 10,
        decoration: BoxDecoration(color: theme.backgroundColor),
        child: NotificationListener(
          onNotification: (ScrollNotification notification) {
            if (notification.depth == 0 && notification is ScrollEndNotification && notification.metrics is FixedExtentMetrics) {
              final FixedExtentMetrics metrics = notification.metrics as FixedExtentMetrics;
              final int currentItemIndex = metrics.itemIndex;
              currentFirstIndex = currentItemIndex;
              selectedChangedWhenScrollEnd(currentItemIndex);
            }
            return false;
          },
          child: CupertinoPicker.builder(
            key: key,
            backgroundColor: theme.backgroundColor,
            scrollController: scrollController as FixedExtentScrollController,
            itemExtent: theme.itemHeight,
            onSelectedItemChanged: (int index) {
              selectedChangedWhenScrolling(index);
            },
            useMagnifier: true,
            itemBuilder: (BuildContext context, int index) {
              final content = stringAtIndexCB(index);

              if (content == null) {
                return null;
              }
              return Container(
                height: theme.itemHeight,
                alignment: Alignment.center,
                child: Text(
                  content,
                  style: index == currentFirstIndex ? kHeader5Style.copyWith(color: Theme.of(context).colorScheme.primaryColor) : kHeader5Style.copyWith(color: Theme.of(context).colorScheme.textBody),
                  textAlign: TextAlign.start,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _secondColumnView(
    ValueKey key,
    picker_theme.DatePickerTheme theme,
    StringAtIndexCallBack stringAtIndexCB,
    ScrollController scrollController,
    int layoutProportion,
    ValueChanged<int> selectedChangedWhenScrolling,
    ValueChanged<int> selectedChangedWhenScrollEnd,
  ) {
    return Expanded(
      flex: layoutProportion,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        height: theme.containerHeight,
        decoration: BoxDecoration(color: theme.backgroundColor),
        child: NotificationListener(
          onNotification: (ScrollNotification notification) {
            if (notification.depth == 0 && notification is ScrollEndNotification && notification.metrics is FixedExtentMetrics) {
              final FixedExtentMetrics metrics = notification.metrics as FixedExtentMetrics;
              final int currentItemIndex = metrics.itemIndex;
              currentSecondIndex = currentItemIndex;
              selectedChangedWhenScrollEnd(currentItemIndex);
            }
            return false;
          },
          child: CupertinoPicker.builder(
            key: key,
            backgroundColor: theme.backgroundColor,
            scrollController: scrollController as FixedExtentScrollController,
            itemExtent: theme.itemHeight,
            onSelectedItemChanged: (int index) {
              selectedChangedWhenScrolling(index);
            },
            useMagnifier: true,
            itemBuilder: (BuildContext context, int index) {
              final content = stringAtIndexCB(index);
              if (content == null) {
                return null;
              }
              return Container(
                height: theme.itemHeight,
                alignment: Alignment.center,
                child: Text(
                  content,
                  style:
                      index == currentSecondIndex ? kHeader5Style.copyWith(color: Theme.of(context).colorScheme.primaryColor) : kHeader5Style.copyWith(color: Theme.of(context).colorScheme.textBody),
                  textAlign: TextAlign.start,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _thirdRenderColumnView(
    ValueKey key,
    picker_theme.DatePickerTheme theme,
    StringAtIndexCallBack stringAtIndexCB,
    ScrollController scrollController,
    int layoutProportion,
    ValueChanged<int> selectedChangedWhenScrolling,
    ValueChanged<int> selectedChangedWhenScrollEnd,
  ) {
    return Expanded(
      flex: layoutProportion,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        height: theme.containerHeight,
        decoration: BoxDecoration(color: theme.backgroundColor),
        child: NotificationListener(
          onNotification: (ScrollNotification notification) {
            if (notification.depth == 0 && notification is ScrollEndNotification && notification.metrics is FixedExtentMetrics) {
              final FixedExtentMetrics metrics = notification.metrics as FixedExtentMetrics;
              final int currentItemIndex = metrics.itemIndex;
              currentThirdIndex = currentItemIndex;
              selectedChangedWhenScrollEnd(currentItemIndex);
            }
            return false;
          },
          child: CupertinoPicker.builder(
            key: key,
            backgroundColor: theme.backgroundColor,
            scrollController: scrollController as FixedExtentScrollController,
            itemExtent: theme.itemHeight,
            onSelectedItemChanged: (int index) {
              selectedChangedWhenScrolling(index);
            },
            useMagnifier: true,
            itemBuilder: (BuildContext context, int index) {
              final content = stringAtIndexCB(index);

              if (content == null) {
                return null;
              }
              return Container(
                height: theme.itemHeight,
                alignment: Alignment.center,
                child: Text(
                  content,
                  style: index == currentThirdIndex ? kHeader5Style.copyWith(color: Theme.of(context).colorScheme.primaryColor) : kHeader5Style.copyWith(color: Theme.of(context).colorScheme.textBody),
                  textAlign: TextAlign.start,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _renderItemView(picker_theme.DatePickerTheme theme) {
    return Container(
      color: theme.backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: widget.pickerModel.layoutProportions()[0] > 0
                ? _firstColumnView(ValueKey(widget.pickerModel.currentLeftIndex()), theme, widget.pickerModel.leftStringAtIndex, leftScrollCtrl, widget.pickerModel.layoutProportions()[0], (index) {
                    widget.pickerModel.setLeftIndex(index);
                  }, (index) {
                    setState(() {
                      refreshScrollOffset();
                      _notifyDateChanged();
                    });
                  })
                : null,
          ),
          Text(
            widget.pickerModel.leftDivider(),
            style: theme.itemStyle,
          ),
          Container(
            child: widget.pickerModel.layoutProportions()[1] > 0
                ? _secondColumnView(ValueKey(widget.pickerModel.currentLeftIndex()), theme, widget.pickerModel.middleStringAtIndex, middleScrollCtrl, widget.pickerModel.layoutProportions()[1],
                    (index) {
                    widget.pickerModel.setMiddleIndex(index);
                  }, (index) {
                    setState(() {
                      refreshScrollOffset();
                      _notifyDateChanged();
                    });
                  })
                : null,
          ),
          Text(
            widget.pickerModel.rightDivider(),
            style: theme.itemStyle,
          ),
          Container(
            child: widget.pickerModel.layoutProportions()[2] > 0
                ? _thirdRenderColumnView(ValueKey(widget.pickerModel.currentMiddleIndex() * 100 + widget.pickerModel.currentLeftIndex()), theme, widget.pickerModel.rightStringAtIndex, rightScrollCtrl,
                    widget.pickerModel.layoutProportions()[2], (index) {
                    widget.pickerModel.setRightIndex(index);
                  }, (index) {
                    setState(() {
                      refreshScrollOffset();
                      _notifyDateChanged();
                    });
                  })
                : null,
          ),
        ],
      ),
    );
  }

  // Title View
  Widget _renderBottomActionsView() {
    return BottomButton(
      title: '변경하기',
      // bottomPadding: 20,
      onTap: () {
        Navigator.pop(context, widget.pickerModel.finalTime());
        if (widget.route.onConfirm != null) {
          widget.route.onConfirm!(widget.pickerModel.finalTime()!);
        }
      },
    );
  }
}

class _BottomPickerLayout extends SingleChildLayoutDelegate {
  _BottomPickerLayout(
    this.progress,
    this.theme, {
    this.showTitleActions,
    this.bottomPadding = 0,
  });

  final double progress;
  final bool? showTitleActions;
  final picker_theme.DatePickerTheme theme;
  final double bottomPadding;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    double maxHeight = theme.containerHeight;
    if (showTitleActions == true) {
      maxHeight += theme.titleHeight;
    }

    return BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
      minHeight: 0.0,
      maxHeight: maxHeight + bottomPadding,
    );
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final height = size.height - childSize.height * progress;
    return Offset(0.0, height);
  }

  @override
  bool shouldRelayout(_BottomPickerLayout oldDelegate) {
    return progress != oldDelegate.progress;
  }
}
