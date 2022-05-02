pipeline {
	agent any

	stages {
		stage('checkout') {
			steps {
				git branch: 'main', credentialsId: 'a8ef9923-c60f-4975-a3c0-93ef9acbc0fd', url: 'http://gitlab.rkyao.com:8929/yaorongke/docker-demo.git'
			}
		}
		stage('build') {
			steps {
				sh 'sh build.sh harbor.rkyao.com rkyao admin Harbor12345'
			}
		}
		stage('deploy') {
			steps {
				sh 'sh deploy.sh 192.168.73.143'
			}
		}
		stage('cleanWs') {
			steps {
				cleanWs()
			}
		}
	}
}