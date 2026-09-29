# OpenAI

Last checked: 2026-09-29, from the provider definition and OpenAI's API docs; not yet run against the live gateway.

## App key

`openai`. Host: `https://api.openai.com`. DadConnect injects `Authorization: Bearer <the user's stored OpenAI key>` and a JSON content type. **Do not send an Authorization header for OpenAI.**

## Reads

```bash
api https://connect-api.daho.ai/openai/v1/models
api "https://connect-api.daho.ai/openai/v1/files?limit=10"
api "https://connect-api.daho.ai/openai/v1/fine_tuning/jobs?limit=5"
```

## Writes and risks

- Generation calls (`/v1/responses`, `/v1/chat/completions`, `/v1/embeddings`, `/v1/images/...`, `/v1/audio/...`) **cost money on the user's OpenAI account**, even a single one, and can be large. Ask before the first one, saying what you will call and roughly what it costs, and ask again before sending many.
- Fine-tuning, file upload and deletion calls create billable jobs or remove data.

## Notes

- Costs scale with tokens; keep prompts and `max_output_tokens` small for tests.
- Do not send the user's private data to a model unless the task requires it and they agreed.
- `429` from OpenAI is the user's own OpenAI rate limit, not the gateway's.
