-- =============================================
-- STAGING MODEL: Phishing URL Dataset
-- =============================================
-- Purpose: Prepare phishing data for the ML model
-- Source: URL_DATABASE.PUBLIC.PHISING_URL_DATASET
-- Row count: 579,920 (unchanged)
--
-- What it does:
-- 1. Selects all features from the dataset
-- 2. Adds a risk category based on label
-- 3. Highlights the has_mx_record feature (phishing sites rarely have a mail server)
-- 4. Adds a timestamp for traceability
-- =============================================

SELECT
    -- IDENTIFIER
    URL AS url_identifier,      -- Unique URL as identifier

    -- TARGET VARIABLE
    LABEL,                      -- 1 = phishing, 0 = legitimate

    -- ALL FEATURES FROM THE DATASET (74 total)
    -- Lexical features (53 total)
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

    -- DNS features (9 total)
    success,
    dns_resolves,
    has_mx_record,              -- IMPORTANT: Phishing sites rarely have a mail server (MX record)
    has_txt_record,
    has_ns_record,
    ttl_value,
    ip_count,
    cname_count,
    resolves_to_private_ip,

    -- WHOIS features (12 total)
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

    -- CALCULATED FIELDS (for easier analysis)
    -- Categorizes risk based on label
    CASE 
        WHEN LABEL = 1 THEN 'phishing'    -- 1 → phishing
        WHEN LABEL = 0 THEN 'legitimate'  -- 0 → legitimate
        ELSE 'unknown'
    END AS risk_category,

    -- CALCULATED FIELDS (for ML)
    -- Converts label to binary (already 0/1, but kept for clarity)
    LABEL AS label_binary,

    -- METADATA (for traceability)
    CURRENT_TIMESTAMP() AS processed_at

FROM {{ source('snowflake', 'PHISING_URL_DATASET') }}