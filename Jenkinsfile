pipeline 
{ 
  agent any

  options {
        disableConcurrentBuilds()
  }


  environment {
    amiNameTag = ""
    amiNameTagValue = "";
    thisTestNameVar = "";
    thisTestValue = "blue_green_deployment";
    ProjectName = "petclinic-spring";
    fileProperties = "file.properties"
    old_environment = "";
  }

  stages {

   stage('Get Blue-Green Deployment Repo')
   {
      steps {
        echo "Getting Exploratory Testing Repo"
        git(
        url:'git@github.com:ochoadevops/petclinic-blue-green.git',
        credentialsId: 'blue-and-green',
        branch: "main"
        )
     }

	   
   }


   stage('Read Properties File') {
      steps {
        script {

           copyArtifacts(projectName: "${ProjectName}");
           props = readProperties file:"${fileProperties}";

           this_group = props.Group;
           this_version = props.Version;
           this_artifact = props.ArtifactId;
           this_full_build_id = props.FullBuildId;
           this_jenkins_build_id = props.JenkinsBuildId;
        }


        sh "echo Finished setting this_group = $this_group"
        sh "echo Finished setting this_version = $this_version"
        sh "echo Finished setting this_artifact = $this_artifact"
        sh "echo Finished setting this_full_build_id = $this_full_build_id"
        sh "echo Finished setting this_jenkins_build_id = $this_jenkins_build_id"

      }
    }


      stage('SELECT DEPLOYMENT ENVIRONMENT - INPUT REQUIRED')
      {
        steps
        {
           echo "Starting --- deployment" 
           sh 'pwd'
           script {
              env.DEPLOY_TO = input message: 'Please select environment location to deploy', parameters: [choice(name: 'Environments Available', choices: 'BLUE\nGREEN', description: 'WARNING: Before deploying release, the selected environment will be replaced with the new deployment' )]
           }
           echo "Selected Environment to Deploy:  "
           echo "${env.DEPLOY_TO}"
        }
      }



      stage('Deploying VPC')
      {
        steps
        {
           echo "Starting VPC Deployment --- terraform deploy and start"

           sh 'pwd'
           dir('./production')
           {
              script {
                 sh 'pwd'

                 echo "Checking if terraform s3 boostrap bucket for vpc environment exists"

                 // Check if bucket exists before creating it. This is used by terraform to save the state file
                 aws_list_bucket = "aws s3api list-buckets --query \"Buckets[].Name\" | grep \"01-production\" | awk '{print \$1}'  | awk '{print substr(\$1,2); }' | awk '{print substr(\$1, 1, length(\$1)-2)}'"

                 echo "aws_list_bucket string is: $aws_list_bucket"

                 def bucketResult; 
                 bucketResult = sh (returnStdout: true, script: "eval ${aws_list_bucket}");

                 // Remove blank lines from result
                 bucketResult = bucketResult.replaceAll("[\r\n]+","");

                 echo "bucket result is:"
                 echo "'$bucketResult'"
                 echo "done printing"
                

                 if ("$bucketResult".toString().equals("01-production")) {  
                    echo "terraform bucket already exists."
                 } else {
                    sh 'aws s3 mb s3://01-production --region us-west-1'
                    echo "Created terraform bucket."
                 }


                 echo "update terraform variables "

                 amiNameTagValue = "$this_artifact" + "-" + "$this_jenkins_build_id";
                 amiNameTag = "build_id=\"" + "$amiNameTagValue" + "\"";
                 thisTestNameVar = "test-name=\"" + "$thisTestValue" + "\"";

                 def readContent = readFile 'terraform.tfvars'
                 writeFile file: 'terraform.tfvars', text: readContent+"\n$amiNameTag"+"\n$thisTestNameVar"

                 sh 'pwd'
                 sh 'ls -l'
                 sh '/usr/local/bin/terraform init -input=false'
                 sh '/usr/local/bin/terraform plan'
                 sh '/usr/local/bin/terraform apply -auto-approve'
              
              }
           }


        }
      }


      stage('Deploying Environment')
      {
        steps
        {
           echo "Starting --- terraform deploy and start"

           sh 'pwd'
           dir("${env.DEPLOY_TO}")
           {
              script {
                 sh 'pwd'

                 deployToLC = env.DEPLOY_TO.toLowerCase();

                 echo "Checking if terraform s3 boostrap bucket for ${deployToLC} environment exists"

                 // Check if bucket exists before creating it. This is used by terraform to save the state file
                 aws_list_bucket = "aws s3api list-buckets --query \"Buckets[].Name\" | grep \"01-prod-${deployToLC}\" | awk '{print \$1}'  | awk '{print substr(\$1,2); }' | awk '{print substr(\$1, 1, length(\$1)-2)}'"


                 echo "aws_list_bucket string is: $aws_list_bucket"

                 def bucketResult;
                 bucketResult = sh (returnStdout: true, script: "eval ${aws_list_bucket}");
                 // Remove blank lines from result
                 bucketResult = bucketResult.replaceAll("[\r\n]+","");

                 echo "bucket result is:"
                 echo "'$bucketResult'"
                 echo "done printing"
               
                 def s3BucketName = "01-prod-${deployToLC}" 
                 echo "s3BucketName name is:"
                 echo "'$s3BucketName'"

		 if ("$bucketResult".toString().equals("$s3BucketName".toString())) {  
                    echo "terraform bucket already exists."
                 } else {
                    sh 'aws s3 mb s3://"$s3BucketName".toString() --region us-west-1'
                    echo "Created terraform bucket."
                 }


                 echo "update terraform variables "
                 sh 'pwd'

                 amiNameTagValue = "$this_artifact" + "-" + "$this_jenkins_build_id";
                 amiNameTag = "build_id=\"" + "$amiNameTagValue" + "\"";
                 thisTestNameVar = "test-name=\"" + "$thisTestValue" + "\"";

                 def readContent = readFile 'terraform.tfvars'
                 writeFile file: 'terraform.tfvars', text: readContent+"\n$amiNameTag"+"\n$thisTestNameVar"

                 sh 'pwd'
                 sh 'ls -l'
                 sh '/usr/local/bin/terraform init -input=false'
                 sh '/usr/local/bin/terraform plan'
                 try {
                    sh '/usr/local/bin/terraform apply -auto-approve'
                 } catch (err) {
                    sh '/usr/local/bin/terraform apply -auto-approve'
                 }
              
              }
           }


        }
      }

      stage('Destroy Environment - INPUT REQUIRED')
      {
        steps
        {
           echo "Starting --- terraform deploy and start"

           sh 'pwd'
           script {
          
              if (env.DEPLOY_TO == "GREEN") {  
                 old_environment = "BLUE"
                 echo "setting old_environment to: $old_environment"
              } else {
                 old_environment = "GREEN"
                 echo "setting old_environment to: $old_environment"
              }

              this_input_message = "Do you want to destroy the $old_environment environment?"
              this_warning_message = "WARNING: The $old_environment environment will be destroy"

              env.Destroy_Environment = input message: "$this_input_message", parameters: [choice(name: 'Please select', choices: 'NO\nYES', description: "$this_warning_message" )]

              echo "Destroy Environment:  "
              echo "${env.Destroy_Environment}"

              if (env.Destroy_Environment == "YES") {  
                 dir("$old_environment")
                 {
                    sh 'pwd'

                   // Terraform fails if it is unable to retrieve the amiName from the data, even though it does not need it,
                   // because this is a destroy call. 
                   def readContent = readFile 'terraform.tfvars'
                   writeFile file: 'terraform.tfvars', text: readContent+"\n$amiNameTag"+"\n$thisTestNameVar"

                   echo "Test completed, destroying environment"
                   sh '/usr/local/bin/terraform destroy -auto-approve'
                 }
              } 
              echo "Done with stage" 
           }
        }
      }


  }

 }

