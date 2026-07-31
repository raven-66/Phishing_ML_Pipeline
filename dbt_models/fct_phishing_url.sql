-- =============================================
-- MAIN ML MODEL: Phishing URL Features
-- =============================================
-- Purpose: Create a ready-to-use feature table for machine learning
-- Source: stg_phishing_url (staging model above)
-- Row count: 579,920 (unchanged)
--
-- What it does:
-- 1. Uses the cleaned data from staging
-- 2. Keeps all features and label
-- 3. Adds extra ML features (e.g., suspicious_score)
-- =============================================

SELECT
    -- IDENTIFIER
    url_identifier,

    -- TARGET VARIABLE
    label_binary,               -- 1 = phishing, 0 = legitimate

    -- ALL FEATURES (from staging)
    -- Lexical features
    url_length,
    domain_length,
    hostname_length,
    path_length,
    first_dir_length,
    tld_length,
    tld_length_domain,
    url_depth,
    query_length,
    path_segments_count,
    num_digits,
    num_letters,
    num_special_chars,
    num_dots,
    num_hyphens,
    num_at,
    num_percent,
    num_equals,
    num_question,
    num_ampersand,
    num_hash,
    num_underscore,
    num_special,
    num_slash,
    num_params,
    entropy_url,
    entropy_hostname,
    entropy_domain,
    entropy_path,
    query_entropy,
    ratio_digits,
    ratio_letters,
    ratio_special_chars,
    uppercase_ratio,
    lowercase_ratio,
    is_ip_address,
    starts_with_ip,
    is_suspicious_tld,
    uses_https,
    has_www,
    unusual_double_slash,
    multiple_http,
    contains_port_number,
    path_has_encoded_chars,
    query_has_base64,
    contains_login,
    contains_secure,
    contains_verify,
    contains_account,
    contains_update,
    contains_bank,
    contains_cloud,
    contains_brand,
    query_key_count,
    query_value_length_avg,

    -- DNS features
    success,
    dns_resolves,
    has_mx_record,              -- IMPORTANT: Phishing sites rarely have a mail server
    has_txt_record,
    has_ns_record,
    ttl_value,
    ip_count,
    cname_count,
    resolves_to_private_ip,

    -- WHOIS features
    whois_success,
    domain_age_days,
    expiration_days,
    creation_year,
    domain_is_recent,
    domain_registered_before_2020,
    registrar_valid,
    name_servers_count,
    is_privacy_protected,
    whois_missing,

    -- CALCULATED FEATURES (for the ML model)
    -- Sums key features into a "suspicious_score"
    -- Higher score = more suspicious
    (num_digits + num_special_chars + num_hyphens) AS suspicious_char_count,

    -- Entropy-based risk (high entropy = more random = more suspicious)
    (entropy_url + entropy_path + entropy_domain) AS total_entropy,

    -- CATEGORICAL FEATURES (from staging)
    risk_category,              -- 'phishing', 'legitimate', 'unknown'

    -- NUMERIC RISK SCORE (for ML algorithms that require numbers)
    CASE 
        WHEN LABEL = 1 THEN 1   -- Phishing → high risk
        ELSE 0                  -- Legitimate → low risk
    END AS risk_score

FROM {{ ref('stg_phishing_url') }}