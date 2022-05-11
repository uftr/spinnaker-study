node {
	stage('Checkout') {
		checkout scm
	}
	stage('Build Project') {
      sh './mvnw clean package'
	}
	stage("Archiving debian package artifact") {
		archiveArtifacts artifacts: 'target/*.deb'
	}
	stage('Build Container') {
		docker.build('${JOB_NAME}', '-f src/main/docker/Dockerfile.jvm .')
	}
	stage('Create tar.gz') {
       sh 'tar -czvf quarkus-microservice-chart.tar.gz -C helm quarkus-microservice'
       archiveArtifacts artifacts: 'quarkus-microservice-chart.tar.gz', fingerprint: true
	}
	stage('Push chart to S3') {
	    withAWS(region:'us-west-2') {
          s3Upload(file:'quarkus-microservice-chart.tar.gz', bucket:'opstree-helm-charts', path:"${JOB_NAME}/${BUILD_ID}/quarkus-microservice-chart.tar.gz")
        }
	}
	stage('Publish deb to Nexus ') {
	   withCredentials([usernamePassword(credentialsId: 'nexus_passphrase', passwordVariable: 'NEXUS_PASSWORD', usernameVariable: 'NEXUS_ADMIN')]) {
           sh "echo ${NEXUS_PASSWORD}"
           sh "curl -u ${NEXUS_ADMIN}:${NEXUS_PASSWORD} -H 'Content-Type: multipart/form-data' --data-binary '@./target/spinnaker-study_1.27_all.deb' 'http://nexus.mygurukulam.org:8081/repository/mild-temper-microservice/'"
       }
	}
	stage('Write properties') {
	    sh "> spinnaker.properties"
	    sh "echo 'JOB_NAME=${JOB_NAME}' >> spinnaker.properties"
	    sh "echo 'BUILD_ID=${BUILD_ID}' >> spinnaker.properties"
	    archiveArtifacts artifacts: 'spinnaker.properties', fingerprint: true
	}
	stage("Updating ECR login token") {
		sh "aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 702037529261.dkr.ecr.us-west-2.amazonaws.com"
	}
	stage('Push to ECR') {
		docker.withRegistry('https://702037529261.dkr.ecr.us-west-2.amazonaws.com', '') {
			docker.image('${JOB_NAME}').push('${BUILD_ID}')
	   }
	}
	stage("Building Terraform Code Image") {
		dir("terraform") {
			docker.build('${JOB_NAME}-terraform', '-f Dockerfile .')
		}
	}
	stage("Pushing Terraform Image to ECR") {
		docker.withRegistry('https://702037529261.dkr.ecr.us-west-2.amazonaws.com', '') {
			docker.image('${JOB_NAME}-terraform').push('${BUILD_ID}')
	   }
	}
}
