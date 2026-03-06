package com.example.yakutsk_hub

import com.yandex.mapkit.MapKitFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        // ВСТАВЬТЕ ВАШ КЛЮЧ В КАВЫЧКИ НИЖЕ
        MapKitFactory.setApiKey("9798a5d5-2c82-4291-a2c8-0b4798c79a00")
        super.configureFlutterEngine(flutterEngine)
    }
}

