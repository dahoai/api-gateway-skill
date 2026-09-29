# Google Business Profile

Last checked: 2026-09-29, from the provider definition; not yet run against the live gateway.

## App key

`google-my-business`. Host: `https://mybusinessaccountmanagement.googleapis.com` (the Business Profile account management API only).

## Reads

```bash
api https://gateway.daho.ai/google-my-business/v1/accounts
```

## Writes and risks

Account management calls such as changing admins or transferring ownership affect who controls a business listing. Ask the user before any `POST`, `PATCH` or `DELETE`.

## Notes

- Most Business Profile data (locations, reviews, posts, insights) is served by other hosts (for example `mybusinessbusinessinformation.googleapis.com`), which the gateway cannot reach. If the user asks for reviews or locations, tell them it is not available through the gateway yet.
- The user must have granted the Business Profile permission when connecting; a `403` means they did not.
