import 'package:enigma_flutter/response.dart';
import 'package:enigma_flutter/src/helper_widgets/retry_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

typedef ErrorBuilder<T extends Object> = Widget Function(BuildContext context, Future<Response<T>> Function() retry);
typedef FutureCallback<T extends Object> = Future<Response<T>> Function();
typedef FuturePageBuilder<T extends Object> = Widget Function(BuildContext context, T payload);
typedef OnResolve<T extends Object> = void Function(T resolved);

// ANCHOR FuturePage StatefulWidget.
class FuturePage<T extends Object> extends StatefulWidget {
  FuturePage({
    Key key,
    @required this.futureResponse,
    @required this.appBar,
    @required this.builder,
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
    this.loaderSize = 50.0,
  }) : super(key: key);

  final AppBar appBar;
  final FuturePageBuilder<T> builder;
  final Drawer drawer;
  final ErrorBuilder errorBuilder;
  final Color errorButtonTextColor;
  // Error widget parameters.
  final Color errorTextColor;

  final double errorTextSize;
  // General parameters.
  final FutureCallback<T> futureResponse;

  final bool isRefreshable;
  final WidgetBuilder loaderBuilder;
  // Loader widget parameters.
  final Color loaderColor;

  final double loaderSize;
  final OnResolve<T> onResolve;
  // Scaffold parameters.
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  FuturePageState<T> createState() => FuturePageState<T>();
}

// ANCHOR FuturePage State.
class FuturePageState<T> extends State<FuturePage<T>> {
  Future<Response<T>> _futureData;
  bool _isAppBarLoaderVisible = false;

  @override
  void initState() {
    super.initState();
    // Fetch the future data on initiation.
    _futureData = widget.futureResponse();
    // On resolve method.
    _futureData.then((Response<T> resolved) {
      if (resolved is Successful<T> && widget.onResolve != null) widget.onResolve(resolved.payload);
    });
  }

  Future<Response<T>> refresh() {
    setState(() {
      _isAppBarLoaderVisible = true;
      _futureData = widget.futureResponse();
    });
    // On resolve method.
    _futureData.then((Response<T> resolved) {
      if (resolved is Successful<T> && widget.onResolve != null) widget.onResolve(resolved.payload);
    }).whenComplete(() {
      setState(() => _isAppBarLoaderVisible = false);
    });
    return _futureData;
  }

  Future<void> _refresh() async {
    setState(() {
      _futureData = widget.futureResponse();
    });
    // On resolve method.
    await _futureData.then((Response<T> resolved) {
      if (resolved is Successful<T> && widget.onResolve != null) widget.onResolve(resolved.payload);
    });
  }

  @override
  Widget build(BuildContext context) {
    AppBar _appBar;

    // AppBar's progress loader.
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
    if (widget.appBar?.bottom == null) {
      _appBar = widget.appBar.copyWith(
        bottom: PreferredSize(
          child: _appBarLoader,
          preferredSize: Size(MediaQuery.of(context).size.width, 4.0),
        ),
      );
    } else {
      final PreferredSizeWidget _bottom = widget.appBar.bottom;
      final Size _bottomSize = _bottom.preferredSize;
      _appBar = widget.appBar.copyWith(
        bottom: PreferredSize(
          child: Column(
            children: <Widget>[
              _bottom,
              _appBarLoader,
            ],
          ),
          preferredSize: Size(
            MediaQuery.of(context).size.width,
            _bottomSize.height + 4.0,
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
            final response = snapshot.data;

            if (response is Successful<T>) {
              final child = widget.builder(context, response.payload);
              return widget.isRefreshable
                  ? RefreshIndicator(
                      child: child,
                      onRefresh: _refresh,
                    )
                  : child;
            } else if (response is Failed<T>) {
              return widget.errorBuilder != null
                  ? widget.errorBuilder(context, refresh)
                  : RetryWidget(
                      exception: response.exception,
                      onTap: (startLoading, stopLoading) {
                        startLoading();
                        refresh().whenComplete(() => stopLoading());
                      },
                    );
            }
          } else if (snapshot.hasError) {
            final exception = snapshot.error as Exception;
            return widget.errorBuilder != null
                ? widget.errorBuilder(context, refresh)
                : RetryWidget(
                    exception: exception,
                    onTap: (startLoading, stopLoading) {
                      startLoading();
                      refresh().whenComplete(() => stopLoading());
                    },
                  );
          }

          // By default show a progress bar.
          return widget.loaderBuilder != null
              ? widget.loaderBuilder(context)
              : SpinKitCircle(
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
    Key key,
    Widget leading,
    bool automaticallyImplyLeading,
    Widget title,
    List<Widget> actions,
    Widget flexibleSpace,
    PreferredSizeWidget bottom,
    double elevation,
    ShapeBorder shape,
    Color backgroundColor,
    Brightness brightness,
    IconThemeData iconTheme,
    IconThemeData actionsIconTheme,
    TextTheme textTheme,
    bool primary,
    bool centerTitle,
    bool excludeHeaderSemantics,
    double titleSpacing,
    double toolbarOpacity,
    double bottomOpacity,
  }) {
    return AppBar(
      key: key ?? this.key,
      leading: leading ?? this.leading,
      automaticallyImplyLeading: automaticallyImplyLeading ?? this.automaticallyImplyLeading,
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
      excludeHeaderSemantics: excludeHeaderSemantics ?? this.excludeHeaderSemantics,
      titleSpacing: titleSpacing ?? this.titleSpacing,
      toolbarOpacity: toolbarOpacity ?? this.toolbarOpacity,
      bottomOpacity: bottomOpacity ?? this.bottomOpacity,
    );
  }
}
