resource "google_compute_security_policy" "php_waf" {
  name        = "php-hardening-waf-policy"
  description = "Cloud Armor WAF policy adapted for PHP2Shell (CVE-2026-109618 / CVE-2026-109619) mitigations"

  # Rule 1: Rate Limit POST requests to prevent worker exhaustion / DoS
  rule {
    action   = "rate_based_ban"
    priority = 1000
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    rate_limit_options {
      conform_action = "allow"
      exceed_action  = "deny_429"
      rate_limit_threshold {
        count        = 50
        interval_sec = 60
      }
      ban_threshold {
        count        = 200
        interval_sec = 60
      }
      ban_duration_sec = 300
      enforce_on_key   = "IP"
      # Scope down to POST requests commonly targeted by exploits
      http_method      = "POST"
    }
    description = "Rate limit aggressive POST requests to mitigate rapid worker cycling"
  }

  # Rule 2: Block PHP Session Upload Progress abuse vector (CVE-2026-109619 defense-in-depth)
  rule {
    action   = "deny(403)"
    priority = 1100
    match {
      expr {
        expression = "request.method == 'POST' && request.content.contains('PHP_SESSION_UPLOAD_PROGRESS')"
      }
    }
    description = "Block payloads attempting to trigger PHP session upload progress tracking"
  }

  # Rule 3: Optional - Block multipart/form-data if your app does not support file uploads
  # (Uncomment this rule if your application doesn't require file uploads)
  /*
  rule {
    action   = "deny(403)"
    priority = 1200
    match {
      expr {
        expression = "has(request.headers['content-type']) && request.headers['content-type'].contains('multipart/form-data')"
      }
    }
    description = "Block multipart/form-data requests if application has no upload features"
  }
  */

  # Rule 4: Block sensitive administrative paths at the edge
  rule {
    action   = "deny(403)"
    priority = 2000
    match {
      expr {
        expression = "request.path.matches('/admin')"
      }
    }
    description = "Block sensitive administrative paths at the edge"
  }

  # Rule 5: Default Allow
  rule {
    action   = "allow"
    priority = 2147483647
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "Default allow rule"
  }
}
