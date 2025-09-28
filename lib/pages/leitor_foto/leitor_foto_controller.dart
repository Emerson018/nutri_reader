import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'leitor_foto_model.dart';
import '../../API/api_keys.dart';

// Chave da API (MANTENHA ISSO FORA DO CÓDIGO FONTE EM UMA APLICAÇÃO REAL!)
// No ambiente de desenvolvimento, assumimos que a chave será injetada.
const String _apiKey = geminiApiKey; 
const String _geminiUrl = 
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-preview-05-20:generateContent?key=$_apiKey';

class LeitorFotoController {
  // ValueNotifier é uma forma simples de gerenciar o estado no Flutter
  // Ele permite que a View "escute" as mudanças no Model.
  final ValueNotifier<LeitorFotoModel> model = ValueNotifier(LeitorFotoModel());
  final ImagePicker _picker = ImagePicker();

  // --- 1. Lógica de Seleção de Imagem ---

  Future<void> pickAndAnalyzeImage() async {
    // 1. Atualiza o estado para Carregando (com base na seleção inicial)
    model.value = model.value.copyWith(
      isLoading: true,
      analysisResult: null,
      errorMessage: null,
    );

    try {
      // Abre a galeria para seleção
      final XFile? xFile = await _picker.pickImage(source: ImageSource.gallery);

      if (xFile == null) {
        // Se o usuário cancelou, remove o estado de carregamento
        model.value = model.value.copyWith(isLoading: false);
        return;
      }

      final File file = File(xFile.path);

      // 2. Atualiza o estado com a imagem selecionada
      model.value = model.value.copyWith(selectedImage: file);

      // 3. Chama a API de Visão do Gemini
      final FoodAnalysisResult? result = await _callGeminiVisionApi(file);

      // 4. Atualiza o estado com o resultado
      if (result != null) {
        model.value = model.value.copyWith(
          analysisResult: result,
          isLoading: false,
          errorMessage: null,
        );
      } else {
        // Trata o caso em que a API retorna null/erro
        model.value = model.value.copyWith(
          analysisResult: null,
          isLoading: false,
          errorMessage: 'Falha ao analisar o alimento. Tente outra foto.',
        );
      }
    } catch (e) {
      debugPrint('Erro no Controller: $e');
      model.value = model.value.copyWith(
        isLoading: false,
        errorMessage: 'Ocorreu um erro inesperado: ${e.toString()}',
      );
    }
  }

  // --- 2. Lógica de Chamada à API Gemini ---

  Future<FoodAnalysisResult?> _callGeminiVisionApi(File imageFile) async {
    try {
      // 1. Converte o arquivo de imagem para Base64 (necessário para o payload JSON)
      final List<int> imageBytes = await imageFile.readAsBytes();
      final String base64Image = base64Encode(imageBytes);

      // 2. Define o esquema JSON que o Gemini deve seguir (obrigando a resposta estruturada)
      const jsonSchema = {
        'type': 'OBJECT',
        'properties': {
          'foodName': {'type': 'STRING', 'description': 'O nome exato do alimento reconhecido.'},
          'calories': {'type': 'INTEGER', 'description': 'Calorias totais em kcal para 100g ou uma porção média do item principal.'},
          'macronutrients': {
            'type': 'ARRAY',
            'description': 'Lista de macronutrientes principais e seus valores em gramas ou miligramas por 100g ou porção média.',
            'items': {
              'type': 'OBJECT',
              'properties': {
                'nutrient': {'type': 'STRING'},
                'value': {'type': 'STRING'}
              }
            }
          }
        },
        'required': ['foodName', 'calories', 'macronutrients']
      };

      // 3. Constrói o payload com a imagem e o esquema
      final payload = {
        'contents': [
          {
            'parts': [
              // Texto de instrução
              {'text': 'Analise esta imagem. Identifique o alimento principal (fruta, vegetal, refeição) e extraia o nome, as calorias totais e a composição detalhada dos macronutrientes (Carboidratos, Proteínas, Gorduras, Fibras) para 100g ou uma porção padrão.'},
              // Imagem em Base64
              {
                'inlineData': {
                  'mimeType': 'image/jpeg', 
                  'data': base64Image,
                }
              }
            ]
          }
        ],
        'generationConfig': {
          'responseMimeType': 'application/json',
          'responseSchema': jsonSchema,
        },
      };

      // 4. Faz a requisição HTTP POST
      final response = await http.post(
        Uri.parse(_geminiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      // 5. Processa a resposta
      if (response.statusCode == 200) {
        final Map<String, dynamic> apiResponse = jsonDecode(response.body);
        
        // A resposta JSON estruturada está no campo parts[0].text
        final String jsonText = apiResponse['candidates'][0]['content']['parts'][0]['text'];
        final Map<String, dynamic> foodJson = jsonDecode(jsonText);
        
        return FoodAnalysisResult.fromJson(foodJson);

      } else {
        debugPrint('Erro na API: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Exceção ao chamar API: $e');
      return null;
    }
  }
}
