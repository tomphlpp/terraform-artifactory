## Read a Yaml and provision repos in Artifactory

### Steps to do this manually:

1. Request AD groups for dev and prod if you haven't already
2. <u>Synchronize ad groups in Artifactory*</u>
3. Submit firewall requests
4. <u>Provision repositories*</u><br>
    a. create dev and prod locals:<br>
        **\<team>-\<package_type>-dev-local**<br>
        **\<team>-\<package_type>-prod-local**<br>
    b. UPDATE: each team gets a remote docker repo in their name to avoid scanning everything in dockerhub:<br>
        **\<team>-docker-remote**<br>
        other remote repositories, registry.npm.org for example, get drawn straight in without an Artifactory name.<br>
    c. create virtual repos that include remotes and locals:<br>
        **\<team>-\<package_type>-dev**<br>
          - this should include any remotes and dev locals<br>
        **\<team>-\<package_type>-prod**<br>
          - includes remotes and prod locals<br><br>
    Should be able to provision Docker, Helm, Maven, NPM, Nuget, and Generic repository types<br><br>
5. <u>Add and Update Permissions*</u><br>
    - For dev and prod, add a permission with no users that includes an AD group imported in step 2.<br>
      Example for a dev permission:<br>
      `Name: <team>-dev-users`<br>
      `Add <team>-docker-dev-local`<br>
      `Add <team>-docker-remote`<br>
      `Users: leave empty`<br>
      `Groups: Click "+" and include the AD group for the team: dv_app_artifactory_<team>_users`<br>
      Ensure the group is highlighted and under Repositories, enable the following permissions: Read, Annotate, Deploy/Cache, Delete/Overwrite
<br>
<br>
      

*This is a Terraform module that will be able to do steps 2, 4, and 5. 

### Module Structure
```
.
├── driver
│   ├── main.tf
│   ├── terraform.tfstate
│   ├── terraform.tfstate.backup
│   ├── terraform.tfvars
│   ├── tfvars_example.txt
│   └── variables.tf
├── module
│   ├── ldap
│   ├── permissions
│   │   ├── main.tf
│   │   └── variables.tf
│   └── repositories
│       ├── local_repos.tf
│       ├── locals.tf
│       ├── providers.tf
│       ├── remote_repos.tf
│       ├── variables.tf
│       └── virtual_repos.tf
├── README.md
└── repos.yaml

```

[Terraform's Artifactory Resources](https://registry.terraform.io/providers/jfrog/artifactory/latest/docs)

[Hashicorp YAML decoder](https://developer.hashicorp.com/terraform/language/functions/yamldecode)

