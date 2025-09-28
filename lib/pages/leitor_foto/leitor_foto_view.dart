import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'leitor_foto_controller.dart';
import 'leitor_foto_model.dart';

class LeitorFotoView extends StatefulWidget {
  const LeitorFotoView({super.key});

  @override
  State<LeitorFotoView> createState() => _LeitorFotoViewState();
}

class _LeitorFotoViewState extends State<LeitorFotoView> {
  // Instância do Controller
  final LeitorFotoController _controller = LeitorFotoController();

  @override
  void dispose() {
    _controller.model.dispose(); // Limpa o ValueNotifier
    super.dispose();
  }

  // Widget para exibir a lista de nutrientes de forma elegante
  Widget _buildNutrientList(List<Macronutrient> nutrients) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(top: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Macronutrientes (por porção padrão)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const Divider(height: 16, color: Colors.grey),
            ...nutrients.map((n) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${n.nutrient}:',
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  Text(
                    n.value,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Análise Nutricional por Foto'),
        backgroundColor: Colors.green.shade700,
      ),
      // ValueListenableBuilder re-constrói a tela sempre que o Controller.model muda
      body: ValueListenableBuilder<LeitorFotoModel>(
        valueListenable: _controller.model,
        builder: (context, model, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Botão principal para acionar a seleção e análise
                ElevatedButton.icon(
                  onPressed: model.isLoading 
                      ? null // Desabilita o botão durante o carregamento
                      : _controller.pickAndAnalyzeImage,
                  icon: const Icon(Icons.camera_alt),
                  label: Text(
                    model.selectedImage == null 
                        ? 'Selecionar e Analisar Foto do Alimento'
                        : 'Selecionar Nova Foto',
                    style: const TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),

                const SizedBox(height: 20),

                // 1. Exibição da Imagem Selecionada
                if (model.selectedImage != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      model.selectedImage!,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Container(
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade400)
                    ),
                    alignment: Alignment.center,
                    child: const Text('Nenhuma imagem selecionada.', style: TextStyle(color: Colors.grey)),
                  ),

                const SizedBox(height: 30),

                // 2. Indicador de Carregamento
                if (model.isLoading)
                  const Center(child: CircularProgressIndicator(color: Colors.green)),

                // 3. Exibição de Erro
                if (model.errorMessage != null)
                  Center(
                    child: Text(
                      'Erro: ${model.errorMessage}',
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // 4. Exibição dos Resultados da Análise
                if (model.analysisResult != null && !model.isLoading)
                  _buildResultsCard(model.analysisResult!),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultsCard(FoodAnalysisResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Card Principal de Título e Calorias
        Card(
          color: Colors.green.shade50,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  result.foodName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Icon(Icons.local_fire_department, color: Colors.orange, size: 28),
                    const SizedBox(width: 8),
                    Text(
                      '${result.calories} Kcal',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const Text('Valores aproximados para 100g ou porção média.', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ),

        // Lista de Macronutrientes
        _buildNutrientList(result.macronutrients),
      ],
    );
  }
}
