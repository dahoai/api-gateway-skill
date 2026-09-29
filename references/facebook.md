# Facebook (Graph API)

Last checked: 2026-09-29, from the provider definition and Meta's Graph API docs; not yet run against the live gateway. Graph API versions and permissions change; confirm against Meta's docs.

## App key

`facebook`. Host: `https://graph.facebook.com`. Auth is the user's Facebook OAuth grant.

## Reads

```bash
api "https://connect-api.daho.ai/facebook/me?fields=id,name"
api "https://connect-api.daho.ai/facebook/me/accounts?fields=id,name"
```

`me/accounts` lists the Pages the user manages. Request only `id,name`: by default this call can also return Page access tokens.

## Writes and risks

- `POST /{page-id}/feed` publishes a public post on a Page. Photo, video and comment endpoints publish too.
- Ad and campaign endpoints under `act_{ad-account-id}` create or change advertising and spend money.

Get the user's explicit approval with the exact content, Page and budget.

## Notes

- **Page access tokens are credentials, and Page-token endpoints are not supported through the gateway.** The gateway does not forward your `Authorization` header, so the only way to use a Page token would be putting it in the URL (`?access_token=`), which breaks the no-secrets-in-URLs rule. Never request the `access_token` field, and if a response contains one, do not print, store or use it.
- Because of that, most Page publishing and Page-insight calls will fail with a permission error (`(#200)` or `(#10)`) through the gateway. Tell the user rather than working around it.
- Pagination: `paging.cursors.after`, or follow `paging.next`.
