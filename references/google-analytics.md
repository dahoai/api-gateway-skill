# Google Analytics

Last checked: 2026-09-30. Host routing checked against the live gateway (default host and `DAHO-Host`); the Google calls below are from Google's Analytics Data and Admin API docs and have not yet been run with a real Analytics connection.

## App key

`google-analytics`. Default host: `https://analyticsdata.googleapis.com` (the Analytics Data API, for reports). Account and property lists live on `analyticsadmin.googleapis.com`: send `DAHO-Host: analyticsadmin.googleapis.com` to reach it. Auth is the user's Google OAuth grant; reading needs the `analytics.readonly` permission.

## Reads

Find the property first (Admin API):

```bash
api -H 'DAHO-Host: analyticsadmin.googleapis.com' https://connect-api.daho.ai/google-analytics/v1beta/accountSummaries
```

Each `propertySummaries[].property` is an id like `properties/123456789`. Then run a report (Data API, the default host). `runReport` is a `POST` that only reads data. The rule that every `POST` needs the user's approval still applies: say what the report will fetch and ask once (through the MCP server it goes through `api_write`).

```bash
api -X POST -H 'Content-Type: application/json' \
  https://connect-api.daho.ai/google-analytics/v1beta/properties/123456789:runReport \
  -d '{"dateRanges":[{"startDate":"28daysAgo","endDate":"today"}],"dimensions":[{"name":"date"}],"metrics":[{"name":"activeUsers"},{"name":"sessions"}]}'
```

Useful metrics: `activeUsers`, `sessions`, `screenPageViews`, `conversions`, `totalRevenue`. Useful dimensions: `date`, `country`, `sessionSource`, `pagePath`, `deviceCategory`.

## Writes and risks

The Admin API can change properties, data streams and user access. Do not call any Admin API `POST`, `PATCH` or `DELETE` without the user's explicit approval.

## Notes

- `DAHO-Host` only accepts `*.googleapis.com` hosts, and only for Google apps.
- Search performance data comes from `google-search-console`, not here.
- A `403` with `insufficientPermissions` means the connection lacks the Analytics permission: the user must reconnect and grant it.
