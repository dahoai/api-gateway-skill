# Google Business Profile

Last checked: 2026-09-30. Host routing (`DAHO-Host`) checked against the live gateway; the Google calls are from Google's Business Profile API docs and have not yet been run with a real connection.

## App key

`google-my-business`. Host: `https://mybusinessaccountmanagement.googleapis.com` (the Business Profile account management API only).

## Reads

```bash
api https://connect-api.daho.ai/google-my-business/v1/accounts
```

## Writes and risks

Account management calls such as changing admins or transferring ownership affect who controls a business listing. Ask the user before any `POST`, `PATCH` or `DELETE`.

## Notes

- Locations, reviews and other Business Profile data live on other Google hosts. Reach them with the `DAHO-Host` header:
  - locations: `api -H 'DAHO-Host: mybusinessbusinessinformation.googleapis.com' 'https://connect-api.daho.ai/google-my-business/v1/accounts/123/locations?readMask=name,title,storefrontAddress'`
  - reviews: `api -H 'DAHO-Host: mybusiness.googleapis.com' https://connect-api.daho.ai/google-my-business/v4/accounts/123/locations/456/reviews`
- Replying to or deleting reviews is public: ask the user first.
- The user must have granted the Business Profile permission when connecting; a `403` means they did not.
