import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/ticket_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TicketsState {
  final List<Ticket> tickets;
  final bool isLoading;
  final String? error;
  final int usedSubsidies;

  TicketsState({
    this.tickets = const [],
    this.isLoading = false,
    this.error,
    this.usedSubsidies = 0,
  });

  TicketsState copyWith({
    List<Ticket>? tickets,
    bool? isLoading,
    String? error,
    int? usedSubsidies,
  }) {
    return TicketsState(
      tickets: tickets ?? this.tickets,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      usedSubsidies: usedSubsidies ?? this.usedSubsidies,
    );
  }
}

class TicketsCubit extends Cubit<TicketsState> {
  TicketsCubit() : super(TicketsState());

  Future<void> loadTickets() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final snapshot = await FirebaseFirestore.instance.collection('tickets').get();
      final List<Ticket> loadedTickets = snapshot.docs.map((doc) {
        return Ticket.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      loadedTickets.sort((a, b) {
        int priceCompare = a.price.compareTo(b.price);
        if (priceCompare != 0) return priceCompare;
        return a.date.compareTo(b.date);
      });
      emit(state.copyWith(
        isLoading: false,
        tickets: loadedTickets,
      ));
      print("✅ Успешно загружено и отсортировано: ${loadedTickets.length} билетов");
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: "Ошибка загрузки: $e",
      ));
    }
  }

  Future<void> buyTicket(Ticket ticket) async {
    emit(state.copyWith(error: null));
    if (ticket.isSubsidized) {
      if (state.usedSubsidies >= 4) {
        emit(state.copyWith(
            error: "Лимит исчерпан: согласно правилам, доступно не более 4 субсидированных поездок в год."
        ));
        return;
      }
        try{
      final newCount = state.usedSubsidies + 1;
      await FirebaseFirestore.instance
          .collection('tickets')
          .doc('36wZ3n95HVJsAe3uKnWZ')
          .update({'subsidies': newCount});
      emit(state.copyWith(usedSubsidies: newCount));
      print("✅ Данные обновлены в Firebase! Субсидий: $newCount");
        } catch (e) {
          print("❌ Ошибка при записи в Firebase: $e");
          emit(state.copyWith(error: "Не удалось сохранить данные в облаке"));
        }
    } else {
      print("Обычный билет оформлен.");
    }
  }

  void loadSubsidies() {
    FirebaseFirestore.instance
        .collection('tickets')
        .doc('36wZ3n95HVJsAe3uKnWZ')
        .snapshots()
        .listen((doc) {
      if (doc.exists) {
        final int cloudValue = doc.data()?['subsidies'] ?? 0;
        emit(state.copyWith(usedSubsidies: cloudValue));
        print("🔥 Живое обновление лимита: $cloudValue из 4");
      }
    }, onError: (error) {
      print("❌ Ошибка живого потока: $error");
    });
  }
  Future<void> seedDatabase() async {
    final collection = FirebaseFirestore.instance.collection('tickets');
    final initialTickets = [
      {
        'destination': 'Якутск — Москва',
        'price': 14500,
        'isSubsidized': true,
      },
      {
        'destination': 'Якутск — Харбин',
        'price': 32000,
        'isSubsidized': false,
      },
      {
        'destination': 'Якутск — Владивосток',
        'price': 9800,
        'isSubsidized': true,
      },
      {
        'destination': 'Якутск — Иркутск',
        'price': 11200,
        'isSubsidized': false,
      },
      {
        'destination': 'Якутск — Сочи',
        'price': 18900,
        'isSubsidized': true,
      },
    ];

    try {
      print("Начинаю наполнение базы билетами...");
      for (var ticketData in initialTickets) {
        await collection.add(ticketData);
      }
      print("✅ База успешно наполнена!");
      loadTickets();
    } catch (e) {
      print("❌ Ошибка при наполнении базы: $e");
    }
  }
}
