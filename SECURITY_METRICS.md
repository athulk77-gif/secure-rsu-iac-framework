# RSU IaC Security Framework — Scan Metrics

## Baseline Deployment Scan

Tool: Checkov  
Scope: Terraform RSU infrastructure (pre-guardrail hardening)

Passed checks: 21  
Failed checks: 13  

Key issues detected:

- Missing CMK encryption
- Broad IAM resource scope
- No DLQ for Lambda
- No log encryption
- No env var encryption
- No tracing
- Missing invoke source restriction

---

## Guardrail Framework Scan

Tool: Checkov  
Scope: Secure module + guardrail controls applied

Passed checks: 37  
Failed checks: 3  

Remaining accepted risks:

- Lambda code signing not enabled (out of scope)
- Lambda concurrency guardrail limited by account quota
- Lambda not inside VPC (cost + scope tradeoff)

---

## Measured Improvement

Failed checks reduced: 13 → 3  
Reduction: 76.9%

Pass rate improved significantly after guardrail framework applied.

This demonstrates measurable security posture improvement through Infrastructure-as-Code guardrails.
