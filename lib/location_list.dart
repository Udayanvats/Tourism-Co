import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttercrashcourse/LocationDetail.dart';
import 'package:fluttercrashcourse/components/default_appbar.dart';
import 'package:fluttercrashcourse/components/location_tile.dart';
import 'package:fluttercrashcourse/models/locationmodel.dart';
import 'package:fluttercrashcourse/styles.dart';

const ItemHeight = 245.0;

class LocationList extends StatefulWidget {
  @override
  createState() => _LocationListState();
}

class _LocationListState extends State<LocationList> {
  List<Location> locations = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: DefaultAppBar(),
       
        body: RefreshIndicator(
            onRefresh: loadData,
            child: Column(children: [
              renderProgressBar(context),
              Expanded(child: renderListView(context))
            ])));
  }

  Future<void> loadData() async {
    if (mounted) {
      setState(() => loading = true);
      Timer(Duration(milliseconds: 500), () async {
        final locations = await Location.fetchAll();
        setState(() {
          this.locations = locations;
          this.loading = false;
        });
      });
    }
  }

  Widget renderProgressBar(BuildContext context) {
    return (this.loading
        ? LinearProgressIndicator(
            value: null,
            backgroundColor: Colors.white,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey))
        : Container());
  }

  Widget renderListView(BuildContext context) {
    return ListView.builder(
      itemCount: this.locations.length,
      itemBuilder: _listViewItemBuilder,
    );
  }

  Widget _listViewItemBuilder(BuildContext context, int index) {
    final location = this.locations[index];
    return GestureDetector(
      onTap: () => _navigateToLocationDetail(context, location.id),
      child: Container(
        height: ItemHeight,
        child: Stack(
          children: [
            _tileImage(
                location.url, MediaQuery.of(context).size.width, ItemHeight),
            tileFooter(location),
          ],
        ),
      ),
    );
  }

  void _navigateToLocationDetail(BuildContext context, int locationID) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => LocationDetail(locationID)));
  }

  Widget _tileImage(String url, double width, double height) {
    if (url.isEmpty) {
      return Container();
    }

    try {
      return Container(
        constraints: BoxConstraints.expand(),
        child: Image.network(url, fit: BoxFit.cover),
      );
    } catch (e) {
      print("could not load image $url");
      return Container();
    }
  }

  Widget tileFooter(Location location) {
    final info = LocationTile(location: location, darkTheme: true);
    final overlay = Container(

        // ignore: prefer_const_constructors
        padding: EdgeInsets.symmetric(
            vertical: 5.0, horizontal: Styles.horizontalPaddingDefault),
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
        child: info);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [overlay],
    );
  }

  Widget _itemTitle(Location location) {
    return Text('${location.name}', style: Styles.textDefault);
  }
}
