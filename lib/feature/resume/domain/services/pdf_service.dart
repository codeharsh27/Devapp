import 'dart:typed_data';

import 'package:blog_app/feature/resume/data/models/resume_models.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfService {
  Future<Uint8List> generateResume(ResumeData data) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          switch (data.resumeStyle) {
            case 'Modern':
              return _buildModernLayout(data);
            case 'Minimalist':
              return _buildMinimalistLayout(data);
            case 'Creative-ATS':
              return _buildCreativeLayout(data);
            case 'Executive':
              return _buildExecutiveLayout(data);
            case 'Technical':
              return _buildTechnicalLayout(data);
            case 'Professional':
            default:
              return _buildProfessionalLayout(data);
          }
        },
      ),
    );

    // Add AI Feedback Page if available
    if (data.atsScore != null ||
        data.recommendations.isNotEmpty ||
        data.missingSkills.isNotEmpty) {
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return [
              pw.Header(
                level: 0,
                child: pw.Text(
                  'AI Resume Analysis & Feedback',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blueGrey900,
                  ),
                ),
              ),
              pw.SizedBox(height: 20),

              if (data.atsScore != null) ...[
                _buildSectionTitle('Estimated ATS Score'),
                pw.Container(
                  alignment: pw.Alignment.center,
                  padding: const pw.EdgeInsets.symmetric(vertical: 20),
                  child: pw.Column(
                    children: [
                      pw.Text(
                        '${data.atsScore!.toStringAsFixed(1)} / 100',
                        style: pw.TextStyle(
                          fontSize: 40,
                          fontWeight: pw.FontWeight.bold,
                          color: data.atsScore! > 85
                              ? PdfColors.green700
                              : (data.atsScore! > 70
                                    ? PdfColors.orange700
                                    : PdfColors.red700),
                        ),
                      ),
                      pw.Text(
                        data.atsScore! > 85
                            ? 'Excellent'
                            : (data.atsScore! > 70
                                  ? 'Good Potenetial'
                                  : 'Needs Improvement'),
                        style: const pw.TextStyle(
                          fontSize: 14,
                          color: PdfColors.grey700,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),
              ],

              if (data.missingSkills.isNotEmpty) ...[
                _buildSectionTitle('Missing Key Skills'),
                pw.Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: data.missingSkills
                      .map(
                        (skill) => pw.Container(
                          padding: const pw.EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: pw.BoxDecoration(
                            color: PdfColors.red50,
                            border: pw.Border.all(color: PdfColors.red200),
                            borderRadius: pw.BorderRadius.circular(4),
                          ),
                          child: pw.Text(
                            skill,
                            style: const pw.TextStyle(
                              color: PdfColors.red900,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                pw.SizedBox(height: 20),
              ],

              if (data.recommendations.isNotEmpty) ...[
                _buildSectionTitle('Recommendations & Keywords'),
                ...data.recommendations.map(
                  (rec) => pw.Container(
                    margin: const pw.EdgeInsets.only(bottom: 8),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          '• ',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.blueGrey,
                          ),
                        ),
                        pw.Expanded(
                          child: pw.Text(
                            rec,
                            style: const pw.TextStyle(fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ];
          },
        ),
      );
    }

    return pdf.save();
  }

  // --- Layout Builders ---

  List<pw.Widget> _buildProfessionalLayout(ResumeData data) {
    return [
      _buildHeader(data.personalDetails),
      pw.SizedBox(height: 20),
      _buildSectionTitle('Professional Summary'),
      pw.Text(data.summary, style: const pw.TextStyle(fontSize: 12)),
      pw.SizedBox(height: 20),
      _buildSectionTitle('Experience'),
      ...data.experience.map((exp) => _buildExperienceItem(exp)),
      pw.SizedBox(height: 20),
      _buildSectionTitle('Education'),
      ...data.education.map((edu) => _buildEducationItem(edu)),
      pw.SizedBox(height: 20),
      _buildSectionTitle('Skills'),
      _buildSkills(data.skills),
      pw.SizedBox(height: 20),
      _buildSectionTitle('Projects'),
      ...data.projects.map((proj) => _buildProjectItem(proj)),
      pw.SizedBox(height: 20),
      _buildSectionTitle('Languages'),
      _buildLanguages(data.languages),
      pw.SizedBox(height: 20),
      _buildSectionTitle('Certifications'),
      ...data.certifications.map((cert) => _buildCertificationItem(cert)),
    ];
  }

  List<pw.Widget> _buildModernLayout(ResumeData data) {
    // Modern: Left sidebar with dark background for personal info, right side for content
    final accentColor = PdfColors.blueGrey900;

    return [
      pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Sidebar (Simulated with Column since MultiPage doesn't support full height container easily without layout issues)
          // Actually, for MultiPage, it's better to have a header and then content.
          // Let's do a top-heavy modern design instead of sidebar to avoid pagination issues.
          pw.Expanded(
            child: pw.Column(
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          data.personalDetails.fullName.toUpperCase(),
                          style: pw.TextStyle(
                            fontSize: 28,
                            fontWeight: pw.FontWeight.bold,
                            color: accentColor,
                          ),
                        ),
                        pw.Text(
                          data.personalDetails.currentRole,
                          style: pw.TextStyle(
                            fontSize: 14,
                            color: PdfColors.grey700,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(data.personalDetails.email),
                        pw.Text(data.personalDetails.phone),
                        pw.Text(data.personalDetails.location),
                        if (data.personalDetails.linkedinUrl.isNotEmpty)
                          pw.Text(
                            data.personalDetails.linkedinUrl,
                            style: const pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.blue,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                pw.Divider(color: accentColor, thickness: 2),
                pw.SizedBox(height: 16),

                // Summary
                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Text(
                    data.summary,
                    style: const pw.TextStyle(fontSize: 11),
                  ),
                ),
                pw.SizedBox(height: 20),

                // Two column layout for Skills and Experience
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // Left Column (Skills, Education, Languages)
                    pw.Expanded(
                      flex: 1,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          _buildModernSectionTitle('Skills', accentColor),
                          _buildSkills(data.skills),
                          pw.SizedBox(height: 20),
                          _buildModernSectionTitle('Education', accentColor),
                          ...data.education.map(
                            (edu) => _buildEducationItem(edu),
                          ),
                          pw.SizedBox(height: 20),
                          _buildModernSectionTitle('Languages', accentColor),
                          _buildLanguages(data.languages),
                        ],
                      ),
                    ),
                    pw.SizedBox(width: 20),
                    // Right Column (Experience, Projects)
                    pw.Expanded(
                      flex: 2,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          _buildModernSectionTitle('Experience', accentColor),
                          ...data.experience.map(
                            (exp) => _buildExperienceItem(exp),
                          ),
                          pw.SizedBox(height: 20),
                          _buildModernSectionTitle('Projects', accentColor),
                          ...data.projects.map(
                            (proj) => _buildProjectItem(proj),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ];
  }

  List<pw.Widget> _buildMinimalistLayout(ResumeData data) {
    // Minimalist: Very clean, lots of whitespace, thin fonts
    return [
      pw.Center(
        child: pw.Column(
          children: [
            pw.Text(
              data.personalDetails.fullName.toUpperCase(),
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.normal,
                letterSpacing: 2,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              data.personalDetails.currentRole.toUpperCase(),
              style: const pw.TextStyle(
                fontSize: 10,
                letterSpacing: 1.5,
                color: PdfColors.grey600,
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text(data.personalDetails.email),
                pw.Text(' | '),
                pw.Text(data.personalDetails.phone),
                pw.Text(' | '),
                pw.Text(data.personalDetails.location),
              ],
            ),
          ],
        ),
      ),
      pw.SizedBox(height: 30),

      _buildMinimalistSectionTitle('Summary'),
      pw.Text(
        data.summary,
        style: const pw.TextStyle(fontSize: 11, lineSpacing: 1.5),
      ),
      pw.SizedBox(height: 20),

      _buildMinimalistSectionTitle('Experience'),
      ...data.experience.map((exp) => _buildExperienceItem(exp)),
      pw.SizedBox(height: 20),

      _buildMinimalistSectionTitle('Skills'),
      pw.Text(data.skills.join(' • '), style: const pw.TextStyle(fontSize: 11)),
      pw.SizedBox(height: 20),

      _buildMinimalistSectionTitle('Education'),
      ...data.education.map((edu) => _buildEducationItem(edu)),
    ];
  }

  List<pw.Widget> _buildCreativeLayout(ResumeData data) {
    // Creative: Header with background, distinct sections
    const headerColor = PdfColors.teal700;
    return [
      pw.Container(
        padding: const pw.EdgeInsets.all(20),
        color: headerColor,
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  data.personalDetails.fullName,
                  style: pw.TextStyle(
                    fontSize: 26,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
                pw.Text(
                  data.personalDetails.currentRole,
                  style: const pw.TextStyle(
                    fontSize: 14,
                    color: PdfColors.white,
                  ),
                ),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(
                  data.personalDetails.email,
                  style: const pw.TextStyle(color: PdfColors.white),
                ),
                pw.Text(
                  data.personalDetails.phone,
                  style: const pw.TextStyle(color: PdfColors.white),
                ),
                pw.Text(
                  data.personalDetails.location,
                  style: const pw.TextStyle(color: PdfColors.white),
                ),
              ],
            ),
          ],
        ),
      ),
      pw.SizedBox(height: 20),
      _buildSectionTitle('Professional Summary'),
      pw.Text(data.summary),
      pw.SizedBox(height: 20),
      _buildSectionTitle('Experience'),
      ...data.experience.map((exp) => _buildExperienceItem(exp)),
      pw.SizedBox(height: 20),
      _buildSectionTitle('Skills'),
      _buildSkills(data.skills),
      pw.SizedBox(height: 20),
      _buildSectionTitle('Education'),
      ...data.education.map((edu) => _buildEducationItem(edu)),
    ];
  }

  List<pw.Widget> _buildExecutiveLayout(ResumeData data) {
    // Executive: Traditional, serif-like feel (using standard fonts), dense
    return _buildProfessionalLayout(
      data,
    ); // Re-use professional for now but could be denser
  }

  List<pw.Widget> _buildTechnicalLayout(ResumeData data) {
    // Technical: Skills first
    return [
      _buildHeader(data.personalDetails),
      pw.SizedBox(height: 20),
      _buildSectionTitle('Technical Skills'),
      _buildSkills(data.skills),
      pw.SizedBox(height: 20),
      _buildSectionTitle('Professional Experience'),
      ...data.experience.map((exp) => _buildExperienceItem(exp)),
      pw.SizedBox(height: 20),
      _buildSectionTitle('Projects'),
      ...data.projects.map((proj) => _buildProjectItem(proj)),
      pw.SizedBox(height: 20),
      _buildSectionTitle('Education'),
      ...data.education.map((edu) => _buildEducationItem(edu)),
    ];
  }

  // --- Helper Widgets for Styles ---

  pw.Widget _buildModernSectionTitle(String title, PdfColor color) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title.toUpperCase(),
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
            color: color,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Container(height: 2, width: 40, color: color),
        pw.SizedBox(height: 8),
      ],
    );
  }

  pw.Widget _buildMinimalistSectionTitle(String title) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title.toUpperCase(),
          style: pw.TextStyle(
            fontSize: 12,
            fontWeight: pw.FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        pw.SizedBox(height: 8),
      ],
    );
  }

  pw.Widget _buildHeader(PersonalDetails details) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          details.fullName.toUpperCase(),
          style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(details.email),
            pw.Text(details.phone),
            pw.Text(details.location),
          ],
        ),
        pw.SizedBox(height: 4),
        pw.Row(
          children: [
            if (details.linkedinUrl.isNotEmpty) ...[
              pw.Text(
                'LinkedIn: ${details.linkedinUrl}',
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.blue),
              ),
              pw.SizedBox(width: 16),
            ],
            if (details.portfolioUrl.isNotEmpty)
              pw.Text(
                'Portfolio: ${details.portfolioUrl}',
                style: const pw.TextStyle(fontSize: 10, color: PdfColors.blue),
              ),
          ],
        ),
        pw.SizedBox(height: 8),
        pw.Wrap(
          spacing: 16,
          children: [
            if (details.currentRole.isNotEmpty)
              pw.Text(
                'Role: ${details.currentRole}',
                style: const pw.TextStyle(fontSize: 10),
              ),
            if (details.totalExperience.isNotEmpty)
              pw.Text(
                'Exp: ${details.totalExperience}',
                style: const pw.TextStyle(fontSize: 10),
              ),
            if (details.noticePeriod.isNotEmpty)
              pw.Text(
                'Notice: ${details.noticePeriod}',
                style: const pw.TextStyle(fontSize: 10),
              ),
          ],
        ),
        pw.Divider(thickness: 1),
      ],
    );
  }

  pw.Widget _buildSectionTitle(String title) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title.toUpperCase(),
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            color: PdfColors.grey800,
          ),
        ),
        pw.Divider(thickness: 0.5, color: PdfColors.grey400),
        pw.SizedBox(height: 8),
      ],
    );
  }

  pw.Widget _buildExperienceItem(Experience exp) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                exp.jobTitle,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                '${exp.startDate} - ${exp.endDate}',
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey700,
                ),
              ),
            ],
          ),
          pw.Text(
            exp.company,
            style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 4),
          pw.Text(exp.description, style: const pw.TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  pw.Widget _buildEducationItem(Education edu) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                edu.institution,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                '${edu.startDate} - ${edu.endDate}',
                style: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColors.grey700,
                ),
              ),
            ],
          ),
          pw.Text(edu.degree, style: const pw.TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  pw.Widget _buildSkills(List<String> skills) {
    return pw.Wrap(
      spacing: 8,
      runSpacing: 4,
      children: skills
          .map(
            (skill) => pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: pw.BorderRadius.circular(4),
              ),
              child: pw.Text(skill, style: const pw.TextStyle(fontSize: 10)),
            ),
          )
          .toList(),
    );
  }

  pw.Widget _buildProjectItem(Project proj) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 12),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                proj.title,
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              if (proj.link.isNotEmpty)
                pw.Text(
                  proj.link,
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.blue,
                  ),
                ),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Text(proj.description, style: const pw.TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  pw.Widget _buildLanguages(List<Language> languages) {
    return pw.Wrap(
      spacing: 16,
      children: languages
          .map(
            (lang) => pw.Text(
              '${lang.name} (${lang.proficiency})',
              style: const pw.TextStyle(fontSize: 10),
            ),
          )
          .toList(),
    );
  }

  pw.Widget _buildCertificationItem(Certification cert) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            cert.name,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
          ),
          pw.Text(
            '${cert.issuer} - ${cert.date}',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
        ],
      ),
    );
  }
}
