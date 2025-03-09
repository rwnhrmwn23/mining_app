import 'package:flutter/material.dart';

import '../../../../core/utils/utils.dart';

class PopupMessageWithSlider extends StatefulWidget {

  final VoidCallback onSlideRight;
  final String name;
  final String message;
  final String date;

  const PopupMessageWithSlider({
    Key? key,
    required this.onSlideRight, required this.name, required this.message, required this.date,
  }) : super(key: key);

  @override
  _PopupWithSliderState createState() => _PopupWithSliderState();
}

class _PopupWithSliderState extends State<PopupMessageWithSlider> {
  bool showPopup = true;
  double sliderPosition = 0.0;
  double maxSlide = 0.0;
  bool isDragging = false;
  final GlobalKey _sliderContainerKey = GlobalKey();
  double sliderWidth = 100.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox =
          _sliderContainerKey.currentContext?.findRenderObject() as RenderBox;
      final containerWidth = renderBox.size.width;
      setState(() {
        maxSlide = (containerWidth - sliderWidth) / 2;
      });
    });
  }

  void hidePopup() {
    setState(() {
      showPopup = false;
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  void updateSliderPosition(double delta) {
    setState(() {
      sliderPosition += delta;
      sliderPosition = sliderPosition.clamp(-maxSlide, maxSlide);
    });
  }

  void handleDragEnd() {
    if (sliderPosition >= maxSlide) {
      widget.onSlideRight();
      hidePopup();
    } else if (sliderPosition <= -maxSlide) {
      hidePopup();
    } else {
      setState(() {
        sliderPosition = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 80, top: 50, left: 50, right: 50),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              color: Color(0xFF2E2E35),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset('images/ic_message.png',
                              width: 30, height: 30),
                          const SizedBox(width: 8),
                          Text(
                            "Message",
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFFC99D00),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.warning, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                widget.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                              widget.message,
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          SizedBox(height: 8),
                          Text(
                            formatDateTime(widget.date),
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 20,
                  child: GestureDetector(
                    onHorizontalDragStart: (details) {
                      setState(() {
                        isDragging = true;
                      });
                    },
                    onHorizontalDragUpdate: (details) {
                      updateSliderPosition(details.primaryDelta!);
                    },
                    onHorizontalDragEnd: (details) {
                      setState(() {
                        isDragging = false;
                      });
                      handleDragEnd();
                    },
                    child: Container(
                      key: _sliderContainerKey,
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Color(0xFFA7A7A7),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "Balas Nanti",
                                style: TextStyle(
                                    color: Color(0xFF626262), fontSize: 25),
                              ),
                              Text(
                                "Mengerti",
                                style: TextStyle(
                                    color: Color(0xFF626262), fontSize: 25),
                              ),
                            ],
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 200),
                            transform:
                            Matrix4.translationValues(sliderPosition, 0, 0),
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: Image.asset(
                                'images/ic_slider.png',
                                width: sliderWidth,
                                height: 60,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
