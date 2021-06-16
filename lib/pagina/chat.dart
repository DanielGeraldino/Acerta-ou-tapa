import 'package:acerta_ou_tapa/utilities/api_banco.dart';
import 'package:chat_list/chat_list.dart';
import 'package:flutter/material.dart';

class ChatApp extends StatefulWidget {
  final idPartida;

  ChatApp({
    Key key,
    this.idPartida,
  }) : super(key: key);

  @override
  _ChatAppState createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  final List<Message> mensagens = [];
  bool _ativo = true;

  final TextEditingController controllerText = TextEditingController();
  final ScrollController controllerScrollMessage = ScrollController();

  void _onNewMessage() {
    controllerScrollMessage.animateTo(
      controllerScrollMessage.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInToLinear,
    );
  }

  void addMensagem({
    String mensagem,
    String autor,
    OwnerType tipo,
  }) {
    if (mensagem.isNotEmpty) {
      setState(() {
        mensagens.add(Message(
          ownerName: autor,
          ownerType: tipo,
          content: mensagem,
        ));
        _onNewMessage();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.doWhile(() async {
      List<Map<String, Object>> mensagensApi =
          await ApiBanco.recebeMensagens(widget.idPartida);
      if (mensagensApi.isNotEmpty) {
        mensagens.clear();
        mensagensApi.forEach((element) {
          addMensagem(
            mensagem: element['mensagem'],
            autor: '{$element["idUsuario"]}',
            tipo: element['idUsuario'] == ApiBanco.usuario().id
                ? OwnerType.sender
                : OwnerType.receiver,
          );
        });
      }

      await Future.delayed(Duration(seconds: 5));
      return _ativo;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _ativo = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        height: MediaQuery.of(context).size.height * .4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ChatList(
                children: mensagens,
                scrollController: controllerScrollMessage,
              ),
            ),
            Container(
              child: TextField(
                controller: controllerText,
                decoration: InputDecoration(
                  hintText: 'Entre com a mensagem',
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.blue,
                    ),
                    onPressed: () async {
                      await ApiBanco.enviarMensagem(
                          controllerText.text, widget.idPartida);
                      addMensagem(
                        mensagem: controllerText.text,
                        autor: ApiBanco.usuario().nome,
                        tipo: OwnerType.sender,
                      );

                      controllerText.text = '';
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
