# Cloud

Repo for holding sample IaC and cloud config files for testing Snyk integration

### Project Multiple Providers

Multiple Providers

A single Terraform AWS provider is limited to an account and a specific region.
What if we want to deploy resources within the same stack but in two regions. This need is not as remote as you can imagine, it’s actually a pretty common use case.

When you use a CloudFront Distribution with a custom SSL certificate you have to create an ACM certificate in N.Virginia.

So here we have a small example of a CloudFront distribution in Ireland and the needed ACM Certificate in N.Virginia, all within the same stack and even within the same file --> main.tf in the repo.

> Also added security scan results using Snyk IaC
