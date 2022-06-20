import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:m3yen/constants.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewer  extends StatelessWidget {

  final String? imageUrl ;
  PhotoViewer({ this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Hero(
        tag: imageUrl!,
        child: Image.network( imageUrl!,
          loadingBuilder: (context, child, progress) {
            return progress == null ?
            PhotoView(
              imageProvider: CachedNetworkImageProvider(imageUrl!),
            ):
            Container(
              child: Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white))),
            );
          },
        ),
      )
    );
  }
}

