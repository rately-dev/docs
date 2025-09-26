# Overview

Rately is a configurable, per-identity rate limiting service that runs at Cloudflare's edge. Block abusive traffic before it reaches your servers. Limit by user ID, API key, header, query, or URL param — not just IP.

<div class="center" markdown>
[Get Started →](home/get-started.md){ .md-button .md-button--primary } [Documentation →](home/get-started.md){ .md-button }
</div>

<br>

<div class="grid cards" markdown>

-   :material-speedometer:{ .lg .middle } __Edge Enforcement__

    ---

    Block rate-limited requests at Cloudflare's edge with ~25ms added latency. Traffic never reaches your origin.

-   :material-account-key:{ .lg .middle } __Flexible Identity__

    ---

    Rate limit by user ID, API key, header, query param, or custom attributes — not just IP addresses.

-   :material-swap-horizontal:{ .lg .middle } __Drop-in Integration__

    ---

    CNAME your API through Rately (proxy mode) or call our Decision API — zero code changes required.

-   :material-chart-line:{ .lg .middle } __Real-time Analytics__

    ---

    Track usage patterns, identify top consumers, and monitor rate limit hits with detailed analytics.

</div>

## Why Choose Rately?

### Built for Scale
Running on Cloudflare's global network with 300+ locations worldwide, Rately handles millions of requests per second with atomic counters via Durable Objects.

### Instant Configuration
Change rate limits on the fly. Override limits for specific users. No redeploys needed — changes take effect globally in seconds.

### Developer Friendly
Simple REST API, SDKs for major languages, and comprehensive documentation. Integrate in minutes, not days.

### Usage-Based Billing Ready
Track and aggregate usage data per customer. Export to Stripe or your billing system for metered billing and overage charges.

## How It Works

### Proxy Mode (Recommended)
```
Client → api.yourapp.com (CNAME) → Rately Edge → Your Origin
```
Traffic flows through Rately. We check limits and forward allowed requests to your origin with rate limit headers.

### Control Plane Mode
```
Client → Your API → POST /check (Rately) → Allow/Deny Response
```
Your application calls Rately's Decision API to check if a request should be allowed.

## Key Features

- **Token Bucket & Sliding Window** algorithms for precise rate limiting
- **Custom Policies** per endpoint, method, or resource
- **Override Rules** for VIP users or specific conditions
- **Signed Configurations** with automatic edge distribution
- **Fail-Safe Modes** (open/closed/soft) for reliability
- **DDoS Protection** integration with Cloudflare WAF

## Example Configuration

```yaml
policies:
  - id: api_standard
    match: /api/*
    key: "user:{header.x-api-key}"
    limit: 1000
    window_seconds: 60

  - id: api_premium
    match: /api/*
    key: "user:{header.x-api-key}"
    limit: 10000
    window_seconds: 60
    overrides:
      - when: { header.x-plan: "enterprise" }
        limit: unlimited
```

---

<div class="center" markdown>
[Get started for free →](https://rately.dev/){ .md-button .md-button--primary }
</div>