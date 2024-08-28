# Google Cloud Postgres Image

![Docker Image Version](https://img.shields.io/badge/version-latest-blue.svg)

This Docker image is designed for use of the Google Cloud SDK and Postgres client. This can be used for example to perform backups of a Postgres instance to Google Cloud Storage.

## Features

- **Base Image**: Built on the latest image of the google cloud SDK
- **Postgres Client**: The Postgres client is installed in the image

## Installation

You can pull this image from Docker Hub by running:

```bash
docker pull arthurdw/cloud-sdk-pg:latest
```

## Usage

This image is intended for use in pods or cron jobs that need to interact with Google Cloud and Postgres. You can run the image interactively to use the Google Cloud SDK and Postgres client:

```bash
docker run -it --rm arthurdw/cloud-sdk-pg
```

Once inside the container, you can use `kubectl` to manage your Kubernetes resources. For example:

```bash
kubectl get pods
```

## Example Deployment

You can use it in a Kubernetes cron job:

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: postgres-backup
spec:
  schedule: "0 2 * * *"
  jobTemplate:
    spec:
      template:
        spec:
          serviceAccountName: impersonator-sa
          containers:
            - name: backup
              image: arthurdw/cloud-sdk-pg:latest
              command: ["/bin/sh", "-c"]
              args:
                - |
                  gcloud config set auth/impersonate_service_account impersonated-sa@<project-id>.iam.gserviceaccount.com &&

                  TIMESTAMP=$(date +%Y%m%d%H%M%S) &&
                  BACKUP_FILE="/tmp/backup_$TIMESTAMP.sql" &&
                  pg_dump -h postgres -U postgres -F c -b -v -f $BACKUP_FILE postgres &&
                  gsutil cp $BACKUP_FILE gs://<your-bucket-name>/backups/
          restartPolicy: OnFailure
```

## Contributing

If you have suggestions for improvements or new features, feel free to submit a pull request or open an issue in this repository.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
