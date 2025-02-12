import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({Key? key}) : super(key: key);

  Future<bool> checkIfSeller() async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid ?? '';

    final userDoc = await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(uid)
        .get();

    return userDoc.data()?['isSeller'] ?? false;
  }

  Future<Map<String, dynamic>> fetchDashboardData() async {
    final snapshot = await FirebaseFirestore.instance.collection('cattle').get();

    Map<String, int> breedsCount = {};
    Map<String, int> breedsSold = {};
    Map<String, int> breedsAvailable = {};
    double totalSalesValue = 0.0;

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final isAvailable = data['isAvailable'] as bool? ?? true;
      final breed = data['itemName'] as String? ?? 'Desconhecida';
      final price = data['price'] as double? ?? 0.0;

      if (isAvailable) {
        breedsAvailable[breed] = (breedsAvailable[breed] ?? 0) + 1;
      } else {
        breedsSold[breed] = (breedsSold[breed] ?? 0) + 1;
        totalSalesValue += price;
      }

      breedsCount[breed] = (breedsCount[breed] ?? 0) + 1;
    }

    return {
      'breedsCount': breedsCount,
      'breedsSold': breedsSold,
      'breedsAvailable': breedsAvailable,
      'totalSalesValue': totalSalesValue,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFB52A2A),
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchDashboardData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar os dados.'));
          }

          final data = snapshot.data ?? {};
          final breedsCount = data['breedsCount'] as Map<String, int>? ?? {};
          final breedsSold = data['breedsSold'] as Map<String, int>? ?? {};
          final breedsAvailable = data['breedsAvailable'] as Map<String, int>? ?? {};
          final totalSalesValue = data['totalSalesValue'] ?? 0.0;

          final List<Color> vibrantColors = [
            Colors.red,
            Colors.blue,
            Colors.green,
            Colors.orange,
            Colors.purple,
            Colors.yellow,
            Colors.pink,
            Colors.teal,
            Colors.cyan,
            Colors.deepOrange,
            Colors.indigo,
            Colors.lime,
            Colors.amber,
            Colors.deepPurple,
            Colors.lightBlue,
          ];

          final Map<String, Color> breedColors = {};
          int colorIndex = 0;

          breedsCount.keys.forEach((breed) {
            breedColors[breed] = vibrantColors[colorIndex % vibrantColors.length];
            colorIndex++;
          });

          final totalCount = breedsCount.values.fold(0, (prev, element) => prev + element);

          final List<PieChartSectionData> sections = breedsCount.entries.map((entry) {
            final breed = entry.key;
            final count = entry.value;
            final percentage = totalCount == 0 ? 0 : (count / totalCount) * 100;
            return PieChartSectionData(
              color: breedColors[breed],
              value: count.toDouble(),
              title: '${percentage.toStringAsFixed(1)}%',
              radius: 90,
              titleStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          }).toList();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Resumo de Anúncios e Vendas',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.5,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _buildSummaryCard('Bovino Vendidos', breedsSold.values.fold(0, (prev, element) => prev + element), Colors.blue, Icons.check_circle);
                      } else if (index == 1) {
                        return _buildSummaryCard('Anúncios Ativos', breedsAvailable.values.fold(0, (prev, element) => prev + element), Colors.green, Icons.shopping_cart);
                      } else if (index == 2) {
                        return _buildSummaryCard('Total de Bovinos Cadastrados', breedsCount.values.fold(0, (prev, element) => prev + element), Colors.purple, Icons.inventory);
                      } 
                    },
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const Text(
                    'Gráfico de Pizza',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: PieChart(
                      PieChartData(
                        sections: sections,
                        sectionsSpace: 5,
                        centerSpaceRadius: 50,
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Raças Publicadas',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: breedsCount.keys.length,
                    itemBuilder: (context, index) {
                      final breed = breedsCount.keys.elementAt(index);
                      final count = breedsCount[breed]!;

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: breedColors[breed]!,
                          radius: 10,
                        ),
                        title: Text(breed),
                        trailing: Text(
                          '$count',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  const SizedBox(height: 16),
                  const Text(
                    'Gráfico de Barras',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  AspectRatio(
                    aspectRatio: 1.0,
                    child: BarChart(
                      BarChartData(
                        gridData: FlGridData(show: true),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(
                                  'Qtd.',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                );
                              },
                              reservedSize: 32,
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final breeds = breedsCount.keys.toList();
                                return Text(breeds[value.toInt()] ?? '',
                                    style: TextStyle(color: Colors.black, fontSize: 14));
                              },
                              reservedSize: 32,
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: true),
                        barGroups: breedsCount.keys.map((breed) {
                          return BarChartGroupData(
                            x: breedsCount.keys.toList().indexOf(breed),
                            barRods: [
                              BarChartRodData(
                                toY: breedsAvailable[breed]?.toDouble() ?? 0,
                                color: Colors.green,
                                width: 15,
                                borderRadius: BorderRadius.zero,
                              ),
                              BarChartRodData(
                                toY: breedsSold[breed]?.toDouble() ?? 0,
                                color: Colors.red,
                                width: 15,
                                borderRadius: BorderRadius.zero,
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(String title, dynamic value, Color color, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(icon, size: 28, color: color),
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
