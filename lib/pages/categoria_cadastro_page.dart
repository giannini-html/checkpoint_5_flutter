import 'package:expense_tracker/models/categoria.dart';
import 'package:expense_tracker/models/conta.dart';
import 'package:expense_tracker/models/tipo_transacao.dart';
import 'package:expense_tracker/repository/categoria_repository.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoriaCadastroPage extends StatefulWidget {
  final Categoria? catParaEdicao;
  const CategoriaCadastroPage({super.key, this.catParaEdicao});

  @override
  State<CategoriaCadastroPage> createState() => _CategoriaCadastroPageState();
}

class _CategoriaCadastroPageState extends State<CategoriaCadastroPage> {
    User? user;

  TipoTransacao tipoTransacaoSelecionada = TipoTransacao.receita;

  Categoria? categoriaSelecionada;
  Conta? contaSelecionada;


 @override
  void initState() {
    user = Supabase.instance.client.auth.currentUser;

    final transacao = widget.catParaEdicao;

    if (transacao != null) {
      categoriaSelecionada = transacao;

      descricaoController.text = transacao.descricao;
      tipoTransacaoSelecionada = transacao.tipoTransacao;
    }
    super.initState();
  }

  final descricaoController = TextEditingController();
  final corController = TextEditingController();
  final tipoController = TextEditingController();
  final iconeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final categoriaRepo = CategoriaRepository();

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Categoria'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDescricao(),
                const SizedBox(height: 30),
                _buildCor(),
                const SizedBox(height: 30),
                _buildTipoTransacao(),
                const SizedBox(height: 30),
                _buildIcone(),
                const SizedBox(height: 30),
                _buildButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _buildDescricao() {
    return TextFormField(
      controller: descricaoController,
      decoration: const InputDecoration(
        hintText: 'Informe a descrição',
        labelText: 'Descrição',
        prefixIcon: Icon(Ionicons.text_outline),
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe uma Descrição';
        }
        if (value.length < 5 || value.length > 30) {
          return 'A Descrição deve entre 5 e 30 caracteres';
        }
        return null;
      },
    );
  }

  TextFormField _buildCor() {
    return TextFormField(
      controller: corController,
      decoration: const InputDecoration(
        hintText: 'Informe a cor',
        labelText: 'Cor',
        prefixIcon: Icon(Icons.color_lens),
        border: OutlineInputBorder(),
      ),
    );
  }

  TextFormField _buildIcone() {
    return TextFormField(
      controller: iconeController,
      decoration: const InputDecoration(
        hintText: 'Informe o numero Icone',
        labelText: 'Icone',
        prefixIcon: Icon(Ionicons.logo_ionic),
        border: OutlineInputBorder(),
      ),
    );
  }

  TextFormField _buildTipoTransacao() {
    return TextFormField(
      controller: tipoController,
      decoration: const InputDecoration(
        hintText: 'Tipo Transação',
        labelText: 'Tipo',
        prefixIcon: Icon(Icons.merge_type_outlined),
        border: OutlineInputBorder(),
      ),
    );
  }

  SizedBox _buildButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final isValid = _formKey.currentState!.validate();
          if (isValid) {
            // Descricao
            final descricao = descricaoController.text;

            final categoria = Categoria(
                id: 0,
                descricao: descricao,
                cor: Colors.black12,
                icone: Icons.abc,
                tipoTransacao: TipoTransacao.despesa);

            if (widget.catParaEdicao == null) {
                await _cadastrarCategoria(categoria);
            } else {
              categoria.id = widget.catParaEdicao!.id;
              await _alterarCategoria(categoria);
            }

          }
        },
        child: const Text('Cadastrar'),
      ),
    );
  }

  Future<void> _cadastrarCategoria(Categoria categoria) async {
    final scaffold = ScaffoldMessenger.of(context);
    await categoriaRepo.cadastrarCategoria(categoria).then((_) {
      // Mensagem de Sucesso
      scaffold.showSnackBar(SnackBar(
        content: Text(
          'categoria cadastrada com sucesso',
        ),
      ));
      Navigator.of(context).pop(true);
    }).catchError((error) {
      // Mensagem de Erro
      scaffold.showSnackBar(SnackBar(
        content: Text(
          'Erro ao cadastrar categoria ',
        ),
      ));

      Navigator.of(context).pop(false);
    });
  }

  Future<void> _alterarCategoria(Categoria categoria) async {
    final scaffold = ScaffoldMessenger.of(context);
    await categoriaRepo.alterarCategoria(categoria).then((_) {
      // Mensagem de Sucesso
      scaffold.showSnackBar(SnackBar(
        content: Text(
          'Categoria alterada com sucesso',
        ),
      ));
      Navigator.of(context).pop(true);
    }).catchError((error) {
      // Mensagem de Erro
      scaffold.showSnackBar(SnackBar(
        content: Text(
          'Erro ao alterar Categoria',
        ),
      ));

      Navigator.of(context).pop(false);
    });
  }
}
