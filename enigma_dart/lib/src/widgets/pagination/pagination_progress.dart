import "package:flutter/material.dart";
import "package:enigma_annotation/enigma_annotation.dart";

import "package:enigma_dart/src/core/response.dart";
import "package:enigma_dart/src/widgets/buttons/retry_button.dart";

import "util.dart";

typedef PaginatedCallback<T, P extends Paginated<T>> = Future<Response<P>> Function(int nextPage);

typedef ItemBuilder<T> = Function(BuildContext context, T item, int idx);
typedef SeparatorBuilder = Widget Function(BuildContext context, int idx);
typedef ErrorBuilder<T, P extends Paginated<T>> = Widget Function(Err<P> error, void Function() refresh);

enum PaginationViewType { listView, gridView }

class PaginationView<T, P extends Paginated<T>> extends StatefulWidget {
  const PaginationView({
    Key key,
    @required this.itemBuilder,
    @required this.pageFetch,
    this.onEmpty = const PaginationEmpty(),
    this.onError,
    this.pageRefresh,
    this.pullToRefresh = true,
    this.gridDelegate = const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
    this.initialPage = 1,
    this.preloadedPaginated,
    this.initialLoader = const PaginationFullLoader(),
    this.bottomLoader = const PaginationBottomLoader(),
    this.paginationViewType = PaginationViewType.listView,
    this.shrinkWrap = false,
    this.reverse = false,
    this.scrollDirection = Axis.vertical,
    this.padding = const EdgeInsets.all(0.0),
    this.physics,
    this.separatorBuilder,
    this.scrollController,
  }) : super(key: key);

  final Widget bottomLoader;
  final Widget initialLoader;
  final Widget onEmpty;
  final EdgeInsets padding;
  final PaginatedCallback<T, P> pageFetch;
  final PaginatedCallback<T, P> pageRefresh;
  final ScrollPhysics physics;
  final int initialPage;
  final P preloadedPaginated;
  final bool pullToRefresh;
  final bool reverse;
  final Axis scrollDirection;
  final SliverGridDelegate gridDelegate;
  final PaginationViewType paginationViewType;
  final bool shrinkWrap;
  final ScrollController scrollController;

  @override
  PaginationViewState<T, P> createState() => PaginationViewState<T, P>();

  final ItemBuilder<T> itemBuilder;
  final ErrorBuilder<T, P> onError;
  final SeparatorBuilder separatorBuilder;
}

class PaginationViewState<T, P extends Paginated<T>> extends State<PaginationView<T, P>> {
  ScrollController _scrollController;

  List<T> _items;

  Response<P> _currentResponse;
  int _nextPage;
  bool _isBottomLoading = false;

  _scrollListener() {
    final sPosition = _scrollController.position;
    if (!_isBottomLoading && _scrollController.offset >= sPosition.maxScrollExtent - 25 && !sPosition.outOfRange) {
      final response = _currentResponse;

      if (response != null && response is Ok<P> && response.payload.haveNext) {
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

    if (response is Ok<P>) {
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

    if (widget.preloadedPaginated != null) {
      _currentResponse = Response.ok(widget.preloadedPaginated);
    }
    _nextPage = widget.initialPage;
    if (_currentResponse == null) {
      _fetchPage();
    }

    _items = widget.preloadedPaginated?.results ?? <T>[];
  }

  @override
  Widget build(BuildContext context) {
    if (_currentResponse == null) {
      return widget.initialLoader;
    }

    if (_items.isEmpty) {
      return widget.onEmpty;
    }

    return _currentResponse.fold(
      (payload) {
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
      (err) => widget.onError != null
          ? widget.onError(err, refresh)
          : RetryWidget(
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
    return CustomScrollView(
      controller: _scrollController,
      physics: widget.physics,
      reverse: widget.reverse,
      scrollDirection: widget.scrollDirection,
      shrinkWrap: widget.shrinkWrap,
      slivers: <Widget>[
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

    if (response is Ok<P>) {
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
