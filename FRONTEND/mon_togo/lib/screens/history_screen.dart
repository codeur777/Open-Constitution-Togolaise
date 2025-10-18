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
  List<Conversation> _filteredConversations = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  void _loadConversations() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final convosData = await ApiService.getConversations();

      // Convertir List<Map<String, dynamic>> en List<Conversation>
      final convos = convosData.map((data) {
        return Conversation(
          id: data['id']?.toString() ?? '',
          title: data['title']?.toString() ?? 'Sans titre',
          lastMessage: data['lastMessage']?.toString() ?? '',
          // Ajoutez d'autres champs selon votre modèle Conversation
        );
      }).toList();

      setState(() {
        _conversations = convos;
        _filteredConversations = convos;
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur lors du chargement: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _searchConversations(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredConversations = _conversations;
      } else {
        _filteredConversations = _conversations.where((convo) {
          return convo.title.toLowerCase().contains(query.toLowerCase()) ||
              convo.lastMessage.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _deleteConversation(String id) async {
    try {
      await ApiService.deleteConversation(id);
      _loadConversations();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Conversation supprimée')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
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
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _searchConversations,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredConversations.isEmpty
                ? const Center(
              child: Text('Aucune conversation trouvée'),
            )
                : ListView.builder(
              itemCount: _filteredConversations.length,
              itemBuilder: (context, index) {
                final convo = _filteredConversations[index];
                return ListTile(
                  title: Text(convo.title),
                  subtitle: Text(
                    convo.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _showDeleteDialog(convo.id),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(),
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

  void _showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Voulez-vous vraiment supprimer cette conversation ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteConversation(id);
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}