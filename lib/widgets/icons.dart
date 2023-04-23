import '../exports.dart';

class CircleIconsWidget extends StatelessWidget {
  final String whatsappNumber = '+34622525237';
  final String phoneNumber = 'tel:+34622525237';
  final String instagramProfile = 'https://www.instagram.com/david_dp_perez/';

  const CircleIconsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Círculo de WhatsApp
          InkResponse(
            // ignore: deprecated_member_use
            onTap: () => launch('https://wa.me/$whatsappNumber'),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
              child: Image.asset(
                'lib/images/whatssap.png',
                width: 25,
                height: 25,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 50),
          // Círculo de teléfono
          InkResponse(
            // ignore: deprecated_member_use
            onTap: () => launch(phoneNumber),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
              child: const Icon(
                Icons.phone,
                size: 25,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 50),
          // Círculo de Instagram
          InkResponse(
            // ignore: deprecated_member_use
            onTap: () => launch(instagramProfile),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
              child: Image.asset(
                'lib/images/instagram.png',
                width: 25,
                height: 25,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
