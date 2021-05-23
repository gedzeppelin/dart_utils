import "package:enigma_core/enigma_core.dart";
import "package:flutter/material.dart";
import "package:enigma_annotation/enigma_annotation.dart";

import "package:enigma_dart/src/widgets/buttons/retry_button.dart";

import "util.dart";

typedef PaginatorCallback<T> = Future<Response<Paginator<T>>> Function(
    int page);

typedef ItemBuilder<T> = Function(BuildContext context, T item, int idx);
typedef SeparatorBuilder = Widget Function(BuildContext context, int idx);
typedef ErrorBuilder<T> = Widget Function(
    Err<Paginator<T>> error, void Function() refresh);

enum PaginationViewType { listView, gridView }

class PaginationView<T> extends StatefulWidget {
  const PaginationView({
    Key? key,
    required this.itemBuilder,
    required this.pageFetch,
    this.sliverBefore,
    this.onEmpty = const PaginationEmpty(),
    this.onError,
    this.pageRefresh,
    this.pullToRefresh = true,
    this.gridDelegate =
        const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    this.initialPage,
    this.initialPayload,
    this.initialLoader = const PaginationFullLoader(),
    this.bottomLoader = const PaginationBottomLoader(),
    this.paginationViewType = PaginationViewType.gridView,
    this.shrinkWrap = false,
    this.reverse = false,
    this.scrollDirection = Axis.vertical,
    this.padding = const EdgeInsets.all(0.0),
    this.physics = const AlwaysScrollableScrollPhysics(),
    this.separatorBuilder,
    this.scrollController,
  }) : super(key: key);

  final Widget? sliverBefore;
  final Widget bottomLoader;
  final Widget initialLoader;
  final Widget onEmpty;
  final EdgeInsets padding;
  final PaginatorCallback<T> pageFetch;
  final PaginatorCallback<T>? pageRefresh;
  final ScrollPhysics? physics;
  final int? initialPage;
  final Paginator<T>? initialPayload;
  final bool pullToRefresh;
  final bool reverse;
  final Axis scrollDirection;
  final SliverGridDelegate gridDelegate;
  final PaginationViewType paginationViewType;
  final bool shrinkWrap;
  final ScrollController? scrollController;

  @override
  PaginationViewState<T> createState() => PaginationViewState<T>();

  final ItemBuilder<T> itemBuilder;
  final ErrorBuilder<T>? onError;
  final SeparatorBuilder? separatorBuilder;
}

class PaginationViewState<T> extends State<PaginationView<T>> {
  late ScrollController _scrollController;

  List<T> _items = [];
  int _nextPage = 1;

  Response<Paginator<T>>? _currentResponse;

  bool _bottomLoading = false;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    _scrollController.addListener(_scrollListener);

    if (widget.initialPage != null) {
      _nextPage = widget.initialPage!;
    }

    if (widget.initialPayload != null) {
      _currentResponse = Ok(payload: widget.initialPayload!);
      _items = widget.initialPayload!.results;
      _initialized = true;
    } else {
      _fetchPage();
    }
  }

  _scrollListener() {
    final sPosition = _scrollController.position;

    if (!_bottomLoading &&
        _scrollController.offset >= sPosition.maxScrollExtent - 25 &&
        !sPosition.outOfRange) {
      final response = _currentResponse;

      if (response != null &&
          response is Ok<Paginator<T>> &&
          response.payload.haveNext) {
        setState(() {
          _bottomLoading = true;
        });
        _fetchPage();
      }
    }
  }

  void _fetchPage([int? nextPage, bool reload = false]) async {
    final page = nextPage ?? _nextPage;
    final response = await widget.pageFetch(page);

    setState(() {
      _currentResponse = response;
    });

    //await Future.delayed(Duration(seconds: 2));

    if (response is Ok<Paginator<T>>) {
      _initialized = true;
      _nextPage = page + 1;

      setState(() {
        _items = reload
            ? response.payload.results
            : _items + response.payload.results;
        _bottomLoading = false;
      });

      if (reload && _scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _current = _currentResponse;

    if (_current == null) {
      return widget.initialLoader;
    }

    if (widget.sliverBefore == null && _items.isEmpty) {
      return widget.onEmpty;
    }

    return _current.map(
      ifOk: (payload) {
        if (widget.paginationViewType == PaginationViewType.gridView) {
          if (widget.pullToRefresh) {
            return RefreshIndicator(
              onRefresh: refresh,
              child: _makeGridView(),
            );
          }
          return _makeGridView();
        }

        if (widget.pullToRefresh) {
          return RefreshIndicator(
            onRefresh: refresh,
            child: _makeListView(),
          );
        }
        return _makeListView();
      },
      ifErr: (err) =>
          widget.onError?.call(err, refresh) ??
          RetryWidget(
            onTap: (startLoading, stopLoading) async {
              startLoading();
              await refresh();
              stopLoading();
            },
          ),
    );
  }

  Widget _makeListView() {
    return ListView.separated(
      controller: _scrollController,
      padding: widget.padding,
      physics: widget.physics,
      reverse: widget.reverse,
      scrollDirection: widget.scrollDirection,
      shrinkWrap: widget.shrinkWrap,
      separatorBuilder: widget.separatorBuilder ?? (c, i) => SizedBox.shrink(),
      itemCount: _bottomLoading ? _items.length + 1 : _items.length,
      itemBuilder: (context, idx) {
        if (idx >= _items.length) {
          return const PaginationBottomLoader();
        }

        return widget.itemBuilder(context, _items[idx], idx);
      },
    );
  }

  Widget _makeGridView() {
    final sliverBefore = widget.sliverBefore;
    return CustomScrollView(
      controller: _scrollController,
      physics: widget.physics,
      reverse: widget.reverse,
      scrollDirection: widget.scrollDirection,
      shrinkWrap: widget.shrinkWrap,
      slivers: [
        if (sliverBefore != null) sliverBefore,
        SliverPadding(
          padding: widget.padding,
          sliver: SliverGrid(
            gridDelegate: widget.gridDelegate,
            delegate: SliverChildBuilderDelegate(
              (context, idx) => widget.itemBuilder(context, _items[idx], idx),
              childCount: _items.length,
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Visibility(
              child: widget.bottomLoader,
              visible: _bottomLoading,
            )
          ]),
        ),
      ],
    );
  }

  Future<void> refresh() async {
    if (!_initialized) {
      setState(() {
        _currentResponse = null;
      });
    }

    _fetchPage(1, true);
  }
}
