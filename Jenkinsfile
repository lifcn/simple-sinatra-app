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
}
