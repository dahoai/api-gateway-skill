# Anaella

Last checked: 2026-09-29, from the provider definition only; the endpoint list is not known and nothing has been run against the live gateway.

## App key

`anaella`. Host: `https://api.anaella.com`. Auth is the user's Anaella OAuth grant. Product site: https://anaella.com.

## Reads

No endpoint is confirmed here. Read Anaella's own API documentation before calling anything, start with a small `GET`, and do not guess paths. Anaella is a social scheduling tool, so read calls are likely to list channels and posts.

## Writes and risks

Creating, scheduling or deleting a post publishes (or unpublishes) content on the user's social accounts. Get the user's explicit approval with the exact text, channels and time.

## Notes

- This page will be expanded after the first verified calls.
