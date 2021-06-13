import 'package:acerta_ou_tapa/utilities/api_banco.dart';
import 'package:chat_list/chat_list.dart';
import 'package:flutter/material.dart';

class ChatApp extends StatefulWidget {
  const ChatApp({Key key}) : super(key: key);

  @override
  _ChatAppState createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  final List<Message> mensagens = [];

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
        controllerText.text = '';
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
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        height: MediaQuery.of(context).size.height * .2,
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
                      onPressed: () => addMensagem(
                        mensagem: controllerText.text,
                        autor: ApiBanco.usuario().nome,
                        tipo: OwnerType.sender,
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
