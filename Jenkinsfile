pipeline {
  agent any
    stages {
      stage("Build") {
        steps {
          sh './build_helloworld.sh'
        }
      }
      stage("Test") {
        steps {
          sh './test_helloworld.sh'
        }  
      }
    }
  post {
    always {
      mail to: 'lifcn@yahoo.com',
        subject: "Completed Pipeline: ${currentBuild.fullDisplayName}",
          body: "Your build completed, please check: ${env.BUILD_URL}"
    }
  }
}
