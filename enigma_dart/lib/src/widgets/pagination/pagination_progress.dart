import "package:enigma_core/enigma_core.dart";
import "package:flutter/material.dart";
import "package:enigma_annotation/enigma_annotation.dart";

import "package:enigma_dart/src/widgets/buttons/retry_button.dart";

import "util.dart";

typedef PaginatedCallback<T> = Future<Response<Paginator<T>>> Function(
    int nextPage);

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
    this.initialPage = 1,
    this.preloadedPaginated,
    this.initialLoader = const PaginationFullLoader(),
    this.bottomLoader = const PaginationBottomLoader(),
    this.paginationViewType = PaginationViewType.gridView,
    this.shrinkWrap = false,
    this.reverse = false,
    this.scrollDirection = Axis.vertical,
    this.padding = const EdgeInsets.all(0.0),
    this.physics,
    this.separatorBuilder,
    this.scrollController,
  }) : super(key: key);

  final Widget? sliverBefore;
  final Widget bottomLoader;
  final Widget initialLoader;
  final Widget onEmpty;
  final EdgeInsets padding;
  final PaginatedCallback<T> pageFetch;
  final PaginatedCallback<T>? pageRefresh;
  final ScrollPhysics? physics;
  final int initialPage;
  final Paginator<T>? preloadedPaginated;
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

  late List<T> _items;

  Response<Paginator<T>>? _currentResponse;
  late int _nextPage;
  bool _isBottomLoading = false;

  _scrollListener() {
    final sPosition = _scrollController.position;

    if (!_isBottomLoading &&
        _scrollController.offset >= sPosition.maxScrollExtent - 25 &&
        !sPosition.outOfRange) {
      final response = _currentResponse;

      if (response != null &&
          response is Ok<Paginator<T>> &&
          response.payload.haveNext) {
        setState(() {
          _isBottomLoading = true;
        });
        _fetchPage();
      }
    }
  }

  void _fetchPage() async {
    final response = await widget.pageFetch(_nextPage);

    setState(() {
      _currentResponse = response;
    });

    //await Future.delayed(Duration(seconds: 2));

    if (response is Ok<Paginator<T>>) {
      _nextPage += 1;
      setState(() {
        _items = _items + response.payload.results;
        _isBottomLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
    _scrollController.addListener(_scrollListener);

    final _currentPayload = widget.preloadedPaginated;
    if (_currentPayload != null) {
      _currentResponse = Ok(payload: _currentPayload);
    }
    _nextPage = widget.initialPage;
    if (_currentResponse == null) {
      _fetchPage();
    }

    _items = widget.preloadedPaginated?.results ?? <T>[];
  }

  @override
  Widget build(BuildContext context) {
    final _current = _currentResponse;

    if (_current == null) {
      return widget.initialLoader;
    }

    if (_items.isEmpty) {
      return widget.onEmpty;
    }

    return _current.map(
      ifOk: (payload) {
        if (widget.paginationViewType == PaginationViewType.gridView) {
          if (widget.pullToRefresh) {
            return RefreshIndicator(
              onRefresh: () async => refresh(),
              child: _makeGridView(),
            );
          }
          return _makeGridView();
        }

        if (widget.pullToRefresh) {
          return RefreshIndicator(
            onRefresh: () async => refresh(),
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
      itemCount: _isBottomLoading ? _items.length + 1 : _items.length,
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
              visible: _isBottomLoading,
            )
          ]),
        ),
      ],
    );
  }

  Future<void> refresh() async {
    setState(() {
      _currentResponse = null;
    });

    final response = await widget.pageFetch(1);
    setState(() {
      _currentResponse = response;
    });

    if (response is Ok<Paginator<T>>) {
      _nextPage = 2;

      setState(() {
        _items = response.payload.results;
      });
    }

    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }
}
