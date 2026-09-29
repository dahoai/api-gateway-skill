# OpenAI organization admin

Last checked: 2026-09-29, from the provider definition and OpenAI's API docs; not yet run against the live gateway. Admin endpoints and their parameters change; confirm against OpenAI's Administration API docs.

## App key

`openai-admin`. Host: `https://api.openai.com`. DadConnect injects the stored **admin** key. This key can manage the whole organization, so use it only for the exact task and never print anything that looks like a key.

## Reads

```bash
# cost per day (start_time is a unix timestamp in seconds)
api "https://connect-api.daho.ai/openai-admin/v1/organization/costs?start_time=1790000000&bucket_width=1d&limit=7"
# token usage
api "https://connect-api.daho.ai/openai-admin/v1/organization/usage/completions?start_time=1790000000&bucket_width=1d"
api https://connect-api.daho.ai/openai-admin/v1/organization/projects
api https://connect-api.daho.ai/openai-admin/v1/organization/users
```

## Writes and risks

Creating or deleting API keys, projects, users, invites or service accounts changes who can spend on the account and who has access. Every such call needs the user's explicit approval naming the target. Never create a key just to test something.

## Notes

- Responses contain user emails and project names: treat them as private.
- Use the regular `openai` app for model calls; this app is only for administration and reporting.
