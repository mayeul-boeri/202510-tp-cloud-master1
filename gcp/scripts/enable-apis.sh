#!/usr/bin/env bash
# Enable required Google Cloud APIs for this project.
# Usage: PROJECT=your-project-id ./enable-apis.sh
set -euo pipefail
PROJECT=${PROJECT:-}
if [ -z "$PROJECT" ]; then
  echo "Usage: PROJECT=your-project-id $0" >&2
  exit 2
fi
APIS=(
  compute.googleapis.com
  servicenetworking.googleapis.com
  iam.googleapis.com
  cloudresourcemanager.googleapis.com
  storage.googleapis.com
  sqladmin.googleapis.com
)
for api in "${APIS[@]}"; do
  echo "Enabling $api for project $PROJECT..."
  gcloud services enable "$api" --project="$PROJECT"
done

echo "All requested APIs enabled. Wait a few minutes for propagation before retrying terraform."