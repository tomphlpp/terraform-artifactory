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
      

*This is a Terraform module that will be able to do steps 2, 4, and 5. <br>

### We should be able to create these resources with these names: 

![Repo Types Chart with Remotes](path/to/your/image/repo_types_chart_with_remotes.png)

| Type    | Local Resource (Dev)           | Local Resource (Prod)           | Virtual Resource (Dev)           | Virtual Resource (Prod)           | Remote Resource                             |
|---------|--------------------------------|---------------------------------|----------------------------------|----------------------------------|---------------------------------------------|
| Generic | `<team>-generic-dev-local`     | `<team>-generic-prod-local`     | `<team>-generic-dev-virtual`     | `<team>-generic-prod-virtual`    | ??                              |
| Helm    | `<team>-helm-dev-local`        | `<team>-helm-prod-local`        | `<team>-helm-dev-virtual`        | `<team>-helm-prod-virtual`       | [https://charts.helm.sh/stable](https://charts.helm.sh/stable) |
| NPM     | `<team>-npm-dev-local`         | `<team>-npm-prod-local`         | `<team>-npm-dev-virtual`         | `<team>-npm-prod-virtual`        | [https://registry.npmjs.org](https://registry.npmjs.org)         |
| NuGet   | `<team>-nuget-dev-local`       | `<team>-nuget-prod-local`       | `<team>-nuget-dev-virtual`       | `<team>-nuget-prod-virtual`      | [https://api.nuget.org/v3/index.json](https://api.nuget.org/v3/index.json) |
| PyPI    | `<team>-pypi-dev-local`        | `<team>-pypi-prod-local`        | `<team>-pypi-dev-virtual`        | `<team>-pypi-prod-virtual`       | [https://pypi.org/simple](https://pypi.org/simple)               |
| Docker  | `<team>-docker-dev-local`      | `<team>-docker-prod-local`      | `<team>-docker-dev-virtual`      | `<team>-docker-prod-virtual`     | `<team>-docker-remote`                     |


### Module Structure
```
tphilipp@fedora~/artifactory_provisioning$ tree .
.
├── main.tf
├── module
│   ├── ldap
│   ├── permissions
│   │   ├── main.tf
│   │   └── variables.tf
│   └── repositories
│       ├── locals.tf
│       ├── main.tf
│       └── variables.tf
├── provider.tf
├── README.md
├── repos.yaml
├── terraform.tfstate
├── terraform.tfstate.backup
├── terraform.tfvars
├── tfvars_example.txt
└── variables.tf


```

[Terraform's Artifactory Resources](https://registry.terraform.io/providers/jfrog/artifactory/latest/docs)

[Hashicorp YAML decoder](https://developer.hashicorp.com/terraform/language/functions/yamldecode)

