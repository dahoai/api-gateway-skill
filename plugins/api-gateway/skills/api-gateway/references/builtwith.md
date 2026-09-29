# BuiltWith

Last checked: 2026-09-29, from the provider definition only; the request path and version below are not confirmed and nothing has been run against the live gateway. Confirm the current endpoint in BuiltWith's API docs before use.

## App key

`builtwith`. Host: `https://api.builtwith.com`. DadConnect adds the account's `KEY=` query parameter automatically. **Do not send a key yourself.**

## Reads

BuiltWith looks up which technologies a website uses. The domain lookup takes a `LOOKUP` query parameter; the current path (for example `/v21/api.json?LOOKUP=example.com`) must be confirmed in the docs, because BuiltWith versions its API. Start with one lookup of a single domain the user named.

## Writes and risks

This API is read-only. The risk is cost: lookups can use the plan's credits, so do not loop over many domains without the user's agreement.

## Notes

- Results can be large for big sites; ask only for what the task needs.
