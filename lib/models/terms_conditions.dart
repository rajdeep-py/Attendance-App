class TermsConditions {
  final int id;
  final String termHeadline;
  final String termDescription;

  TermsConditions({
    required this.id,
    required this.termHeadline,
    required this.termDescription,
  });

  factory TermsConditions.fromJson(Map<String, dynamic> json) {
    return TermsConditions(
      id: (json['id'] as num?)?.toInt() ?? 0,
      termHeadline: (json['term_headline'] ?? json['termHeadline'] ?? '')
          .toString(),
      termDescription:
          (json['term_description'] ?? json['termDescription'] ?? '')
              .toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'term_headline': termHeadline,
      'term_description': termDescription,
    };
  }
}
