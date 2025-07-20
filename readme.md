# Automated intelligent document processing

# Setup



## Suffix
The suffix is needed because s3 bucket names must be unique.
You make it unique by adding the suffix. That can be any string which
consists more than 3 characters.

If in doubt: Use AWS accountnumber - Region

## Region

Your AWS region. Most examples from AWS  use us-east-1.
Update with our region.

### Model ID

ID a a Bedrock Model, to which you have access.
Look in the AWS console.



## Lifecycle

### 0 Configuration

```bash
vi config.tfvars
```

### 1 Create infrastructure

Create all resources and lambda code

```bash
task init
task update-all-lambdas
task plan
task apply
```

### 2 Look at dynamodb table

```bash
task check-dynamodb
```

### 3 Test

- When the Lambda logs are displayed,
hit enter a few times to seperate old entries.

- After the two images are processed from the
first lambda, perss ^c  to see the next Lambda log.

```bash
task upload
```

### 4 Check Table items

```bash
task check-dynamodb
```

### 5 Clean up

```bash
task destroy
```

### 6 Cleanup Terraform

```bash
rm -rf .terraform
rm  .terraform.lock.hcl
rm terraform.tfstate
rm terraform.tfstate.backup
```
