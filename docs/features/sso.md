# Single Sign On (SSO)

Streamline user authentication with Rately's Single Sign On feature. Enable secure, one-click sign-in using GitHub or Google accounts, eliminating the need for users to create and manage separate Rately credentials.

<div class="grid cards" markdown>

-   :material-github:{ .lg .middle } __GitHub Integration__

    ---

    Sign in seamlessly with your GitHub account. Perfect for developer teams and organizations already using GitHub.

-   :material-google:{ .lg .middle } __Google Integration__

    ---

    Use your Google account for quick access. Ideal for teams using Google Workspace or Gmail.

-   :material-shield-check:{ .lg .middle } __Enhanced Security__

    ---

    Leverage OAuth 2.0 security standards with no additional passwords to manage or remember.

-   :material-lightning-bolt:{ .lg .middle } __Instant Setup__

    ---

    Get started in seconds. No complex configuration or SAML setup required.

</div>

## Benefits

### :material-account-multiple: **Simplified User Management**
- No need to create separate Rately accounts
- Automatically inherit permissions from your GitHub organization or Google Workspace
- Reduce password fatigue for your team

### :material-security: **Enhanced Security**
- OAuth 2.0 authentication with industry-standard security
- Multi-factor authentication through your existing provider
- Reduced attack surface with fewer credentials to manage

### :material-rocket-launch: **Faster Onboarding**
- Team members can access Rately instantly with existing accounts
- No waiting for account activation emails
- Seamless integration with existing workflows

## Getting Started

### GitHub SSO Setup

1. **Organization Admin Setup**
   ```bash
   # Navigate to your Rately organization settings
   # Enable GitHub SSO under Authentication
   # Authorize Rately to access your GitHub organization
   ```

2. **User Sign-In Process**
   - Visit [rately.dev](https://rately.dev/)
   - Click "Sign in with GitHub"
   - Authorize Rately to access your basic profile information
   - You're automatically signed in and ready to use Rately

3. **Permissions Mapping**
   ```yaml
   # GitHub organization roles map to Rately permissions:
   github_role: rately_permission
   owner: admin
   member: user
   outside_collaborator: readonly
   ```

### Google SSO Setup

1. **Organization Admin Setup**
   ```bash
   # Navigate to your Rately organization settings
   # Enable Google SSO under Authentication
   # Configure your Google Workspace domain (optional)
   ```

2. **User Sign-In Process**
   - Visit [rately.dev](https://rately.dev/)
   - Click "Sign in with Google"
   - Select your Google account
   - Grant permission for Rately to access your profile
   - Start using Rately immediately

3. **Domain Restrictions**
   ```yaml
   # Optionally restrict to specific domains:
   allowed_domains:
     - yourcompany.com
     - yourdomain.org
   # Or allow any Google account (default)
   ```

## Configuration Examples

### Team Onboarding Workflow

```yaml
# Example: Developer team setup
sso_provider: github
organization: your-org
auto_provision: true
default_role: user

# New team members automatically get access when they:
# 1. Join your GitHub organization
# 2. Sign in to Rately with GitHub SSO
# 3. Automatically assigned 'user' role
```

### Enterprise Google Workspace

```yaml
# Example: Enterprise Google setup
sso_provider: google
workspace_domain: company.com
admin_emails:
  - admin@company.com
  - devops@company.com
auto_provision: true
require_domain_match: true
```

### Mixed Authentication

```yaml
# Support both SSO and traditional accounts
authentication_methods:
  - sso_github
  - sso_google
  - email_password

# Users can choose their preferred sign-in method
fallback_auth: email_password
```

## Integration with Rately Features

### API Access with SSO

```javascript
// Your SSO-authenticated session automatically includes API access
const response = await fetch('https://api.rately.dev/policies', {
  headers: {
    'Authorization': `Bearer ${sso_session_token}`
  }
});
```

### Rate Limiting by SSO Identity

```yaml
policies:
  - id: sso_user_limits
    match: /api/*
    key: "sso_user:{sso.user_id}"
    limit: 1000
    window_seconds: 3600
    
  - id: github_org_limits
    match: /api/*
    key: "github_org:{sso.github.org}"
    limit: 50000
    window_seconds: 3600
```

### Team-Based Overrides

```yaml
policies:
  - id: team_based_limits
    match: /api/*
    key: "user:{sso.user_id}"
    limit: 100
    window_seconds: 60
    overrides:
      - when: { sso.github.team: "platform-team" }
        limit: 10000
      - when: { sso.google.domain: "enterprise.com" }
        limit: 5000
```

## Troubleshooting

### Common Issues

#### "Unable to sign in with GitHub"

!!! warning "Check Organization Settings"
    
    Ensure your GitHub organization has authorized the Rately application:
    
    1. Go to GitHub Organization Settings → Third-party access
    2. Find "Rately" in the list
    3. Click "Grant" if not already authorized

#### "Google sign-in fails"

!!! tip "Domain Configuration"
    
    If you've configured domain restrictions:
    
    1. Verify your email domain is in the allowed list
    2. Check if your admin has enabled Google Workspace integration
    3. Try signing in with a different Google account

#### "Access denied after successful SSO"

!!! note "Role Assignment"
    
    Contact your Rately organization admin to verify:
    
    - Your SSO account is mapped to the correct role
    - Auto-provisioning is enabled for new users
    - Your GitHub/Google account has the required permissions

### Getting Help

If you encounter issues not covered here:

- **GitHub Issues**: Check organization membership and permissions
- **Google Domains**: Verify Workspace admin settings
- **Role Mapping**: Contact your Rately organization administrator
- **Technical Support**: Email support@rately.dev with your SSO provider and error details

## Security Considerations

### Data Access

Rately only requests minimal permissions from your SSO provider:

- **GitHub**: Public profile information, organization membership
- **Google**: Basic profile information (name, email, profile picture)

### Session Management

- SSO sessions follow your provider's security policies
- Multi-factor authentication is inherited from your SSO provider
- Sessions can be revoked from either Rately or your SSO provider

### Compliance

- SOC 2 Type II compliant authentication flow
- GDPR compliant data handling
- Support for SAML and advanced enterprise features available on request

## FAQ

??? question "Can I use both GitHub and Google SSO for the same organization?"

    Yes! Organizations can enable multiple SSO providers. Users can choose their preferred sign-in method each time they access Rately.

??? question "What happens to existing accounts when enabling SSO?"

    Existing email/password accounts continue to work normally. Users can optionally link their SSO accounts to existing Rately accounts through account settings.

??? question "Can I restrict SSO to specific GitHub organizations or Google domains?"

    Yes! Organization admins can configure domain restrictions for Google SSO and organization membership requirements for GitHub SSO.

??? question "How are user permissions determined with SSO?"

    Permissions are mapped from your SSO provider:
    
    - **GitHub**: Based on organization role (owner → admin, member → user)
    - **Google**: Based on domain membership and admin-configured rules
    - **Manual**: Admins can override automatic role assignment

??? question "What if my SSO provider is down?"

    If you have fallback authentication enabled, users can sign in with email/password. For SSO-only setups, access is dependent on your SSO provider's availability.

??? question "Can I audit SSO sign-ins?"

    Yes! All SSO authentication events are logged in your Rately organization audit log, including successful sign-ins, failed attempts, and permission changes.

---

Ready to enable SSO for your team? Contact your organization admin or [get started](https://rately.dev/) with Rately today!