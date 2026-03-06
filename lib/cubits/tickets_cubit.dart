import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/ticket_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// 1. Состояния экрана
class TicketsState {
  final List<Ticket> tickets;
  final bool isLoading;
  final String? error;
  final int usedSubsidies; // Тот самый счетчик (макс 4)

  TicketsState({
    this.tickets = const [],
    this.isLoading = false,
    this.error,
    this.usedSubsidies = 0,
  });

  // Добавь это, чтобы метод в Cubit заработал:
  TicketsState copyWith({
    List<Ticket>? tickets,
    bool? isLoading,
    String? error,
    int? usedSubsidies,
  }) {
    return TicketsState(
      tickets: tickets ?? this.tickets,
      isLoading: isLoading ?? this.isLoading,
      error: error, // Ошибку обычно передаем как есть или зануляем
      usedSubsidies: usedSubsidies ?? this.usedSubsidies,
    );
  }
}

// 2. Сама логика
class TicketsCubit extends Cubit<TicketsState> {
  TicketsCubit() : super(TicketsState());

  // Метод загрузки билетов
  Future<void> loadTickets() async {
    // 1. Включаем индикатор загрузки, сохраняя текущие субсидии
    emit(state.copyWith(isLoading: true, error: null));

    try {
      // 2. Получаем данные из коллекции 'tickets'
      final snapshot = await FirebaseFirestore.instance.collection('tickets').get();

      // 3. Превращаем документы из Firebase в список объектов Ticket через fromMap
      final List<Ticket> loadedTickets = snapshot.docs.map((doc) {
        return Ticket.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      // 4.Сортировка: сначала самые дешевые (asc)
      loadedTickets.sort((a, b) {
        int priceCompare = a.price.compareTo(b.price);
        if (priceCompare != 0) return priceCompare;
        return a.date.compareTo(b.date); // Если цена равна, смотрим на дату
      });

      // 5. Отправляем готовый список в состояние
      emit(state.copyWith(
        isLoading: false,
        tickets: loadedTickets,
      ));

      print("✅ Успешно загружено и отсортировано: ${loadedTickets.length} билетов");

    } catch (e) {
      // В случае ошибки Лисёнок выводит сообщение
      emit(state.copyWith(
        isLoading: false,
        error: "Ошибка загрузки: $e",
      ));
    }
  }

  Future<void> buyTicket(Ticket ticket) async {
    // 1. Очищаем прошлые ошибки, если они были
    emit(state.copyWith(error: null));

    // 2. Если билет субсидированный — проверяем лимит
    if (ticket.isSubsidized) {
      if (state.usedSubsidies >= 4) {
        // Лисёнок находит нарушение лимита!
        emit(state.copyWith(
            error: "Лимит исчерпан: согласно правилам, доступно не более 4 субсидированных поездок в год."
        ));
        return; // Прерываем покупку
      }
        try{
      // 3. Имитируем успешную покупку и увеличиваем счетчик
      final newCount = state.usedSubsidies + 1;

      await FirebaseFirestore.instance
          .collection('tickets')
          .doc('36wZ3n95HVJsAe3uKnWZ')
          .update({'subsidies': newCount});
      // -----------------------------------

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
    // Убираем Future/async/await, так как snapshots() работает сам по себе
    FirebaseFirestore.instance
        .collection('tickets')
        .doc('36wZ3n95HVJsAe3uKnWZ')
        .snapshots() // <--- ГЛАВНОЕ ИЗМЕНЕНИЕ
        .listen((doc) {
      if (doc.exists) {
        final int cloudValue = doc.data()?['subsidies'] ?? 0;

        // Как только данные в облаке изменятся, Cubit выстрелит новым состоянием
        emit(state.copyWith(usedSubsidies: cloudValue));

        print("🔥 Живое обновление лимита: $cloudValue из 4");
      }
    }, onError: (error) {
      print("❌ Ошибка живого потока: $error");
    });
  }
  Future<void> seedDatabase() async {
    final collection = FirebaseFirestore.instance.collection('tickets');

    // Список реальных рейсов из Якутска (цены примерные на март 2026)
    final initialTickets = [
      {
        'destination': 'Якутск — Москва',
        'price': 14500,
        'isSubsidized': true, // Субсидированный для жителей ДФО
      },
      {
        'destination': 'Якутск — Харбин',
        'price': 32000,
        'isSubsidized': false, // Международный
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
        // Добавляем каждый билет как новый документ
        await collection.add(ticketData);
      }
      print("✅ База успешно наполнена!");

      // После наполнения сразу обновляем список на экране
      loadTickets();
    } catch (e) {
      print("❌ Ошибка при наполнении базы: $e");
    }
  }
}
