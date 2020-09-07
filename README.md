Note,
    The stack lifts a cluster of kubernetes running mediawiki versioned by bitnami
    
    *. Requires a domain running on AWS
    *. Requires ssl certificates issued by AWS

Process:

1. Install VirtualBox

2. Install Ansible

3. Decompress the file kops-lab.tar.gz

4. kops-lab cd

5. Configure domain and region on terraform
    - 5.1 Edit the file: provision/terraform/terraform.tfvars and change credentials and domain
        aws_access_key = "your_access_key_id"
        aws_secret_key = "your_secret_key"
        aws_region = "your-region
        kubernetes_states_bucket = "kubecluster-state-store.domain.com" # change 'domain' for the domain
        domain_name = "domain.com or *.domain.com" # As listed in the Amazon Certificate Manager dashboard

6. Configure Ansible vars.
    - 6.1 Edit the file: provision/ansible/vars.yml
        1. Declare the bucket created by terraform with the same name of the variable declared in terraform.tfvars
        kops_create_cluster_state: "s3://kubecluster-state-store.domain.com"
        2. Declare the region where the cluster is raised, it has to coincide with the region declared in terraform.tfvars
        aws_region: "your_region
        3. Declare the bucket created by terraform without the prefix s3://
        kubernetes_states_bucket: "kubecluster-state-store.domain.com"
        4. Declare the DNS zone as it appears in Route53
        dns_base: "domain.com"
        5. Declare a domain for the k8s service to be implemented declared in provision/transfer/templates
        service_domain: "mediawiki.domain.com"
        6. Declare again the region where the cluster is implemented
        main_region: "your_region

7. Lift the VM environment from the project root directory and create the kubernetes stack
    - 7.1 Lifting the virtual machine
        vagrant up

    - 7.2 Changing permissions of the key you use to connect to the virtual machine
        chmod 0400 ssh-cfg/insecure_private_key

    - 7.3 Verify ansible connectivity with the created vm
        ansible all -m ping

    - 7.4 If there are no errors when executing ping to vm, we can raise the cluster by executing:
        ansible-playbook provision/ansible/main_playbook.yml

    - 7.5 Once the process is completed and if there were no errors, you can verify the installation by accessing the url:
        service_domain: "mediawiki.domain.com"
        login:
                - wikilogin: "wiki_user" # variable declared in vars.yml
                - wikiloginpass: "wiki_user2020" # variable declared in vars.yml

8. Access to the cluster by console. All the tools are installed in the VM.
    - 8.1 vagrant ssh

    8.2 Setting up an environment to connect to AWS
      -  export AWS_ACCESS_KEY_ID=SARASARASA123
      -  export AWS_SECRET_ACCESS_KEY=s1A2R3a4S5a/ToDOz1A2R3a4Z5a0tr9
      -  export AWS_REGION=xx-sarasa-1

    8.3 Operating the cluster
       - kubectl get pods -o wide (e.g.)

9. Access to the cluster by dashboard. (via local proxy)
    - 9.1 URL
    http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/login

   -  9.2 Obtaining the TOKEN
        - run: vagrant ssh
        - run: cat /hostSharedData/kops-files/dashboard-admin-token-log

10. Clean up kubernetes stack
    - 10.1 Setting up environment to connect to AWS
        - export AWS_ACCESS_KEY_ID=SARASARASA123
        - export AWS_SECRET_ACCESS_KEY=s1A2R3a4S5a/ToDOz1A2R3a4Z5a0tr9
        - export AWS_REGION=xx-sarasa-1

    - 10.2 Removing the cluster
        - kops delete cluster --name {{ cluster_name }} --state "{{ cluster_bucket }}" --yes

            - cluster_name: value of the variable 'kops_create_cluster_name' in vars.yml
            - cluster_bucket: value of the variable 'kops_create_cluster_state' in vars.yml

    - 10.3 Removing resources created by terraform
        - cd /hostSharedData/terraform
        - terraform destroy

    - 10.4 Delete keys and generated data:
       - rm -fr /hostSharedData/kops-files
       - rm -fr /hostSharedData/terraform/ssh-keys
       - rm -fr /hostSharedData/terraform/.terraform
       - rm -fr /hostSharedData/terraform/terraform.tfstate
       - rm -fr /hostSharedData/terraform/terraform.tfstate.backup

    - 10.5 Enter route53 and delete the automatically generated domain declared in the variable 'service_domain
        - from vars.yml configuration file

Translated with www.DeepL.com/Translator (free version)
