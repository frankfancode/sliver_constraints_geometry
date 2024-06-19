import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum GeometryPaintOriginType { asDefault, absorb, custom }

GeometryPaintOriginType geometryPaintOriginType =
    GeometryPaintOriginType.asDefault;

class _MyHomePageState extends State<MyHomePage> {
  bool appbarPinned = true;
  bool appbarFloat = true;
  double toolBarHeight = 56;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Row(
        children: [
          Container(
            width: 375,
            child: NotificationListener(
              onNotification: (notification) {
                setState(() {});
                return false;
              },
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: appbarPinned,
                    floating: appbarFloat,
                    toolbarHeight: toolBarHeight,
                    title: LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        return Text('SliverAppBar height $toolBarHeight');
                      },
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Container(
                      height: 100,
                      color: Colors.blue.shade100,
                      child: const Text('SliverToBoxAdapter, Height 100.0'),
                    ),
                  ),
                  MySliverToBoxAdapter(
                    child: Builder(builder: (context) {
                      return Container(
                        color: Colors.amber,
                        height: 100,
                        child: const Text('MySliverToBoxAdapter height 100.0'),
                      );
                    }),
                  ),
                  SliverLayoutBuilder(
                    builder: (context, constraints) {
                      ConstraintsData.sliverPinnedConstraints = constraints;
                      listenedPinnedsliverGeometry =
                          findRenderSliverPersistentHeaders(context);

                      return SliverPersistentHeader(
                        pinned: true,
                        delegate: MySliverPersistentHeaderDelegate(
                            child: Container(
                                color: Colors.pinkAccent.withOpacity(0.8),
                                child: Text(
                                    'pinned header maxHeight 100, minHeight 30')),
                            maxHeight: 100,
                            minHeight: 30),
                      );
                    },
                  ),
                  SliverList.builder(
                    itemBuilder: (context, index) {
                      return Text('data $index');
                    },
                  )
                ],
              ),
            ),
          ),
          const VerticalDivider(),
          SizedBox(
            width: 375,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  'viewport width ${MediaQuery.of(context).size.width} height ${MediaQuery.of(context).size.height}',
                ),
                const Text(
                  'SliverAppBar',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Row(children: [
                  const Text('pinned'),
                  Checkbox(
                    value: appbarPinned,
                    onChanged: (value) {
                      setState(() {
                        appbarPinned = value!;
                      });
                    },
                  ),
                  const Text('float'),
                  Checkbox(
                    value: appbarFloat,
                    onChanged: (value) {
                      setState(() {
                        appbarFloat = value!;
                      });
                    },
                  )
                ]),
                const Text(
                  'SliverToBoxAdapter',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const Text(
                  'SliverConstarint',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                _buildSliverConstrainsWidget(
                    ConstraintsData.sliverBoxConstraints),
                const Text(
                  'Geometry',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                _buildGeometry(listenedsliverGeometry),
              ],
            ),
          ),
          const VerticalDivider(),
          SizedBox(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SliverPinned',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const Text(
                  'SliverConstarint',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                _buildSliverConstrainsWidget(
                    ConstraintsData.sliverPinnedConstraints),
                const Text(
                  'Geometry',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                _buildGeometry(listenedPinnedsliverGeometry),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSliverConstrainsWidget(SliverConstraints? sliverConstraints) {
    return Wrap(
      direction: Axis.vertical,
      spacing: 2,
      children: [
        Text('axisDirection:${sliverConstraints?.axisDirection}'),
        Text('crossAxisDirection:${sliverConstraints?.crossAxisDirection}'),
        Text('growthDirection:${sliverConstraints?.growthDirection}'),
        Text(
            'viewportMainAxisExtent:${sliverConstraints?.viewportMainAxisExtent}'),
        Text('crossAxisExtent:${sliverConstraints?.crossAxisExtent}'),
        Text(
            'precedingScrollExtent:${sliverConstraints?.precedingScrollExtent}'),
        Text('userScrollDirection:${sliverConstraints?.userScrollDirection}'),
        Text('remainingPaintExtent:${sliverConstraints?.remainingPaintExtent}'),
        Text('remainingCacheExtent:${sliverConstraints?.remainingCacheExtent}'),
        Text('overlap:${sliverConstraints?.overlap}'),
        Text('cacheOrigin:${sliverConstraints?.cacheOrigin}'),
        Text('scrollOffset:${sliverConstraints?.scrollOffset}'),
      ],
    );
  }

  Widget _buildGeometry(SliverGeometry? geometry) {
    return Wrap(
      direction: Axis.vertical,
      spacing: 2,
      children: [
        Text('scrollExtent:${geometry?.scrollExtent}'),
        Text('paintExtent: ${geometry?.paintExtent}'),
        Text('paintOrigin: ${geometry?.paintOrigin}'),
        Text('layoutExtent: ${geometry?.layoutExtent}'),
        Text('maxPaintExtent: ${geometry?.maxPaintExtent}'),
        Text(
            'maxScrollObstructionExtent: ${geometry?.maxScrollObstructionExtent}'),
        Text('crossAxisExtent: ${geometry?.crossAxisExtent}'),
        Text('hitTestExtent: ${geometry?.hitTestExtent}'),
        Text('visible: ${geometry?.visible}'),
        Text('hasVisualOverflow: ${geometry?.hasVisualOverflow}'),
        Text('cacheExtent: ${geometry?.cacheExtent}'),
      ],
    );
  }

  SliverGeometry? findRenderSliverPersistentHeaders(BuildContext context) {
    SliverGeometry? geometry;
    SliverGeometry? visitor(RenderObject child) {
      if (child is RenderSliverPersistentHeader) {
        geometry = child.geometry;
      }
      child.visitChildren(visitor);
      return null;
    }

    final rootRenderObject = context.findRenderObject();
    if (rootRenderObject != null) {
      rootRenderObject.visitChildren(visitor);
    }
    return geometry;
  }
}

/// copy from [[SliverToBoxAdapter]]
class MySliverToBoxAdapter extends SingleChildRenderObjectWidget {
  /// Creates a sliver that contains a single box widget.
  const MySliverToBoxAdapter({
    super.key,
    super.child,
  });

  @override
  MyRenderSliverToBoxAdapter createRenderObject(BuildContext context) =>
      MyRenderSliverToBoxAdapter();
}

/// copy from [RenderSliverToBoxAdapter]
class MyRenderSliverToBoxAdapter extends RenderSliverSingleBoxAdapter {
  /// Creates a [RenderSliver] that wraps a [RenderBox].
  MyRenderSliverToBoxAdapter({
    super.child,
  });

  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }

    final SliverConstraints constraints = this.constraints;
    ConstraintsData.sliverBoxConstraints = this.constraints;
    child!.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    final double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child!.size.width;
      case Axis.vertical:
        childExtent = child!.size.height;
    }
    final double paintedChildSize =
        calculatePaintOffset(constraints, from: 0.0, to: childExtent);
    final double cacheExtent =
        calculateCacheOffset(constraints, from: 0.0, to: childExtent);

    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0.0);
    geometry = SliverGeometry(
      scrollExtent: childExtent,
      paintExtent: paintedChildSize,
      cacheExtent: cacheExtent,
      maxPaintExtent: childExtent,
      hitTestExtent: paintedChildSize,
      hasVisualOverflow: childExtent > constraints.remainingPaintExtent ||
          constraints.scrollOffset > 0.0,
    );
    setChildParentData(child!, constraints, geometry!);
    listenedsliverGeometry = geometry;
  }
}

class ConstaintsNotification extends Notification {
  ConstaintsNotification(this.constraints);
  final SliverConstraints constraints;
}

class ConstraintsData {
  static SliverConstraints? sliverBoxConstraints;
  static SliverConstraints? sliverPinnedConstraints;
}

SliverGeometry? listenedsliverGeometry;
SliverGeometry? listenedPinnedsliverGeometry;

class MySliverPersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  MySliverPersistentHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(MySliverPersistentHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
