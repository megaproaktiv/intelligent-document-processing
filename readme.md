# Automated intelligent document processing

## Setup



### Suffix
The suffix is needed because s3 bucket names must be unique.
You make it unique by adding the suffix. That can be any string which
consists more than 3 characters.

If in doubt: Use AWS accountnumber - Region

### Region

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

```bash
task upload
```

```bash
task check-dynamodb
```
### 6 Clean up

```bash
task destroy
```
