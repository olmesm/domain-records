# Domain Records

Domain Records

**Note:** this runs on a cron job and will remove any manually added records. Please read the directions carefully below.

To add a new record:

1. Fork the Repository.
1. Add the record to [records.yaml](records.yaml) file in the appropriate category. [See Sample Record](#sample-record) below.
1. Raise a PR.
1. This will be reviewed and merged accordingly.

## Sample Record

```yaml
example.com:
  - name: example.com # Name of the Record
    type: A # Type of the Record
    value: 127.0.0.1 # Value of the Record
    # ttl: "1" # Optional: Time to live.
    # proxied: false # Optional: Whether the record gets Cloudflare's origin protection
    # priority: null # Optional: The priority of the record
```

## Deployment

Please rely on the CICD process in Github Actions.

### Implementing in a new Domain

It was not possible to import existing records to tf state and then apply them, this could be fixed in future.

The recommended method for now is as follows:

1. Export current records as a backup from Cloudflare
1. Ensure the terraform state is clean (`terraform state list` and `terraform state rm cloudflare_record.default[...]`)
1. Get all the id's `sh scripts/get-cloudflare-records.sh`
1. Delete the records individually `sh scripts/delete-cloudflare-records.sh <DNS_RECORD_ID>`
1. `terraform apply`

If anything goes wrong, delete the records and restore the backup via cloudflare.

---

## Development

Requires:

- [asdf](https://asdf-vm.com)

```bash
# Add system dependencies
sh scripts/asdf-install.sh

# Copy the .env.example file and fill out the values in the .env
cp .env.example .env

# If first time setup your user
gcloud auth login

# Create a new GCP Terraform service account
sh ./scripts/create-service-account.sh <GCP_PROJECT_ID> [ACCOUNT_NAME]
# ie sh ./scripts/create-service-account.sh rad-domain

# Setup local shell
. ./scripts/export-env.sh

# Setup credentials
sh ./scripts/decode-service-account-from-env.sh

# Create state bucket
sh scripts/create-terraform-state-bucket.sh <GCP_PROJECT_ID> [BUCKET_NAME]
# ie sh scripts/create-terraform-state-bucket.sh rad-domain

tofu init
tofu plan
tofu apply
```

<!-- TRIGGER RUN -->
