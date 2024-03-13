import 'dart:convert';

import 'package:flutter/material.dart';

Widget clientCard(Map<String, dynamic> cliente, BuildContext context) {
  //Map<String, dynamic>? dadosCompletos = cliente["dados_completo"] != null ? jsonDecode(cliente["dados_completo"]) as Map<String, dynamic> : null;
  Map<String, dynamic>? endereco = cliente["endereco"] != null ? cliente["endereco"] as Map<String, dynamic> : null;

  return Card(
    color: Colors.grey[50],
    elevation: 8.0,
    margin: const EdgeInsets.all(4.0),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectionArea(
            child: Text(
              "${cliente["codigo"] != null ? cliente["codigo"].toString() :  cliente["id"].toString()} - ${cliente["razao_social"]}",
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SelectionArea(
            child: Text(
              "${cliente["nome_fantasia"]}",
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SelectionArea(
            child: Text(
              "CnpjCpf ${cliente["cnpj_cpf"]}",
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SelectionArea(
            child: Text(
              "${endereco != null ? endereco["logradouro"] : "Sem logradouro"}",
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
