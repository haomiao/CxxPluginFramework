cmake_minimum_required(VERSION 3.16)

add_subdirectory(tutorial)

set(APPS_PROJECTS
	 tutorial
)

set_target_properties(
	${APPS_PROJECTS}
	PROPERTIES FOLDER "apps"
)
