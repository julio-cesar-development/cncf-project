# ansible
ansible all -m ping
ansible all -m shell -a "uptime"

# random password for admin user on Harbor
export HARBOR_ADMIN=3kjDqy7TDs6iHr6IL


ansible-playbook registry-playbook.yml
ansible-playbook registry-playbook.yml -v

ansible-playbook kubernetes-playbook.yml
ansible-playbook kubernetes-playbook.yml -v


# ansible config precedence
# ANSIBLE_CONFIG (environment variable if set)
# ansible.cfg (in the current directory)
# ~/.ansible.cfg (in the home directory)
# /etc/ansible/ansible.cfg

# SSH
pushd ./terraform/

# terraform fmt -write=true -recursive

# terraform apply -auto-approve
# terraform refresh
# terraform destroy -auto-approve

# terraform show
# terraform graph


# access registry
ssh -i cncf_key root@$(terraform output do-registry-instance-ipv4-address)

ssh -i cncf_key root@$(terraform output do-registry-instance-ipv4-address) -a "apt-get update -yqq && apt-get install -yqq python-minimal"

# docker login -u admin -p $HARBOR_PASSWORD registry.ondo.${FQDN}
# echo "$HARBOR_PASSWORD" | docker login -u "admin" --password-stdin registry.ondo.${FQDN}

# PROJECT_NAME=test
# docker tag SOURCE_IMAGE[:TAG] registry.ondo.${FQDN}/${PROJECT_NAME}/IMAGE[:TAG]
# docker push registry.ondo.${FQDN}/${PROJECT_NAME}/IMAGE[:TAG]


# access front-proxy
terraform output do-front-proxy-instance-ipv4-address

ssh -i cncf_key root@$(terraform output do-front-proxy-instance-ipv4-address)
ssh -i cncf_key root@$(terraform output do-front-proxy-instance-ipv4-address) -a "journalctl --unit envoy.service"


# get IPs from node
terraform output do-node-instance-ipv4-address-0
terraform output do-node-instance-ipv4-address-1


# get IPs from master
terraform output do-master-instance-ipv4-address-0

ssh -i cncf_key root@$(terraform output do-master-instance-ipv4-address-0)


# copy certs (registry.ondo.blackdevs.com.br)
aws s3 cp ./certs/cert.pem s3://blackdevs-aws/terraform/cncf-project/registry.ondo.blackdevs.com.br/cert.pem
aws s3 cp ./certs/chain.pem s3://blackdevs-aws/terraform/cncf-project/registry.ondo.blackdevs.com.br/chain.pem
aws s3 cp ./certs/fullchain.pem s3://blackdevs-aws/terraform/cncf-project/registry.ondo.blackdevs.com.br/fullchain.pem
aws s3 cp ./certs/privkey.pem s3://blackdevs-aws/terraform/cncf-project/registry.ondo.blackdevs.com.br/privkey.pem

aws s3 ls s3://blackdevs-aws/terraform/cncf-project/registry.ondo.blackdevs.com.br/


aws s3 cp ./terraform.tfvars s3://blackdevs-aws/terraform/cncf-project/terraform.tfvars


aws s3 cp ./cncf_key s3://blackdevs-aws/terraform/cncf-project/cncf_key
aws s3 cp ./cncf_key.pub s3://blackdevs-aws/terraform/cncf-project/cncf_key.pub


# remove from known_hosts
# ssh-keygen -R $(terraform output do-master-instance-ipv4-address-0)


# copy kubeconfig from master
scp -i cncf_key root@$(terraform output do-master-instance-ipv4-address-0):~/.kube/config ./kubeconfig
export KUBECONFIG=$PWD/kubeconfig


# inject inject sidecars on some Kubernetes objects
linkerd inject [FILE].yaml | kubectl apply -f -
