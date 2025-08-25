// Configure repositories for all projects
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

subprojects {
    // Ensure app project is evaluated first
    project.evaluationDependsOn(":app")
}

// Register clean task
tasks.register<Delete>("clean") {
    delete(rootProject.buildDir)
}
