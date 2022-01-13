import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:inventario_nm/src/controller/produto_controller.dart';
import 'package:inventario_nm/src/model/Produto.dart';
import 'package:http/http.dart' as http;
import 'package:inventario_nm/src/modules/home/widgets/drawer.dart';

class ApiProdutos {
  static bool? controlador;
  static int progresso = 0;
  static bool cancelar = false;

  static getProducts(int valorInicial, int valorFinal) async {
    bool loading = true;
    int init = valorInicial;
    int end = valorFinal;
    bool flag = true;
    controlador = false;

    try {
      DrawerInventario.error = false;
      while (flag) {
        if(cancelar) {
          break;
        }
        progresso++;
        DrawerInventario.progresso.text = progresso.toString();
        
        String urlApi = "https://inventarionm-apih.novomundo.com.br/api/produtos/$init/$end";

        Dio dio = new Dio();
        Response response = await dio.get(urlApi).whenComplete(() => {loading = false});
        List apiProducts = response.data;

        if (apiProducts.isEmpty) {
          flag = false;
        } else {
          init = end + 1;
          end = end + 10000;
          print(response.data);
          await salvarProdutos(response.data).whenComplete(() => {print('Finalizei')});
        }
      }
    } catch (err) {
      loading = false;
      DrawerInventario.error = true;
      print('Erro ao realizar o get ${err.toString()}');
    }
    controlador = true;
    progresso = 0;
    cancelar = false;
    return loading;
  }

  static Future salvarProdutos(List json) async {
    for (Map prod in json) {
      Produto produto = new Produto();
      produto.id_produto = int.parse(prod["id_produto"]);
      try {
        produto.ean = prod["ean"] == null ? '' : prod["ean"];
      } catch (e) {
        print(e.toString() + ' ' + prod["ean"]);
      }
      try {
        produto.nome = prod["nome"];
      } catch (e) {
        print('Nome> ' + e.toString() + ' ' + prod["nome"]);
      }
      await ProdutoController.salvarProduto(produto);
    }
  }
}
