import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  const DrawerTile({Key? key, this.icon, this.text, this.pageControler, this.page}) : super(key: key);

  final IconData? icon;
  final String? text;
  final PageController? pageControler;
  final int? page;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          Navigator.of(context).pop();
          pageControler?.jumpToPage(page!);
        },
        child: SizedBox(
          height: 60.0,
          child: Row(
            children: [
              Icon(icon,
                size: 32.0,
                color: pageControler?.page?.round() == page ?
                  Theme.of(context).primaryColor : Colors.grey[700],
              ),
              const SizedBox(width: 32.0,),
              Text(text!,
                style: TextStyle(
                    fontSize: 16.0,
                    color: pageControler?.page?.round() == page ?
                      Theme.of(context).primaryColor : Colors.grey[700]
                  ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
