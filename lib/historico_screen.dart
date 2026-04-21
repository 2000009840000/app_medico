import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoricoScreen extends StatelessWidget {
  const HistoricoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FF),
      appBar: AppBar(
        title: const Text('Histórico'),
        backgroundColor: const Color(0xFF0C447C),
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('agendamentos')
            .orderBy('criadoEm', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro ao carregar histórico.',
                style: GoogleFonts.inter(fontSize: 16),
              ),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return Center(
              child: Text(
                'Nenhum agendamento encontrado.',
                style: GoogleFonts.inter(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final item = docs[index];
              final data = item['data'] ?? '';
              final horario = item['horario'] ?? '';
              final nomePaciente = item['nomePaciente'] ?? '';
              final especialidade = item['especialidade'] ?? '';
              final observacoes = item['observacoes'] ?? '';

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nomePaciente,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0C447C),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Data: $data',
                        style: GoogleFonts.inter(fontSize: 14),
                      ),
                      Text(
                        'Horário: $horario',
                        style: GoogleFonts.inter(fontSize: 14),
                      ),
                      Text(
                        'Especialidade: $especialidade',
                        style: GoogleFonts.inter(fontSize: 14),
                      ),
                      if (observacoes.toString().isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Observações: $observacoes',
                          style: GoogleFonts.inter(fontSize: 14),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
