import 'package:flutter/material.dart';
import 'package:mdn/utils/add_zero.dart';

class HomeScreenCard extends StatelessWidget {
  const HomeScreenCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageurl,
    required this.width,
    required this.editDate,
    this.onTap,
  });

  final String title, subtitle, imageurl;
  final int width;
  final DateTime editDate;
  final VoidCallback? onTap;

  Size getSize() {
    return Size(width.toDouble(), 205 * width / 286);
  }

  @override
  Widget build(BuildContext context) {
    var size_ = getSize();
    return SizedBox(
      width: size_.width,
      height: size_.height,
      child: Material(
        color: Colors.white.withOpacity(0.1),
        borderRadius: const BorderRadius.all(Radius.circular(3)),
        child: InkWell(
          onTap: onTap ?? () {},
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 70,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      alignment: Alignment.topCenter,
                      image: NetworkImage(imageurl),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(3),
                      topRight: Radius.circular(3),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 30,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: size_.height >= 199 ? 18 : 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      size_.height >= 180
                          ? Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      fit: FlexFit.tight,
                                      child: Text(
                                        subtitle,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize:
                                              size_.height >= 199 ? 14 : 12,
                                          color: Colors.white.withOpacity(.6),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      "${editDate.day}.${addZero(editDate.month)}.${editDate.year}",
                                      style: TextStyle(
                                        fontSize: size_.height >= 199 ? 14 : 12,
                                        color: Colors.white.withOpacity(.4),
                                      ),
                                    ),
                                  ]),
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
