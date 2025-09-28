import 'dart:io';

// --- Estruturas de Dados Nutricionais (o que a IA irá retornar) ---

// Representa um único nutriente (ex: "Carboidratos", "25g")
class Macronutrient {
  final String nutrient;
  final String value;

  Macronutrient({required this.nutrient, required this.value});

  // Factory para criar o objeto a partir do JSON retornado pela API
  factory Macronutrient.fromJson(Map<String, dynamic> json) {
    return Macronutrient(
      nutrient: json['nutrient'] ?? 'N/A',
      value: json['value'] ?? 'N/A',
    );
  }
}

// Representa o resultado completo da análise do alimento
class FoodAnalysisResult {
  final String foodName;
  final int calories;
  final List<Macronutrient> macronutrients;

  FoodAnalysisResult({
    required this.foodName,
    required this.calories,
    required this.macronutrients,
  });

  // Factory para criar o objeto a partir do JSON principal da API
  factory FoodAnalysisResult.fromJson(Map<String, dynamic> json) {
    var list = json['macronutrients'] as List;
    List<Macronutrient> nutrientsList =
        list.map((i) => Macronutrient.fromJson(i)).toList();

    return FoodAnalysisResult(
      foodName: json['foodName'] ?? 'Alimento Desconhecido',
      calories: json['calories'] ?? 0,
      macronutrients: nutrientsList,
    );
  }
}

// --- Estado da Tela (o que o Controller gerencia) ---

// Estado que a View irá observar.
class LeitorFotoModel {
  // Arquivo de imagem selecionado. Pode ser null antes da seleção.
  File? selectedImage; 
  // Resultado da análise. Pode ser null se ainda não foi analisado.
  FoodAnalysisResult? analysisResult;
  // Estado de carregamento para a UI.
  bool isLoading;
  // Mensagem de erro.
  String? errorMessage;

  LeitorFotoModel({
    this.selectedImage,
    this.analysisResult,
    this.isLoading = false,
    this.errorMessage,
  });

  // Método para criar uma cópia do estado com novos valores.
  LeitorFotoModel copyWith({
    File? selectedImage,
    FoodAnalysisResult? analysisResult,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LeitorFotoModel(
      selectedImage: selectedImage ?? this.selectedImage,
      analysisResult: analysisResult ?? this.analysisResult,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage, // Note: passa o novo erro ou mantém null
    );
  }
}
