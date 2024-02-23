<H1>README</H1>
<H1>Repo Name: blue_green_deployment </H1>
<P>Purpose: To demostrate how to provision a blue-green deployment using a Jenkinsfile and terraform on AWS.  
</P>

<H1>This repo will:</H1>
<UL>
<LI> Create a new VPC
<LI> Retrieve an existing DNS Zone
<LI> Create VPC gateway
<LI> Create two CIDRS: one for the blue environment and one for the green environment
<LI> Create a complete new BLUE Environment including:
    - Two public subnets
    - Routing tables for the subnets
    - DNS Record to switch between the Blue and Green ELBs
    - A Target Group to route requests from the load balancer to the EC2 instances
    - AutoScaling Group
    - AutoScaling Launch Configuration
<LI> Create a complete new GREEN Environment including:
    - Two public subnets
    - Routing tables for the subnets
    - DNS Reord to switch between the Blue and Green ELBs
    - A Target Group to route requests from the load balancer to the EC2 instances
    - AutoScaling Group
    - AutoScaling Launch Configuration
</UL>

  
  
<H1>Before running this repo on your own environment:</H1>

<UL>
<LI>Update the jenkinsfile to specify your own GitHub Repo URL and name (1 location)
<LI>Add your Jenkins IP webhook to each repo (1 location/optional)
<LI>Update the project domain name in the BLUE/terraform.tfvars (project_domain = "ochoajenkins.com") to reflect your own domain name.
<LI>Update the project domain name in the GREEN/terraform.tfvars (project_domain = "ochoajenkins.com") to reflect your own domain name.
<LI>Update the project domain name in the production/terraform.tfvars (project_domain = "ochoajenkins.com") to reflect your own domain name.
<LI>Update the bucket name is BLUE/bootstrap.tf to reflect a unique bucket name for the blue deployment. e.g. 01-lastname-prod-blue
<LI>Update the bucket name is GREEN/bootstrap.tf to reflect a unique bucket name for the green deployment. e.g. 01-last-name-prod-green
<LI>Update the bucket name is production/bootstrap.tf to reflect a unique bucket name for the blue deployment. e.g. 01-last-name-prod
<LI>Replace the "DevOps" key in the BLUE/ec2_test.tf file with an existing key pair in your AWS account. For example, the Jenkins key pair.
<LI>Replace the "DevOps" key in the GREEN/ec2_test.tf file with an existing key pair in your AWS account. For example, the Jenkins key pair.
</UL>
  
<H1>Assumptions:</H1>
<UL>
<LI>Terraform v0.14 or later is install on the Jenkins server
<LI>The Jenkins Server EC2 instance has an instance role with sufficient permission to provision AWS Resources 
</UL>
  
<H1>How to run</H1>
<UL>
<LI> Create a "Pipeline" Job in Jenkins
<LI> Under the "Pipeline" section, select "Pipeline script from SCM", click on "git" and select your copy of this repo
<LI> Create a ssh-key jenkins credential on your Jenkins Server and select it for this job
<LI> Click apply
<LI> From the Jenkins Menu, select the job
<LI> Click on "build now" from your Jenkins left menu
</UL>
