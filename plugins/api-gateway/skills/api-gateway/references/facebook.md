# Facebook (Graph API)

Last checked: 2026-09-29, from the provider definition and Meta's Graph API docs; not yet run against the live gateway. Graph API versions and permissions change; confirm against Meta's docs.

## App key

`facebook`. Host: `https://graph.facebook.com`. Auth is the user's Facebook OAuth grant.

## Reads

```bash
api "https://gateway.daho.ai/facebook/me?fields=id,name"
api "https://gateway.daho.ai/facebook/me/accounts?fields=id,name"
```

`me/accounts` lists the Pages the user manages. Request only `id,name`: by default this call can also return Page access tokens.

## Writes and risks

- `POST /{page-id}/feed` publishes a public post on a Page. Photo, video and comment endpoints publish too.
- Ad and campaign endpoints under `act_{ad-account-id}` create or change advertising and spend money.

Get the user's explicit approval with the exact content, Page and budget.

## Notes

- **Page access tokens are credentials.** If a response contains an `access_token`, never print, log or store it. Do not ask for the `access_token` field unless a specific Page endpoint requires it, and use it only for the current task.
- Many Page endpoints need a Page token and specific permissions; a `(#200)` or `(#10)` error means the permission is missing.
- Pagination: `paging.cursors.after`, or follow `paging.next`.
