import 'package:flutter/material.dart';
import 'package:kangaroom_mobile/models/etkinlikOnay/get_etkinlik_onay.dart';

class EtkinlikOnayCardList extends StatelessWidget {
  final List<GetEtkinlikOnay> etkinlikler;
  final bool isWeb;

  const EtkinlikOnayCardList({
    super.key,
    required this.etkinlikler,
    this.isWeb = false,
  });

  @override
  Widget build(BuildContext context) {
    if (etkinlikler.isEmpty) {
      return const Center(child: Text("Eşleşen kayıt bulunamadı"));
    }

    return ListView.builder(
      itemCount: etkinlikler.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final item = etkinlikler[index];
        return _EtkinlikOnayCard(
          item: item,
          index: index,
          isWeb: isWeb,
        );
      },
    );
  }
}

class _EtkinlikOnayCard extends StatefulWidget {
  final GetEtkinlikOnay item;
  final int index;
  final bool isWeb;

  const _EtkinlikOnayCard({
    required this.item,
    required this.index,
    required this.isWeb,
  });

  @override
  State<_EtkinlikOnayCard> createState() => _EtkinlikOnayCardState();
}

class _EtkinlikOnayCardState extends State<_EtkinlikOnayCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(vertical: 8),
      transform: Matrix4.identity()..scale(_isHovered && widget.isWeb ? 1.03 : 1.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: widget.isWeb ? 6 : 4,
          shadowColor: Colors.grey.withOpacity(0.3),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: widget.isWeb ? 20 : 16,
              vertical: widget.isWeb ? 12 : 8,
            ),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF64B5F6), Color(0xFF1976D2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                item.durum,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            title: Text(
              item.etkinlikAd,
              style: TextStyle(
                fontSize: widget.isWeb ? 16 : 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Öğrenci: ${item.ogrenciAd}",
                  style: TextStyle(
                    fontSize: widget.isWeb ? 14 : 12,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  "Tarih: ${item.tarih}",
                  style: TextStyle(
                    fontSize: widget.isWeb ? 14 : 12,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            trailing: Text(
              "#${widget.index + 1}",
              style: TextStyle(
                fontSize: widget.isWeb ? 14 : 12,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
