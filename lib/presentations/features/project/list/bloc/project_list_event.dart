part of 'project_list_bloc.dart';

abstract class ProjectListEvent {
  const ProjectListEvent();
}

class ProjectRequested extends ProjectListEvent {}
