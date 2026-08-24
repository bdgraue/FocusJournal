// Configure repositories for all projects
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Redirect all Gradle output to <repo>/build, where the Flutter tool looks for
// it. Without this the artifacts land in android/app/build and
// `flutter build appbundle` fails with "Gradle build failed to produce an .aab
// file" — Gradle built it, just somewhere the tool does not search.
// Matches the current Flutter template; `buildDir` is deprecated in favour of
// `layout.buildDirectory`.
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    project.layout.buildDirectory.value(newBuildDir.dir(project.name))
}

subprojects {
    // Ensure app project is evaluated first
    project.evaluationDependsOn(":app")
}

// Register clean task
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
