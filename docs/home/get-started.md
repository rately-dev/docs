# Get Started with Rately

Set up rate limiting for your API in minutes. Block abusive traffic at the edge before it reaches your servers.

## What is Rately?

Rately is a rate limiting service that runs on Cloudflare's global edge network. Unlike traditional rate limiting that runs on your servers, Rately blocks excessive traffic before it ever reaches your origin. Key benefits:

- **Edge enforcement** - ~25ms added latency, blocks at 300+ locations worldwide
- **Flexible identity** - Limit by user ID, API key, header, query param — not just IP
- **Drop-in integration** - No code changes required
- **Instant configuration** - Update limits on the fly without redeploys

## Quick Start

### Step 1: Sign Up

1. Visit [rately.dev](https://rately.dev/)
2. Create your account
3. Get your API credentials

### Step 2: Choose Integration Mode

#### Option 1: Proxy Mode (Recommended)
Point your API traffic through Rately. Zero code changes required.

```
api.yourapp.com → CNAME → origin.rately.dev
```

#### Option 2: Decision API
Your application calls Rately to check if requests should be allowed.

```bash
POST /check
Authorization: Bearer <your-token>

{
  "key": "user:123",
  "policy_id": "api_standard"
}
```

### Step 3: Configure Your First Policy

Create a basic rate limiting policy:

```yaml
policies:
  - id: api_standard
    match: /api/*
    key: "ip:{ip}"           # Start with IP-based limiting
    limit: 100
    window_seconds: 60        # 100 requests per minute
```

### Step 4: Test Your Setup

#### For Proxy Mode:
```bash
# Make requests to your API
curl -i https://api.yourapp.com/users

# Check rate limit headers
# RateLimit-Limit: 100
# RateLimit-Remaining: 99
# RateLimit-Reset: 58
```

#### For Decision API:
```bash
curl -X POST https://api.rately.dev/check \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"key": "user:123", "policy_id": "api_standard"}'
```

## Common Configurations

### Per-User Rate Limiting
```yaml
policies:
  - id: user_limits
    match: /api/*
    key: "user:{header.x-user-id}"
    limit: 1000
    window_seconds: 3600    # 1000 requests per hour
```

### API Key Based Limits
```yaml
policies:
  - id: api_key_limits
    match: /api/*
    key: "key:{header.x-api-key}"
    limit: 10000
    window_seconds: 86400   # 10k requests per day
```

### Different Limits by Plan
```yaml
policies:
  - id: tiered_limits
    match: /api/*
    key: "user:{jwt.sub}"
    limit: 100              # Free tier default
    window_seconds: 3600
    overrides:
      - when: { jwt.plan: "pro" }
        limit: 1000
      - when: { jwt.plan: "enterprise" }
        limit: unlimited
```

### Expensive Endpoint Protection
```yaml
policies:
  - id: ai_endpoint
    match: POST /api/ai/generate
    key: "user:{header.x-user-id}"
    limit: 10
    window_seconds: 3600    # Only 10 AI calls per hour
```

## Integration Examples

### Node.js / Express
```javascript
// No code changes needed for Proxy Mode!
// For Decision API:
app.use(async (req, res, next) => {
  const decision = await fetch('https://api.rately.dev/check', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${RATELY_TOKEN}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      key: `user:${req.user.id}`,
      policy_id: 'api_standard'
    })
  });

  if (!decision.ok) {
    return res.status(429).json({ error: 'Rate limit exceeded' });
  }

  next();
});
```

### Python / FastAPI
```python
# No code changes needed for Proxy Mode!
# For Decision API:
@app.middleware("http")
async def rate_limit_middleware(request: Request, call_next):
    response = requests.post(
        "https://api.rately.dev/check",
        headers={"Authorization": f"Bearer {RATELY_TOKEN}"},
        json={
            "key": f"user:{request.headers.get('x-user-id')}",
            "policy_id": "api_standard"
        }
    )

    if response.status_code == 429:
        return JSONResponse(
            status_code=429,
            content={"error": "Rate limit exceeded"}
        )

    return await call_next(request)
```

## Monitoring & Analytics

### View Real-time Metrics
- Active rate limits
- Top consumers
- Blocked requests
- Usage patterns

### Set Up Alerts
- When specific users hit limits
- When overall traffic spikes
- When policies block > X% of traffic

## Next Steps

1. **Add More Policies** - Create specific limits for different endpoints
2. **Configure Overrides** - Give VIP users higher limits
3. **Enable Analytics** - Track usage patterns and optimize limits
4. **Set Up Billing Integration** - Export usage data to Stripe for metered billing
5. **Test Fail Modes** - Configure behavior when Rately is unreachable

## Need Help?

- **Documentation**: Full API reference and guides
- **Support**: Contact support@rately.dev
- **Status**: status.rately.dev

---

Ready to protect your API? [Start free trial](https://rately.dev/) today!