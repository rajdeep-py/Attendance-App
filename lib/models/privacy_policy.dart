class PrivacyPolicy {
  final int id;
  final String policyHeader;
  final String policyDescription;

  PrivacyPolicy({
    required this.id,
    required this.policyHeader,
    required this.policyDescription,
  });

  factory PrivacyPolicy.fromJson(Map<String, dynamic> json) {
    return PrivacyPolicy(
      id: (json['id'] as num?)?.toInt() ?? 0,
      policyHeader: (json['policy_header'] ?? json['policyHeader'] ?? '')
          .toString(),
      policyDescription:
          (json['policy_description'] ?? json['policyDescription'] ?? '')
              .toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'policy_header': policyHeader,
      'policy_description': policyDescription,
    };
  }
}
