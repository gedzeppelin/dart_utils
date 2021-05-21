import "package:enigma_core/enigma_core.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";

import "util.dart";

// ANCHOR FuturePage StatefulWidget.
class FuturePage<T> extends StatefulWidget {
  FuturePage({
    Key? key,
    required this.futureCallback,
    required this.appBar,
    required this.builder,
    this.onResolve,
    this.isRefreshable = true,
    // Scaffold.
    this.scaffoldKey,
    this.drawer,
    // Error.
    this.errorBuilder,
    this.errorButtonTextColor = Colors.black,
    this.errorTextColor = Colors.black,
    this.errorTextSize = 16.0,
    // Loader.
    this.loaderBuilder,
    this.loaderColor = Colors.blue,
    this.loaderSize = 35.0,
  }) : super(key: key);

  final AppBar appBar;
  final SuccessBuilder<T> builder;
  final Drawer? drawer;
  final ErrorBuilder? errorBuilder;
  final Color errorButtonTextColor;
  // Error widget parameters.
  final Color errorTextColor;

  final double errorTextSize;
  // General parameters.
  final FutureCallback<T> futureCallback;

  final bool isRefreshable;
  final WidgetBuilder? loaderBuilder;
  // Loader widget parameters.
  final Color loaderColor;

  final double loaderSize;
  final OnResolve<T>? onResolve;
  // Scaffold parameters.
  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  FuturePageState<T> createState() => FuturePageState<T>();
}

// ANCHOR FuturePage State.
class FuturePageState<T> extends State<FuturePage<T>> {
  late Future<Response<T>> _futureData;
  bool _isAppBarLoaderVisible = false;

  @override
  void initState() {
    super.initState();
    // Fetch the future data on initiation.
    _futureData = widget.futureCallback();

    // On resolve method.
    final _onResolve = widget.onResolve;
    if (_onResolve != null) {
      _futureData.attachOnSuccess(_onResolve);
    }
  }

  Future<Response<T>> refresh() {
    setState(() {
      _isAppBarLoaderVisible = true;
      _futureData = widget.futureCallback();
    });

    // On resolve method.
    final _onResolve = widget.onResolve;
    if (_onResolve != null) {
      _futureData.attachOnSuccess(_onResolve);
    }

    _futureData.whenComplete(() {
      setState(() => _isAppBarLoaderVisible = false);
    });

    return _futureData;
  }

  @override
  Widget build(BuildContext context) {
    AppBar _appBar;

    // AppBar"s progress loader.
    final _appBarLoader = Visibility(
      visible: _isAppBarLoaderVisible,
      child: SizedBox(
        height: 4.0,
        child: LinearProgressIndicator(
          value: null,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
        ),
      ),
    );

    // AppBar (re)construction with _appBarLoader.
    if (widget.appBar.bottom == null) {
      _appBar = widget.appBar.copyWith(
        bottom: PreferredSize(
          child: _appBarLoader,
          preferredSize: Size(MediaQuery.of(context).size.width, 4.0),
        ),
      );
    } else {
      final _bottom = widget.appBar.bottom;
      final _bottomSize = _bottom?.preferredSize;
      _appBar = widget.appBar.copyWith(
        bottom: PreferredSize(
          child: Column(
            children: <Widget>[
              if (_bottom != null) _bottom,
              _appBarLoader,
            ],
          ),
          preferredSize: Size(
            MediaQuery.of(context).size.width,
            (_bottomSize?.height ?? 0) + 4.0,
          ),
        ),
      );
    }

    // Final returned Scaffold.
    return Scaffold(
      key: widget.scaffoldKey,
      appBar: _appBar,
      body: FutureBuilder<Response<T>>(
        future: _futureData,
        builder: (BuildContext context, AsyncSnapshot<Response<T>> snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!.map(
              ifOk: (ok) {
                final buildedChild = widget.builder(context, ok.payload);

                if (widget.isRefreshable) {
                  return RefreshIndicator(
                    child: buildedChild,
                    onRefresh: () async {
                      setState(() {
                        _futureData = widget.futureCallback();
                      });

                      // On resolve method.
                      final _onResolve = widget.onResolve;
                      if (_onResolve != null) {
                        _futureData.attachOnSuccess(_onResolve);
                      }

                      await _futureData;
                    },
                  );
                }

                return buildedChild;
              },
              ifErr: (err) {
                final retryWidget = makeRetryWidget(refresh, err);
                return widget.errorBuilder?.call(context, refresh, err) ??
                    retryWidget;
              },
            );
          } else if (snapshot.hasError) {
            final err = Err<T>(payload: snapshot.error);
            final retryWidget = makeRetryWidget(refresh, err);

            return widget.errorBuilder?.call(context, refresh, err) ??
                retryWidget;
          }

          return widget.loaderBuilder?.call(context) ??
              SpinKitRing(
                lineWidth: 2.0,
                color: widget.loaderColor,
                size: widget.loaderSize,
              );
        },
      ),
      drawer: widget.drawer,
    );
  }
}

extension AppBarExtension on AppBar {
  static AppBar withTitle(String title) => AppBar(title: Text(title));

  AppBar copyWith({
    Key? key,
    Widget? leading,
    bool? automaticallyImplyLeading,
    Widget? title,
    List<Widget>? actions,
    Widget? flexibleSpace,
    PreferredSizeWidget? bottom,
    double? elevation,
    ShapeBorder? shape,
    Color? backgroundColor,
    Brightness? brightness,
    IconThemeData? iconTheme,
    IconThemeData? actionsIconTheme,
    TextTheme? textTheme,
    bool? primary,
    bool? centerTitle,
    bool? excludeHeaderSemantics,
    double? titleSpacing,
    double? toolbarOpacity,
    double? bottomOpacity,
  }) {
    return AppBar(
      key: key ?? this.key,
      leading: leading ?? this.leading,
      automaticallyImplyLeading:
          automaticallyImplyLeading ?? this.automaticallyImplyLeading,
      title: title ?? this.title,
      actions: actions ?? this.actions,
      flexibleSpace: flexibleSpace ?? this.flexibleSpace,
      bottom: bottom ?? this.bottom,
      elevation: elevation ?? this.elevation,
      shape: shape ?? this.shape,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      brightness: brightness ?? this.brightness,
      iconTheme: iconTheme ?? this.iconTheme,
      actionsIconTheme: actionsIconTheme ?? this.actionsIconTheme,
      textTheme: textTheme ?? this.textTheme,
      primary: primary ?? this.primary,
      centerTitle: centerTitle ?? this.centerTitle,
      excludeHeaderSemantics:
          excludeHeaderSemantics ?? this.excludeHeaderSemantics,
      titleSpacing: titleSpacing ?? this.titleSpacing,
      toolbarOpacity: toolbarOpacity ?? this.toolbarOpacity,
      bottomOpacity: bottomOpacity ?? this.bottomOpacity,
    );
  }
}
