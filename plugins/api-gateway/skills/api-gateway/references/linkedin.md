# LinkedIn

Last checked: 2026-09-29, from the provider definition and LinkedIn's API docs; not yet run against the live gateway. LinkedIn changes versions and permissions often: confirm each call against the current docs.

## App key

`linkedin`. Host: `https://api.linkedin.com`. Auth is the user's LinkedIn OAuth grant; what works depends on the products and scopes granted.

## Reads

```bash
# the connected member's basic profile (needs the openid/profile scopes)
api https://connect-api.daho.ai/linkedin/v2/userinfo
```

The versioned REST APIs (`/rest/...`) need two request headers that you must send yourself: `LinkedIn-Version: YYYYMM` (a current version from LinkedIn's docs) and `X-Restli-Protocol-Version: 2.0.0`. No other read example is confirmed here; use LinkedIn's docs and start with a small `GET`.

## Writes and risks

- `POST /rest/posts` publishes publicly under the user's name or a company page.
- Messaging and connection calls contact real people.

These need the user's explicit approval with the full text of what will be posted or sent.

## Notes

- Many LinkedIn APIs require an approved product on the app; a `403` usually means the product or scope is missing, which the user cannot fix from here.
