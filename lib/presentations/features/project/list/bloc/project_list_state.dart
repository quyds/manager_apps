part of 'project_list_bloc.dart';

enum ProjectRequest {
  unknown,
  requestInProgress,
  requestSuccess,
  requestFailure,
}

class ProjectListState {
  const ProjectListState({
    this.projects = const [],
    this.projectStatus = ProjectRequest.unknown,
    this.projectId = const {},
    this.imageList = const [],
  });

  final List? projects;
  final ProjectRequest projectStatus;
  final Set<int> projectId;
  final List<String>? imageList;

  ProjectListState copyWith({
    List? projects,
    ProjectRequest? projectStatus,
    Set<int>? projectId,
    List<String>? imageList,
  }) =>
      ProjectListState(
        projects: projects ?? this.projects,
        projectStatus: projectStatus ?? this.projectStatus,
        projectId: projectId ?? this.projectId,
        imageList: imageList ?? this.imageList,
      );
}
