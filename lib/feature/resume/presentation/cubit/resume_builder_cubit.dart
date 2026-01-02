import 'package:blog_app/core/constants/ai_constants.dart';
import 'package:blog_app/core/secrets/app_secrets.dart';
import 'package:blog_app/feature/resume/data/datasources/resume_local_datasource.dart';
import 'package:blog_app/feature/resume/data/models/resume_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_generative_ai/google_generative_ai.dart' hide Language;

// State
abstract class ResumeBuilderState {}

class ResumeBuilderInitial extends ResumeBuilderState {}

class ResumeBuilderLoading extends ResumeBuilderState {}

class ResumeBuilderLoaded extends ResumeBuilderState {
  final ResumeData resumeData;
  final int currentStep;
  final bool isSaving;

  ResumeBuilderLoaded({
    required this.resumeData,
    required this.currentStep,
    this.isSaving = false,
  });

  ResumeBuilderLoaded copyWith({
    ResumeData? resumeData,
    int? currentStep,
    bool? isSaving,
  }) {
    return ResumeBuilderLoaded(
      resumeData: resumeData ?? this.resumeData,
      currentStep: currentStep ?? this.currentStep,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class ResumeBuilderError extends ResumeBuilderState {
  final String message;

  ResumeBuilderError(this.message);
}

// Cubit
class ResumeBuilderCubit extends Cubit<ResumeBuilderState> {
  final ResumeLocalDataSource _localDataSource;

  ResumeBuilderCubit(this._localDataSource) : super(ResumeBuilderInitial()) {
    loadResume();
  }

  Future<void> loadResume() async {
    emit(ResumeBuilderLoading());
    try {
      final savedResume = await _localDataSource.loadResume();
      if (savedResume != null) {
        emit(ResumeBuilderLoaded(resumeData: savedResume, currentStep: 0));
      } else {
        // Initialize with empty data
        emit(
          ResumeBuilderLoaded(
            resumeData: ResumeData(
              personalDetails: PersonalDetails(
                fullName: '',
                email: '',
                phone: '',
                linkedinUrl: '',
                githubUrl: '',
                portfolioUrl: '',
                location: '',
                currentRole: '',
                totalExperience: '',
                currentCtc: '',
                expectedCtc: '',
                noticePeriod: '',
                preferredLocations: [],
                openToRelocate: false,
              ),
              summary: '',
              experience: [],
              education: [],
              skills: [],
              projects: [],
              languages: [],
              certifications: [],
            ),
            currentStep: 0,
          ),
        );
      }
    } catch (e) {
      emit(ResumeBuilderError(e.toString()));
    }
  }

  Future<void> saveResume() async {
    if (state is ResumeBuilderLoaded) {
      final currentState = state as ResumeBuilderLoaded;
      emit(currentState.copyWith(isSaving: true));
      try {
        await _localDataSource.saveResume(currentState.resumeData);
        emit(currentState.copyWith(isSaving: false));
      } catch (e) {
        emit(ResumeBuilderError(e.toString()));
        // Re-emit loaded state after error
        emit(currentState.copyWith(isSaving: false));
      }
    }
  }

  void updatePersonalDetails(PersonalDetails details) {
    if (state is ResumeBuilderLoaded) {
      final currentState = state as ResumeBuilderLoaded;
      emit(
        currentState.copyWith(
          resumeData: currentState.resumeData.copyWith(
            personalDetails: details,
          ),
        ),
      );
    }
  }

  void updateSummary(String summary) {
    if (state is ResumeBuilderLoaded) {
      final currentState = state as ResumeBuilderLoaded;
      emit(
        currentState.copyWith(
          resumeData: currentState.resumeData.copyWith(summary: summary),
        ),
      );
    }
  }

  void updateStyle(String style) {
    if (state is ResumeBuilderLoaded) {
      final currentState = state as ResumeBuilderLoaded;
      emit(
        currentState.copyWith(
          resumeData: currentState.resumeData.copyWith(resumeStyle: style),
        ),
      );
    }
  }

  Future<String?> generateAiEnhancedResume() async {
    if (state is! ResumeBuilderLoaded) return 'Resume data not loaded';
    final currentState = state as ResumeBuilderLoaded;

    try {
      final currentDataJson = currentState.resumeData.toJson();
      final prompt =
          '''
${AiConstants.systemInstruction}

Here is the current resume data in JSON format:
$currentDataJson

Please enhance this resume data according to the instructions and return the JSON.
''';

      final content = [Content.text(prompt)];

      final modelsToTry = [
        'gemini-1.5-flash',
        'gemini-1.5-flash-latest',
        'gemini-1.5-flash-001',
        'gemini-1.5-pro',
        'gemini-1.5-pro-001',
      ];
      GenerateContentResponse? response;
      List<String> errorMessages = [];

      for (final modelName in modelsToTry) {
        try {
          // ignore: avoid_print
          print('Attempting AI generation with model: $modelName');

          final model = GenerativeModel(
            model: modelName,
            apiKey: AppSecrets.geminiApiKey,
            generationConfig: GenerationConfig(
              responseMimeType: 'application/json',
            ),
            safetySettings: [
              SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
              SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
              SafetySetting(
                HarmCategory.sexuallyExplicit,
                HarmBlockThreshold.none,
              ),
              SafetySetting(
                HarmCategory.dangerousContent,
                HarmBlockThreshold.none,
              ),
            ],
          );

          response = await model.generateContent(content);
          if (response.text != null) {
            break; // Success
          }
        } catch (e) {
          final errorMsg = 'Model $modelName failed: $e';
          errorMessages.add(errorMsg);
          // ignore: avoid_print
          print('Model $modelName failed: $e');
          continue; // Try next
        }
      }

      if (response?.text != null) {
        String jsonString = response!.text!;

        // Robust JSON extraction: Find the first '{' and last '}'
        final startIndex = jsonString.indexOf('{');
        final endIndex = jsonString.lastIndexOf('}');

        if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
          jsonString = jsonString.substring(startIndex, endIndex + 1);
        } else {
          throw const FormatException('No valid JSON object found in response');
        }

        var enhancedData = ResumeData.fromJson(jsonString.trim());

        // Preserve the style selected by user
        enhancedData = enhancedData.copyWith(
          resumeStyle: currentState.resumeData.resumeStyle,
        );

        emit(currentState.copyWith(resumeData: enhancedData));
        await _localDataSource.saveResume(enhancedData);
        return null; // Success
      }

      final allErrors = errorMessages.join('\n\n');
      return allErrors.isNotEmpty ? allErrors : 'Empty response from AI';
    } catch (e) {
      // Log error internally but return false so UI knows
      // ignore: avoid_print
      print('AI Enhancement failed: $e'); // Make sure this is visible in logs
      emit(ResumeBuilderError('AI Enhancement failed: $e'));
      emit(currentState); // Restore state
      return e.toString();
    }
  }

  void addExperience(Experience experience) {
    if (state is ResumeBuilderLoaded) {
      final currentState = state as ResumeBuilderLoaded;
      final updatedList = List<Experience>.from(
        currentState.resumeData.experience,
      )..add(experience);
      emit(
        currentState.copyWith(
          resumeData: currentState.resumeData.copyWith(experience: updatedList),
        ),
      );
    }
  }

  void removeExperience(int index) {
    if (state is ResumeBuilderLoaded) {
      final currentState = state as ResumeBuilderLoaded;
      final updatedList = List<Experience>.from(
        currentState.resumeData.experience,
      )..removeAt(index);
      emit(
        currentState.copyWith(
          resumeData: currentState.resumeData.copyWith(experience: updatedList),
        ),
      );
    }
  }

  void addEducation(Education education) {
    if (state is ResumeBuilderLoaded) {
      final currentState = state as ResumeBuilderLoaded;
      final updatedList = List<Education>.from(
        currentState.resumeData.education,
      )..add(education);
      emit(
        currentState.copyWith(
          resumeData: currentState.resumeData.copyWith(education: updatedList),
        ),
      );
    }
  }

  void removeEducation(int index) {
    if (state is ResumeBuilderLoaded) {
      final currentState = state as ResumeBuilderLoaded;
      final updatedList = List<Education>.from(
        currentState.resumeData.education,
      )..removeAt(index);
      emit(
        currentState.copyWith(
          resumeData: currentState.resumeData.copyWith(education: updatedList),
        ),
      );
    }
  }

  void updateSkills(List<String> skills) {
    if (state is ResumeBuilderLoaded) {
      final currentState = state as ResumeBuilderLoaded;
      emit(
        currentState.copyWith(
          resumeData: currentState.resumeData.copyWith(skills: skills),
        ),
      );
    }
  }

  void addProject(Project project) {
    if (state is ResumeBuilderLoaded) {
      final currentState = state as ResumeBuilderLoaded;
      final updatedList = List<Project>.from(currentState.resumeData.projects)
        ..add(project);
      emit(
        currentState.copyWith(
          resumeData: currentState.resumeData.copyWith(projects: updatedList),
        ),
      );
    }
  }

  void removeProject(int index) {
    if (state is ResumeBuilderLoaded) {
      final currentState = state as ResumeBuilderLoaded;
      final updatedList = List<Project>.from(currentState.resumeData.projects)
        ..removeAt(index);
      emit(
        currentState.copyWith(
          resumeData: currentState.resumeData.copyWith(projects: updatedList),
        ),
      );
    }
  }

  void addLanguage(Language language) {
    if (state is ResumeBuilderLoaded) {
      final currentState = state as ResumeBuilderLoaded;
      final updatedList = List<Language>.from(currentState.resumeData.languages)
        ..add(language);
      emit(
        currentState.copyWith(
          resumeData: currentState.resumeData.copyWith(languages: updatedList),
        ),
      );
    }
  }

  void removeLanguage(int index) {
    if (state is ResumeBuilderLoaded) {
      final currentState = state as ResumeBuilderLoaded;
      final updatedList = List<Language>.from(currentState.resumeData.languages)
        ..removeAt(index);
      emit(
        currentState.copyWith(
          resumeData: currentState.resumeData.copyWith(languages: updatedList),
        ),
      );
    }
  }

  void addCertification(Certification certification) {
    if (state is ResumeBuilderLoaded) {
      final currentState = state as ResumeBuilderLoaded;
      final updatedList = List<Certification>.from(
        currentState.resumeData.certifications,
      )..add(certification);
      emit(
        currentState.copyWith(
          resumeData: currentState.resumeData.copyWith(
            certifications: updatedList,
          ),
        ),
      );
    }
  }

  void removeCertification(int index) {
    if (state is ResumeBuilderLoaded) {
      final currentState = state as ResumeBuilderLoaded;
      final updatedList = List<Certification>.from(
        currentState.resumeData.certifications,
      )..removeAt(index);
      emit(
        currentState.copyWith(
          resumeData: currentState.resumeData.copyWith(
            certifications: updatedList,
          ),
        ),
      );
    }
  }

  void nextStep() {
    if (state is ResumeBuilderLoaded) {
      final currentState = state as ResumeBuilderLoaded;
      emit(currentState.copyWith(currentStep: currentState.currentStep + 1));
    }
  }

  void previousStep() {
    if (state is ResumeBuilderLoaded) {
      final currentState = state as ResumeBuilderLoaded;
      if (currentState.currentStep > 0) {
        emit(currentState.copyWith(currentStep: currentState.currentStep - 1));
      }
    }
  }

  void goToStep(int step) {
    if (state is ResumeBuilderLoaded) {
      final currentState = state as ResumeBuilderLoaded;
      emit(currentState.copyWith(currentStep: step));
    }
  }
}
