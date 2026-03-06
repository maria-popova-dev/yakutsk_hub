import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../cubits/tickets_cubit.dart';
import '../models/ticket_model.dart';

class TicketsPage extends StatefulWidget {
  const TicketsPage({super.key});

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  bool showOnlySubsidized = false;

  // Виджет шкалы прогресса (внутри стейта для доступа к context)
  Widget _buildSubsidiesProgress(int used) {
    double progress = (used / 4).clamp(0.0, 1.0);
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2128),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text("🦊", style: TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text("Твой лимит субсидий",
                      style: GoogleFonts.inter(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
                ],
              ),
              Text("$used из 4", style: GoogleFonts.inter(color: const Color(0xFF34C759), fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(height: 8, width: double.infinity, decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(10))),
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                height: 8,
                width: (MediaQuery.of(context).size.width - 64) * progress,
                decoration: BoxDecoration(
                  color: const Color(0xFF34C759),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [BoxShadow(color: const Color(0xFF34C759).withOpacity(0.3), blurRadius: 10)],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        title: Text('БИЛЕТЫ', style: GoogleFonts.inter(fontWeight: FontWeight.w900)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              showOnlySubsidized ? Icons.filter_alt : Icons.filter_alt_off,
              color: showOnlySubsidized ? const Color(0xFF34C759) : Colors.white,
            ),
            onPressed: () => setState(() => showOnlySubsidized = !showOnlySubsidized),
          ),
        ],
      ),
      body: BlocBuilder<TicketsCubit, TicketsState>(
        builder: (context, state) {
          if (state.isLoading) return const Center(child: CircularProgressIndicator(color: Color(0xFF34C759)));

          final ticketsToShow = showOnlySubsidized
              ? state.tickets.where((t) => t.isSubsidized).toList()
              : state.tickets;

          return Column(
            children: [
              _buildSubsidiesProgress(state.usedSubsidies),
              Expanded(
                child: ticketsToShow.isEmpty
                    ? const Center(child: Text("Пусто...", style: TextStyle(color: Colors.white24)))
                    : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: ticketsToShow.length,
                  itemBuilder: (context, index) => _ticketItem(context, ticketsToShow[index]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Widget _ticketItem(BuildContext context, Ticket ticket, {bool isInsidePrinter = false}) {
  final String to = ticket.destination;
  final String price = '${ticket.price.toInt()} ₽';
  final bool isSub = ticket.isSubsidized;
  const months = ['января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'];
  final String dateText = "${ticket.date.day} ${months[ticket.date.month - 1]} ${ticket.date.year}";

  return GestureDetector(
    onTap: isInsidePrinter ? null : () {
      // 1. Узнаем, сколько субсидий уже потрачено
      final int currentUsed = context.read<TicketsCubit>().state.usedSubsidies;
      if (isSub) {
        // 2. Если это субсидия, проверяем лимит
        if (currentUsed < 4) {
          _showFoxReminder(context);
          context.read<TicketsCubit>().buyTicket(ticket);
          _showTicketPrinter(context, ticket);
        } else {
          // Если 4 и больше — только вызываем логику (для ошибки), без принтера
          context.read<TicketsCubit>().buyTicket(ticket);
        }
      } else {
        // 3. Обычный билет — покупаем и печатаем всегда
        context.read<TicketsCubit>().buyTicket(ticket);
        _showTicketPrinter(context, ticket);
      }
    }, // Не забудь эту запятую и скобку!

    child: Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: isInsidePrinter ? 0 : 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1C2128),
            borderRadius: BorderRadius.circular(22),
            border: isSub ? Border.all(color: const Color(0xFF34C759).withOpacity(0.3)) : null,
            boxShadow: isInsidePrinter ? [const BoxShadow(color: Colors.black87, blurRadius: 20)] : [],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  if (isSub) Container(width: 4, height: 35, margin: const EdgeInsets.only(right: 12), decoration: BoxDecoration(color: const Color(0xFF34C759), borderRadius: BorderRadius.circular(2))),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(to, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                    Text(dateText, style: const TextStyle(color: Colors.white38, fontSize: 13)),
                  ])),
                  const Icon(Icons.flight_takeoff, color: Colors.white10, size: 24),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(children: List.generate(25, (index) => Expanded(child: Container(margin: const EdgeInsets.symmetric(horizontal: 2), height: 1, color: Colors.white10)))),
              ),

              // НИЖНЯЯ ЧАСТЬ: QR и Цена + Кнопка
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.qr_code_2, color: Colors.white24, size: 40),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        price,
                        style: TextStyle(
                          color: isSub ? const Color(0xFF34C759) : Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Та самая Кнопка-индикатор
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSub ? const Color(0xFF34C759).withOpacity(0.1) : Colors.white10,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSub ? const Color(0xFF34C759).withOpacity(0.5) : Colors.white24,
                          ),
                        ),
                        child: Text(
                          isSub ? 'ЛЬГОТА' : 'КУПИТЬ',
                          style: TextStyle(
                            color: isSub ? const Color(0xFF34C759) : Colors.white70,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(left: -10, top: 78, child: CircleAvatar(radius: 10, backgroundColor: isInsidePrinter ? Colors.black : const Color(0xFF0D1117))),
        Positioned(right: -10, top: 78, child: CircleAvatar(radius: 10, backgroundColor: isInsidePrinter ? Colors.black : const Color(0xFF0D1117))),
      ],
    ),
  );
}


void _showFoxReminder(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: const Color(0xFF1C2128),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text("🦊 Лисенок", style: TextStyle(color: Colors.white)),
      content: const Text("Проверьте прописку в Якутии для этого тарифа!", style: TextStyle(color: Colors.white70)),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text("ПОНЯТНО", style: TextStyle(color: Color(0xFF34C759))))],
    ),
  );
}

void _showTicketPrinter(BuildContext context, Ticket ticket) {
  showGeneralDialog(
    context: context,
    barrierColor: Colors.black87,
    transitionDuration: const Duration(milliseconds: 600),
    pageBuilder: (context, _, __) => _TicketPrintAnimation(ticket: ticket),
  );
}

class _TicketPrintAnimation extends StatefulWidget {
  final Ticket ticket;
  const _TicketPrintAnimation({required this.ticket});
  @override
  State<_TicketPrintAnimation> createState() => _TicketPrintAnimationState();
}

class _TicketPrintAnimationState extends State<_TicketPrintAnimation> {
  double ticketTop = -500;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted) setState(() => ticketTop = 180);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned(
            top: 0, left: 0, right: 0,
            child: Container(
              height: 160, color: const Color(0xFF2D333B),
              child: const SafeArea(child: Center(child: Text("ПЕЧАТЬ БИЛЕТА...", style: TextStyle(color: Colors.white24, fontWeight: FontWeight.bold)))),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOutBack,
            top: ticketTop, left: 25, right: 25,
            child: Column(
              children: [
                Transform.scale(scale: 0.9, child: _ticketItem(context, widget.ticket, isInsidePrinter: true)),
                const SizedBox(height: 40),
                const Icon(Icons.check_circle, color: Color(0xFF34C759), size: 70),
                const Text("ГОТОВО!", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF34C759), padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
                  child: const Text("В КОРЗИНУ", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

