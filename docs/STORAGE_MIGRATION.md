# Storage Migration Runbook (Phase 4)

This guide covers migrating user-uploaded files from local disk (`./uploads`) to AWS S3 without downtime or data loss.

## Overview

| Mode | Env vars | Behavior |
|------|----------|----------|
| **Local** (default) | `STORAGE_TYPE=local` or unset | Files stored under `{user.dir}/uploads`, served at `/uploads/{key}` |
| **S3** | `STORAGE_TYPE=s3` + `S3_BUCKET` set | New uploads go to S3; public URL from `S3_PUBLIC_BASE_URL` or bucket URL |

Existing DB rows store paths like `/uploads/uuid_filename.jpg`. The app continues to serve those URLs through `UploadsController`, which reads from the active `StorageService` and falls back to legacy on-disk paths during migration.

## Pre-migration checklist

1. Create an S3 bucket (e.g. `fightdfear-uploads-prod`) in your target region.
2. Enable bucket versioning (recommended).
3. Configure IAM credentials with `s3:PutObject`, `s3:GetObject`, `s3:DeleteObject`, `s3:ListBucket`.
4. (Optional) Attach a CloudFront distribution and set `S3_PUBLIC_BASE_URL` to the CDN origin.
5. Back up the local `./uploads` directory:

   ```bash
   tar -czf uploads-backup-$(date +%Y%m%d).tar.gz uploads/
   ```

## Step 1 — Sync existing files to S3

From the application server (or any machine with AWS CLI access):

```bash
# Dry run first
aws s3 sync ./uploads s3://YOUR_BUCKET/ --dryrun

# Actual sync — keys match local filenames (flat layout)
aws s3 sync ./uploads s3://YOUR_BUCKET/ --acl private
```

Alternatively with `rsync` to an EC2 staging host, then `aws s3 sync`:

```bash
rsync -avz --progress ./uploads/ user@staging:/tmp/uploads/
ssh user@staging "aws s3 sync /tmp/uploads/ s3://YOUR_BUCKET/"
```

Verify object count:

```bash
aws s3 ls s3://YOUR_BUCKET/ --recursive | wc -l
ls uploads/ | wc -l   # should match (approximately)
```

## Step 2 — Dual-read period (recommended)

Deploy with S3 as the write backend while keeping local files in place:

```env
STORAGE_TYPE=s3
S3_BUCKET=your-bucket-name
S3_REGION=ap-south-1
S3_ACCESS_KEY=...
S3_SECRET_KEY=...
S3_PUBLIC_BASE_URL=https://your-cdn.example.com   # optional
```

During this period:

- **New uploads** → S3 only.
- **Existing `/uploads/...` URLs** → `UploadsController` tries S3 first via `StorageService.readResource()`, then falls back to local `./uploads` and legacy temp paths.
- **Do not delete** local `./uploads` until validation is complete.

Monitor 404 rates on `/uploads/**` for one full release cycle.

## Step 3 — Cutover validation

1. Spot-check random files from the DB:

   ```sql
   SELECT profile_photo FROM user LIMIT 20;
   -- Open each /uploads/... URL in browser; confirm 200 OK
   ```

2. Upload a new test image/video; confirm it lands in S3 and is reachable.

3. Compare S3 object count vs. expected file count after sync.

## Step 4 — Decommission local storage (optional)

After dual-read validation (typically 1–2 weeks):

1. Confirm zero 404s on legacy paths in logs.
2. Archive local uploads (keep backup per retention policy).
3. Remove local fallback code only when product owner approves (not required for Phase 4).

Local files are **never auto-deleted** by the application.

## Rollback

If issues arise after enabling S3:

```env
STORAGE_TYPE=local
# unset or leave S3 vars empty
```

Restart the app. New uploads return to `./uploads`. Files already in S3 remain there but are not read unless you switch back.

## Environment reference

| Variable | Required | Description |
|----------|----------|-------------|
| `STORAGE_TYPE` | No | `local` (default) or `s3` |
| `S3_BUCKET` | Yes for S3 | Bucket name |
| `S3_REGION` | No | AWS region (default `ap-south-1`) |
| `S3_ACCESS_KEY` | No* | Explicit access key; omit to use instance/task role |
| `S3_SECRET_KEY` | No* | Secret for explicit credentials |
| `S3_PUBLIC_BASE_URL` | No | CDN or custom public base; trailing slash optional |

\* If both access key and secret are blank, the AWS SDK default credential chain is used (IAM role, env, profile).

## Limits (enforced on upload)

| Category | Max size | Notes |
|----------|----------|-------|
| Image | 5 MB | MIME must start with `image/` |
| Video | 200 MB | MIME must start with `video/` |
| Document | 20 MB | PDF, Office formats |
| General | 200 MB | Auto-detected category |

Dangerous extensions (`.exe`, `.jsp`, `.html`, `.php`, etc.) are rejected.

## Troubleshooting

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| 403 on S3 upload | IAM policy | Grant `s3:PutObject` on bucket/prefix |
| 404 on old URLs | File not synced | Re-run `aws s3 sync` |
| App still uses local | `S3_BUCKET` empty | Set both `STORAGE_TYPE=s3` and `S3_BUCKET` |
| Wrong public URL | CDN misconfig | Set `S3_PUBLIC_BASE_URL` |
