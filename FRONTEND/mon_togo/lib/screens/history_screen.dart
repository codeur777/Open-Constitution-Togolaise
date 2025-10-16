import 'package:flutter/material.dart';
import '../models/conversation.dart';
import '../services/api_services.dart';
import 'chat_screen.dart';


class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Conversation> _conversations = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  void _loadConversations() async {
    final convos = await ApiService.getConversations();
    setState(() {
      _conversations = convos;
    });
  }

  void _searchConversations(String query) {
    // Implémentation de recherche simple (filtre sur titre ou contenu)
    setState(() {
      _conversations = _conversations.where((convo) {
        return convo.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  void _deleteConversation(String id) async {
    await ApiService.deleteConversation(id);
    _loadConversations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des Conversations'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Rechercher',
                border: OutlineInputBorder(),
              ),
              onChanged: _searchConversations,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _conversations.length,
              itemBuilder: (context, index) {
                final convo = _conversations[index];
                return ListTile(
                  title: Text(convo.title),
                  subtitle: Text(convo.lastMessage),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteConversation(convo.id),
                  ),
                  onTap: () {
                    // Naviguer vers le chat avec cette conversation
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(), // Adapter pour charger la convo
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}