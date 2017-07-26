# BRAKEMAN REPORT

| Application path                         | Rails version | Brakeman version | Started at                | Duration         |
|------------------------------------------|---------------|------------------|---------------------------|------------------|
| /Users/kishore/Work/language-translation | 4.2.1         | 3.7.0            | 2017-07-26 17:29:28 +0530 | 1.603935 seconds |

| Checks performed                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       |
|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| BasicAuth, BasicAuthTimingAttack, ContentTag, CreateWith, CrossSiteScripting, DefaultRoutes, Deserialize, DetailedExceptions, DigestDoS, DynamicFinders, EscapeFunction, Evaluation, Execute, FileAccess, FileDisclosure, FilterSkipping, ForgerySetting, HeaderDoS, I18nXSS, JRubyXML, JSONEncoding, JSONParsing, LinkTo, LinkToHref, MailTo, MassAssignment, MimeTypeDoS, ModelAttrAccessible, ModelAttributes, ModelSerialize, NestedAttributes, NestedAttributesBypass, NumberToCurrency, QuoteTableName, Redirect, RegexDoS, Render, RenderDoS, RenderInline, ResponseSplitting, RouteDoS, SQL, SQLCVEs, SSLVerify, SafeBufferManipulation, SanitizeMethods, SelectTag, SelectVulnerability, Send, SendFile, SessionManipulation, SessionSettings, SimpleFormat, SingleQuotes, SkipBeforeFilter, StripTags, SymbolDoSCVE, TranslateBug, UnsafeReflection, ValidationRegex, WithoutProtection, XMLDoS, YAMLParsing |

### SUMMARY

| Scanned/Reported  | Total |
|-------------------|-------|
| Controllers       | 17    |
| Models            | 10    |
| Templates         | 78    |
| Errors            | 0     |
| Security Warnings | 8 (2) |

| Warning Type         | Total |
|----------------------|-------|
| Cross Site Scripting | 5     |
| Denial of Service    | 2     |
| SQL Injection        | 1     |

### SECURITY WARNINGS

| Confidence | Class | Method | Warning Type                                                                                          | Message                                                                                                                              |
|------------|-------|--------|-------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------|
| High       |       |        | [Cross Site Scripting](https://groups.google.com/d/msg/ruby-security-ann/8B2iV2tPRSE/JkjCJkSoCgAJ)    | Rails 4.2.1 content_tag does not escape double quotes in attribute values (CVE-2016-6316). Upgrade to 4.2.7.1 near line 237          |
| High       |       |        | [SQL Injection](https://groups.google.com/d/msg/ruby-security-ann/WccgKSKiPZA/9DrsDVSoCgAJ)           | Rails 4.2.1 contains a SQL injection vulnerability (CVE-2016-6317). Upgrade to 4.2.7.1 near line 237                                 |
| Medium     |       |        | [Cross Site Scripting](https://groups.google.com/d/msg/rubyonrails-security/7VlB_pck3hU/3QZrGIaQW6cJ) | Rails 4.2.1 does not encode JSON keys (CVE-2015-3226). Upgrade to Rails version 4.2.2 near line 237                                  |
| Medium     |       |        | [Cross Site Scripting](https://groups.google.com/d/msg/rubyonrails-security/OU9ugTZcbjc/PjEP46pbFQAJ) | rails-html-sanitizer 1.0.2 is vulnerable (CVE-2015-7579). Upgrade to 1.0.3 near line 237                                             |
| Medium     |       |        | [Cross Site Scripting](https://groups.google.com/d/msg/rubyonrails-security/uh--W4TDwmI/JbvSRpdbFQAJ) | rails-html-sanitizer 1.0.2 is vulnerable (CVE-2015-7578). Upgrade to 1.0.3 near line 237                                             |
| Medium     |       |        | [Cross Site Scripting](https://groups.google.com/d/msg/rubyonrails-security/uh--W4TDwmI/m_CVZtdbFQAJ) | rails-html-sanitizer 1.0.2 is vulnerable (CVE-2015-7580). Upgrade to 1.0.3 near line 237                                             |
| Medium     |       |        | [Denial of Service](https://groups.google.com/d/msg/rubyonrails-security/9oLY_FCzvoc/w9oI9XxbFQAJ)    | Rails 4.2.1 is vulnerable to denial of service via mime type caching (CVE-2016-0751). Upgrade to Rails version 4.2.5.1 near line 237 |
| Medium     |       |        | [Denial of Service](https://groups.google.com/d/msg/rubyonrails-security/bahr2JLnxvk/x4EocXnHPp8J)    | Rails 4.2.1 is vulnerable to denial of service via XML parsing (CVE-2015-3227). Upgrade to Rails version 4.2.2 near line 237         |

