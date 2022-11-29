import 'package:flutter/material.dart';

import 'open_button.dart';

class OpenWidget extends StatelessWidget {
  final bool enabled;
  final Function open, newplist;

  const OpenWidget({Key? key, required this.enabled, required this.open, required this.newplist}) : super(key: key);

  static const _gradient = LinearGradient(colors: [
    Color(0xffCD5A75),
    Color(0xffD169C8),
    Color(0xffBA6BFE)
  ]);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white38, width: 1),
      ),
      width: 350,
      height: 114 + 1,
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 22),
      child: Column(
        children: [
          ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) => _gradient.createShader(
              Rect.fromLTWH(0, 0, bounds.width, bounds.height),
            ),
            child: const Text(
              "AnyPlist",
              style: TextStyle(
                fontSize: 21,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OpenButton(
                enabled: enabled,
                text: 'Open',
                onTap: open,
                gradient: const LinearGradient(
                  colors: [Color(0xff28CBA4), Color(0xff43E37E)],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  stops: [0.1, 1],
                ),
              ),
              const SizedBox(width: 10),
              OpenButton(
                enabled: enabled,
                text: 'New',
                onTap: newplist,
                gradient: const LinearGradient(
                  colors: [Color(0xff5E80E9), Color(0xff2853F3)],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  stops: [0.1, 1],
                ),
              ),
            ],
          ),
          // ClipRRect(
          //   borderRadius: BorderRadius.circular(10),
          //   child: Container(
          //     height: 30,
          //     width: 100,
          //     decoration: const BoxDecoration(
          //       gradient: LinearGradient(
          //         colors: [Color(0xff28CBA4), Color(0xff43E37E)],
          //         begin: Alignment.bottomLeft,
          //         end: Alignment.topRight,
          //         stops: [0.1, 1],
          //       ),
          //     ),
          //     foregroundDecoration: enabled
          //         ? null
          //         : BoxDecoration(
          //           color: Colors.black.withOpacity(0.4),
          //           backgroundBlendMode: BlendMode.saturation,
          //         ),
          //     child: Material(
          //       color: Colors.transparent,
          //       child: InkWell(
          //         onTap: enabled ? () => open() : null,
          //         splashColor: Colors.lightBlue,
          //         child: const Center(
          //           child: Text(
          //             'Open',
          //             style: TextStyle(
          //               color: Color(0xff000000),
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
