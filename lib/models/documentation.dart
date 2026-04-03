class Documentation {
  final int id;
  final String docHeader;
  final String docDescription;

  Documentation({
    required this.id,
    required this.docHeader,
    required this.docDescription,
  });

  factory Documentation.fromJson(Map<String, dynamic> json) {
    return Documentation(
      id: (json['id'] as num?)?.toInt() ?? 0,
      docHeader: (json['doc_header'] ?? json['docHeader'] ?? '').toString(),
      docDescription: (json['doc_description'] ?? json['docDescription'] ?? '')
          .toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doc_header': docHeader,
      'doc_description': docDescription,
    };
  }
}
