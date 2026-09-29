# Google Analytics

Last checked: 2026-09-29, from the provider definition; not yet run against the live gateway.

## App key

`google-analytics`. It is an alias of the `google` integration, so its host is `https://www.googleapis.com`.

## Reads

No supported read is known. Modern Google Analytics reporting (the Analytics Data API) and account settings (the Admin API) live on other hosts (`analyticsdata.googleapis.com`, `analyticsadmin.googleapis.com`), which the gateway cannot reach: each app has one fixed host, and overriding it is deliberately blocked.

If the user asks for Google Analytics data, tell them plainly that it is not available through the gateway yet, and that DAHO would need to add a host-specific integration. Do not try workarounds.

## Writes and risks

None applicable.

## Notes

- Search performance data is available through `google-search-console` instead.
- Do not try the older `www.googleapis.com/analytics/...` endpoints without checking Google's docs; several are retired.
